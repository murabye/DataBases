//
//  SqlManager.swift
//  DataBases
//
//  Created by варя on 06/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class SqlManager {
    
    static let shared = SqlManager()
    public var connectedDataBaseId: Int32 = 0
    public var selectedTableId: Int32 = 0
    public var selectedTableName: String = ""
    public var isAdmin: Bool = false

    //MARK:- init and opening
    var dbFilePath:String = ""
    let DATABASE_RESOURCE_NAME = "db"
    let DATABASE_RESOURCE_TYPE = "sqlite"
    let DATABASE_FILE_NAME = "db.sqlite"
    var db:FMDatabase? = nil
    
    private init() {
        if self.initializeDb() {
            print("SUCCESS")
        }
    }
    
    func initializeDb() -> Bool {
        let documentFolderPath = "/Users/varya/Documents/DataBases/DataBases/Managers"// NSSearchPathForDirectoriesInDomains(.developerApplicationDirectory, .userDomainMask, true)[0] as String
        
        let dbfile = "/" + DATABASE_FILE_NAME;
        
        self.dbFilePath = documentFolderPath.appendingFormat(dbfile)
        
        let filemanager = FileManager.default
        if (!filemanager.fileExists(atPath: dbFilePath as String) ) {
            let backupDbPath = Bundle.main.path(forResource: DATABASE_RESOURCE_NAME, ofType: DATABASE_RESOURCE_TYPE)
            
            if (backupDbPath == nil) {
                return false
            } else {
                do {
                    try filemanager.copyItem(atPath: backupDbPath!, toPath: dbFilePath as String)
                } catch  {
                    print("copy failed")
                    return false
                }
            }
        }
        
        self.db = FMDatabase(path: dbFilePath as String)
        
        if (!self.db!.open()) {
            print("error opening db")
        }
        return true
    }
    
    //MARK:- DB
    // получить список баз данных
    func getDatabaseList() -> [(Int32, String)] {
        let query = "SELECT * FROM databases"
        let resultSet: FMResultSet? = db!.executeQuery(query, withArgumentsIn: [])
        var result:[(Int32, String)] = []
    
        while (resultSet!.next()) {
            let name = resultSet?.string(forColumn: "name")
            let ind = resultSet?.int(forColumn: "id_database")
            result.append((ind!, name!))
        }
        return result
    }
    
    // сеттер connectedDataBaseId
    func setSelectedDb(toId dbId: Int32) {
        connectedDataBaseId = dbId
    }
    
    // добавить бд в список
    func addDatabase(_ name:String) {
        let currentDbs = getDatabaseList()
        if currentDbs.contains(where: { (arg0:(Int32, String)) -> Bool in
            return arg0.1 == name
        }) {
            return
        }
        
        let query = "INSERT INTO databases (name) VALUES (?)"
        let addSuccessful = db!.executeUpdate(query, withArgumentsIn: [name])
        if !addSuccessful {
            print("insert failed: \(db!.lastErrorMessage())")
        }
    }
    
    //MARK:- tables
    // взять список всех таблиц
    func getTableList(forDbId dbId:Int32) -> [(Int32, String)]  {
        let query = "SELECT id_table, name FROM tables WHERE id_database = ?"
        let resultSet: FMResultSet? = db!.executeQuery(query, withArgumentsIn: [dbId])
        var result:[(Int32, String)] = []
        
        while (resultSet!.next()) {
            let name = resultSet?.string(forColumn: "name")
            let ind = resultSet?.int(forColumn: "id_table")
            result.append((ind!, name!))
        }
        return result
    }
    
    // создать таблицу, где
    // name - имя таблицы
    // dbId - идентификатор БД (приходит вместе со списком)
    // colums - колонки базы данных, простые (в этом методе сюда не писать те, которые columntype id)
    // relations - это как раз отношение. name для relations - название колонки. создавать relation от дочерней таблицы
    func addTable(_ name:String, toDb dbId:Int32, withColumns columns:[ColumnModel], andRelations relations:[RelationModel]) {
        
        var columnsForTable = columns
        var addRelateToCreateQuery = ""
        
        let currentTables = getTableList(forDbId: dbId)
        if currentTables.contains(where: { (arg0:(Int32, String)) -> Bool in
            return arg0.1 == name
        }) {
            return
        }
        
        let queue:FMDatabaseQueue? = FMDatabaseQueue(path: self.dbFilePath)

        queue?.inTransaction { db, rollback in
            var query = "INSERT INTO tables (name, id_database) VALUES (?, ?)"
            if !db.executeUpdate(query, withArgumentsIn: [name, dbId]) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
            let tableId = db.lastInsertRowId
            
            query = "INSERT INTO colums (id_table, name, type, id_mask, is_unique, not_null, primary_key) VALUES (\(tableId), 'id', 'integer', NULL, false, false, true)"
            if !db.executeUpdate(query, withArgumentsIn: []) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
            
            for column in columnsForTable {
                var maskId:Int64? = nil
                if let mask = column.mask {                    
                    query = "INSERT INTO masks (min_value, max_value, max_lenght) VALUES (\(convertOpt(mask.min_value)), \(convertOpt(mask.min_value)), \(convertOpt(mask.max_length)))"
                    if !db.executeUpdate(query, withArgumentsIn: []) {
                        print(db.lastError())
                        rollback.pointee = true
                        return
                    }
                    maskId = db.lastInsertRowId
                }
                query = "INSERT INTO colums (id_table, name, type, id_mask, is_unique, not_null, primary_key) VALUES (\(tableId), '\(column.name)', '\(column.type)', \(convertOpt(maskId)), \(column.isUnique), \(column.not_null), \(column.primary_key))"
                if !db.executeUpdate(query, withArgumentsIn: []) {
                    print(db.lastError())
                    rollback.pointee = true
                    return
                }
            }
            for relation in relations {
                query = "INSERT INTO relations (id_table1, id_table2, relation_type, name) VALUES (?, ?, ?, ?)"
                if !db.executeUpdate(query, withArgumentsIn: [tableId, relation.id_table2, relation.relation_type, relation.name]) {
                    print(db.lastError())
                    rollback.pointee = true
                    return
                }
                
                let queryForTable2Name = "SELECT name FROM tables WHERE id_table == ?"
                let resultSet: FMResultSet? = db.executeQuery(queryForTable2Name, withArgumentsIn: [relation.id_table2])
                resultSet!.next()
                let table2name:String = resultSet!.string(forColumn: "name")! + String(connectedDataBaseId)

                query = "INSERT INTO colums (id_table, name, type, id_mask, is_unique, not_null, primary_key) VALUES (?, ?, ?, ?, ?, ?, ?)"
                if !db.executeUpdate(query, withArgumentsIn: [tableId, relation.name, "id", "NULL", "false", "false", "false"]) {
                    print(db.lastError())
                    rollback.pointee = true
                    return
                }
                
                columnsForTable.append(
                    ColumnModel(
                        id_table: Int32(tableId),
                        name: relation.name,
                        type: .id,
                        mask: nil,
                        isUnique: false,
                        not_null: false,
                        primary_key: false
                    )
                )
                
                addRelateToCreateQuery += ", FOREIGN KEY ("
                addRelateToCreateQuery += relation.name
                addRelateToCreateQuery += ") REFERENCES "
                addRelateToCreateQuery += table2name
                addRelateToCreateQuery += "(id) ON DELETE NO ACTION ON UPDATE NO ACTION"
                
            }
            
            query = "CREATE TABLE \(name + String(dbId)) (id integer PRIMARY KEY"
            
            for column in columnsForTable {
                query += ","
                query += " " + column.name
                query += " " + (String(column.type.rawValue) == "id" ? "integer" : String(column.type.rawValue))
                query += column.not_null ? " NOT NULL" : ""
                query += column.isUnique ? " UNIQUE" : ""
            }
            
            
            query += addRelateToCreateQuery + ")"
            
            if !db.executeUpdate(query, withArgumentsIn: []) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
        }
    }
    
    //MARK:- user data
    // Получить данные из таблицы по указанному ID
    // дает массив кортежей таблицы
    // то есть это матрица вот такая
    // [ [ячейка ячейка ячейка ]
    //   [ячейка ячейка ячейка ]
    //   [ячейка ячейка ячейка ] ]
    // тут массив [ячейка ячейка ячейка ] - это кортеж
    // ячейка - это одна штучка из трех данных: data значение, type тип значения, columnName имя колонки
    func getData(withId id:Int32) -> [[(data: Any?, type: ColumnType, columnName: String)]] {
        let queryTableName = "SELECT name FROM tables WHERE id_table = ?"
        let resultSetTabName: FMResultSet? = db!.executeQuery(queryTableName, withArgumentsIn: [id])
        resultSetTabName?.next()
        let tableName = resultSetTabName?.string(forColumn: "name")!

        let queryGetColumns = "SELECT * FROM colums WHERE id_table = ?"
        let resultSetColumns: FMResultSet? = db!.executeQuery(queryGetColumns, withArgumentsIn: [id])
        var resultColumns:[(type: String, name: String)] = []
        while (resultSetColumns!.next()) {
            let name = resultSetColumns?.string(forColumn: "name")
            let type = resultSetColumns?.string(forColumn: "type")
            resultColumns.append((type!, name!))
        }
        
        var queryForGetData = "SELECT "
        for column in resultColumns {
            queryForGetData = queryForGetData + column.name + ", "
        }
        let queryRange = queryForGetData.index(queryForGetData.endIndex, offsetBy: -2)..<queryForGetData.endIndex
        queryForGetData.removeSubrange(queryRange)

        
        queryForGetData = queryForGetData + " FROM \(tableName! +  String(connectedDataBaseId))"
        let resultSetDataRaw: FMResultSet? = db!.executeQuery(queryForGetData, withArgumentsIn: [])
        
        guard let resultSetData = resultSetDataRaw else {
            return [];
        }
        
        var resultData:[[(data: Any?, type: ColumnType, columnName: String)]] = []
        while resultSetData.next() {
            var tableStr: [(data: Any?, type: ColumnType, columnName: String)] = []
            
            for column in resultColumns {
                let typ = column.type
                let realType = ColumnType(rawValue: typ)
                let nam = column.name
                var data: Any? = nil
                
                switch typ {
                case "text":
                    data = resultSetData.string(forColumn: nam)
                case "integer":
                    data = resultSetData.int(forColumn: nam)
                case "bool":
                    data = resultSetData.bool(forColumn: nam)
                case "id":
                    data = resultSetData.int(forColumn: nam)
                default:
                    data = nil
                }
                
                tableStr.append((data: data, type: realType!, columnName: nam))
            }
            
            resultData.append(tableStr)
        }
        
        return resultData
    }
    
    
    // добавить данные в таблицу
    // имя таблицы указать, id таблицы, данные
    // в данных: ключ - название столбика
    // значение - значение
    // для отношений ключ название столбца, значение - id
    func addData(toTable name: String, withId id: Int32, data: Dictionary<String, Any>) {
        let queue:FMDatabaseQueue? = FMDatabaseQueue(path: self.dbFilePath)
        
        queue?.inTransaction { db, rollback in
            let tableName = name + String(connectedDataBaseId)
            var addDataQuery = "INSERT INTO \(tableName) "
            var keys = ""
            var values = ""
            
            for column in data {
                keys = keys + column.key + ", "
                
                switch column.value {
                    case is String:
                        values = values + "\"" + (column.value as! String) + "\", "
                    case is Int32:
                        values = values + String(column.value as! Int32) + ", "
                    case is Bool:
                        values = values + ((column.value as! Bool) ? "true" : "false") + ", "
                    default:
                        values = values + ", "
                }
            }
            
            let keysRange = keys.index(keys.endIndex, offsetBy: -2)..<keys.endIndex
            let valuesRange = values.index(values.endIndex, offsetBy: -2)..<values.endIndex
            keys.removeSubrange(keysRange)
            values.removeSubrange(valuesRange)

            addDataQuery = addDataQuery + "(" + keys + ") VALUES (" + values + ")"
            
            if !db.executeUpdate(addDataQuery, withArgumentsIn: []) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
        }
    }
    
    // получить список столбиков для таблицы
    // также приходят столбики, в которых id
    func getColumnList(forTableId idTable: Int32) -> [(type: ColumnType, name: String, mask: Int32?)] {
        let queryGetColumns = "SELECT * FROM colums WHERE id_table = ?"
        let resultSetColumns: FMResultSet? = db!.executeQuery(queryGetColumns, withArgumentsIn: [idTable])
        var resultColumns:[(type: ColumnType, name: String, mask: Int32?)] = []
        while (resultSetColumns!.next()) {
            let name = resultSetColumns?.string(forColumn: "name")
            let type = ColumnType(rawValue: (resultSetColumns?.string(forColumn: "type")!)!)
            let mask = resultSetColumns?.data(forColumn: "mask")
            var maskInt: Int32? = nil
            
            if let maskNotNil = mask {
                maskInt = maskNotNil.withUnsafeBytes { (ptr: UnsafePointer<Int32>) -> Int32 in
                    return ptr.pointee
                }
            }
            
            resultColumns.append((type!, name!, maskInt))
        }
        
        return resultColumns
    }
    
    // get mask
    func getMaskData(maskId: Int32) -> (minValue: Int32?, maxValue: Int32?, max_length: Int32?) {
        let query = "SELECT * FROM masks WHERE id = ?"
        let resultSet: FMResultSet? = db!.executeQuery(query, withArgumentsIn: [maskId])
        var result: (minValue: Int32?, maxValue: Int32?, max_length: Int32?)?
        
        while (resultSet!.next()) {
            let minValue = resultSet?.data(forColumn: "min_value")
            let maxValue = resultSet?.data(forColumn: "max_value")
            let maxLength = resultSet?.data(forColumn: "max_lenght")
            
            var minValueInt: Int32? = nil
            var maxValueInt: Int32? = nil
            var maxLengthInt: Int32? = nil
            
            if let minNotNil = minValue {
                minValueInt = minNotNil.withUnsafeBytes { (ptr: UnsafePointer<Int32>) -> Int32 in
                    return ptr.pointee
                }
            }
            
            if let maxNotNil = maxValue {
                maxValueInt = maxNotNil.withUnsafeBytes { (ptr: UnsafePointer<Int32>) -> Int32 in
                    return ptr.pointee
                }
            }
            
            if let maxLNotNil = maxLength {
                maxLengthInt = maxLNotNil.withUnsafeBytes { (ptr: UnsafePointer<Int32>) -> Int32 in
                    return ptr.pointee
                }
            }
            
            result = (minValue: minValueInt, maxValue: maxValueInt, max_length: maxLengthInt)
        }
        
        return result!
    }
    
    
    //MARK:- related data
    // получить данные из таблицы связанной
    // id - айди текущей таблицы
    // dataId - id кортежа (строчки)
    // columnName - имя колонки, значение которой ищем
    func getRelateData(ofTableWithTableId id:Int32, forDataId dataId: Int32, forColumnName columnName: String) -> [[(data: Any?, type: ColumnType, columnName: String)]] {
        
        let queryRelation = "SELECT id_table1, id_table2 FROM relations WHERE name = ?"
        
        let resultSetRel: FMResultSet? = db!.executeQuery(queryRelation, withArgumentsIn: [columnName])
        resultSetRel!.next()
        var id1 = resultSetRel?.int(forColumn: "id_table1")
        var id2 = resultSetRel?.int(forColumn: "id_table2")
        
        if id2 == Int32(id) {
            id2 = id1
            id1 = Int32(id)
        }
        
        let queryTable2Name = "SELECT name FROM tables WHERE id_table = ?"
        let resultSetTabName: FMResultSet? = db!.executeQuery(queryTable2Name, withArgumentsIn: [id2!])
        resultSetTabName?.next()
        let table2name = resultSetTabName?.string(forColumn: "name")!
        
        let queryGetColumns = "SELECT * FROM colums WHERE id_table = ?"
        let resultSetColumns: FMResultSet? = db!.executeQuery(queryGetColumns, withArgumentsIn: [id2!])
        var resultColumns:[(type: String, name: String)] = []
        while (resultSetColumns!.next()) {
            let name = resultSetColumns?.string(forColumn: "name")
            let type = resultSetColumns?.string(forColumn: "type")
            resultColumns.append((type!, name!))
        }
        
        var queryForGetData = "SELECT id"
        for column in resultColumns {
            queryForGetData = queryForGetData + ", " + column.name
        }
        
        queryForGetData = queryForGetData + " FROM \(table2name! + String(connectedDataBaseId)) WHERE id = ?"
        let resultSetData: FMResultSet? = db!.executeQuery(queryForGetData, withArgumentsIn: [dataId])
        
        var resultData:[[(data: Any?, type: ColumnType, columnName: String)]] = []
        while resultSetData!.next() {
            var tableStr: [(data: Any?, type: ColumnType, columnName: String)] = []
            
            for column in resultColumns {
                let typ = column.type
                let realType = ColumnType(rawValue: typ)
                let nam = column.name
                var data: Any? = nil
                
                switch typ {
                case "text":
                    data = resultSetData?.string(forColumn: nam)
                case "integer":
                    data = resultSetData?.int(forColumn: nam)
                case "bool":
                    data = resultSetData?.bool(forColumn: nam)
                case "id":
                    data = nil
                default:
                    data = nil
                }
                
                tableStr.append((data: data, type: realType!, columnName: nam))
            }
            
            tableStr.append((data: resultSetData?.int(forColumn: "id"), type: ColumnType.integer, columnName: "id"))
            resultData.append(tableStr)
        }
        
        return resultData
    }
    
    // получить данные о таблице, с которой связана эта таблица
    // id - айди текущей таблицы
    // columnName - колонка
    func getRelateTable(ofTableWithTableId id:Int32, forColumnName columnName: String) -> (id: Int32, name: String) {
        let queryRelation = "SELECT id_table1, id_table2 FROM relations WHERE name = ?"
        
        let resultSetRel: FMResultSet? = db!.executeQuery(queryRelation, withArgumentsIn: [columnName, id, columnName, id])
        var id1: Int32? = nil
        var id2: Int32? = nil
        
        while resultSetRel!.next() {
            let curId1 = resultSetRel?.int(forColumn: "id_table1")
            let curId2 = resultSetRel?.int(forColumn: "id_table2")
            
            if curId1 != id && curId2 != id {
                continue
            }
            
            id1 = curId1
            id2 = curId2
        }
        
        let queryTableName = "SELECT name FROM tables WHERE id_table = ?"
        let resultSetTabName: FMResultSet? = db!.executeQuery(queryTableName, withArgumentsIn: [id2!])
        resultSetTabName?.next()

        return (id: id2!, name: (resultSetTabName!.string(forColumn: "name")!))
    }

    //MARK:- delete data
    // удалить данные из таблицы
    func deleteData(fromTableWithId tableId: Int32, dataId: Int32) {
        let queryTableName = "SELECT name FROM tables WHERE id_table = ?"
        let resultSetTabName: FMResultSet? = db!.executeQuery(queryTableName, withArgumentsIn: [tableId])
        resultSetTabName?.next()
        let table2name = resultSetTabName?.string(forColumn: "name")
        let table2fullName = table2name! + String(connectedDataBaseId)
        
        let queryDeleteData = "DELETE FROM \(table2fullName) WHERE id = ?"
        let deleteSuccessful = db!.executeUpdate(queryDeleteData, withArgumentsIn: [dataId])
        if !deleteSuccessful {
            print("delete failed: \(String(describing: db?.lastErrorMessage()))")
        }
    }
    
    // удалить всю таблицу
    func deleteTable(withId tableId: Int32) -> Bool {
        let queue:FMDatabaseQueue? = FMDatabaseQueue(path: self.dbFilePath)
        
        let query = "SELECT * FROM relations WHERE id_table2 = ?"
        let resultSet: FMResultSet? = db!.executeQuery(query, withArgumentsIn: [tableId])
        
        while (resultSet!.next()) {
            return false
        }
        
        queue?.inTransaction { db, rollback in
            //let queryTableName = "SELECT name FROM tables WHERE id_table = ?"
            //let resultSetTabName: FMResultSet? = db.executeQuery(queryTableName, withArgumentsIn: [tableId])
            //resultSetTabName?.next()
            //let tableName = resultSetTabName?.string(forColumn: "name")
            //let tableFullName = tableName! + String(connectedDataBaseId)

            let queryDeleteFromRelations = "DELETE FROM relations WHERE id_table1 = ? OR id_table2 = ?"
            if !db.executeUpdate(queryDeleteFromRelations, withArgumentsIn: [tableId, tableId]) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
            
            
            let queryDeleteFromColums = "DELETE FROM colums WHERE id_table = ?"
            if !db.executeUpdate(queryDeleteFromColums, withArgumentsIn: [tableId]) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
            
            let queryDeleteFromTables = "DELETE FROM tables WHERE id_table = ?"
            if !db.executeUpdate(queryDeleteFromTables, withArgumentsIn: [tableId]) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
        }
        return true
    }
    
    func deleteDataBase(withId dbId: Int32) {
        let tableList = getTableList(forDbId: dbId)
        
        let queue:FMDatabaseQueue? = FMDatabaseQueue(path: self.dbFilePath)

        queue?.inTransaction { db, rollback in
            let query = "DELETE FROM databases WHERE id_database = ?"
            if !db.executeUpdate(query, withArgumentsIn: [dbId]) {
                print(db.lastError())
                rollback.pointee = true
                return
            }
        }
        
        for table in tableList {
            deleteTable(withId: table.0)
        }
    }
    
    //MARK:- help
    private func convertOpt(_ optional:Any?) -> String {
        var data = ""
        
        guard let optional = optional else {
            return "NULL"
        }
        
        if optional is String{
            data = optional as! String
        }
        else if optional is Int32{
            data = String(optional as! Int32)
        }
        else if optional is Bool{
            data = (optional as! Bool) ? "true" : "false"
        }
        else if optional is Int64{
            data = String(optional as! Int64)
        }
        
        return data
    }
    private func convertStringOpt(_ optional:Any?) -> String {
        var data = ""
        
        guard let optional = optional else {
            return "NULL"
        }
        
        if optional is String{
            data = "'" + (optional as! String) + "'"
        }
        else if optional is Int32{
            data = String(optional as! Int32)
        }
        else if optional is Bool{
            data = (optional as! Bool) ? "true" : "false"
        }
        
        return data
    }
}
