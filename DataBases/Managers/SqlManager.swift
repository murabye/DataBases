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
        let documentFolderPath = "/Users/wolfram/Documents/DataBases/DataBases/Managers"// NSSearchPathForDirectoriesInDomains(.developerApplicationDirectory, .userDomainMask, true)[0] as String
        
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
                rollback.pointee = true
                return
            }
            let tableId = db.lastInsertRowId
            
            for column in columns {
                var maskId:Int64? = nil
                if let mask = column.mask {                    
                    query = "INSERT INTO masks (min_value, max_value, max_length) VALUES (\(convertOpt(mask.min_value)), \(convertOpt(mask.min_value)), \(convertOpt(mask.max_length))"
                    if !db.executeUpdate(query, withArgumentsIn: []) {
                        rollback.pointee = true
                        return
                    }
                    maskId = db.lastInsertRowId
                }
                query = "INSERT INTO colums (id_table, name, type, id_mask, is_unique, not_null, primary_key) VALUES (\(tableId), '\(column.name)', '\(column.type)', \(convertOpt(maskId)), \(column.isUnique), \(column.not_null), \(column.primary_key))"
                if !db.executeUpdate(query, withArgumentsIn: []) {
                    rollback.pointee = true
                    return
                }
            }
                for relation in relations {
                    query = "INSERT INTO relations (id_table1, id_table2, relation_type) VALUES (?, ?, ?)"
                    if !db.executeUpdate(query, withArgumentsIn: [relation.id_table1, relation.id_table2, relation.relation_type]) {
                        rollback.pointee = true
                        return
                    }
                    
                    let queryForTable2Name = "SELECT name FROM tables WHERE id_table == ?"
                    let resultSet: FMResultSet? = db.executeQuery(queryForTable2Name, withArgumentsIn: [relation.id_table2])
                    resultSet!.next()
                    let table2name:String = resultSet!.string(forColumn: "name")!

                    query = "INSERT INTO colums (id_table, name, type, id_mask, is_unique, not_null, primary_key) VALUES (?, ?, ?, ?, ?, ?, ?)"
                    if !db.executeUpdate(query, withArgumentsIn: [tableId, table2name, "id", "NULL", "false", "false", "false"]) {
                        rollback.pointee = true
                        return
                    }
                }
                
                query = "CREATE TABLE \(name + String(dbId)) (id integer PRIMARY KEY"
                for column in columns {
                    query += ","
                    query += " " + column.name
                    query += " " + String(column.type.rawValue)
                    query += column.not_null ? " NOT NULL" : ""
                    query += column.isUnique ? " UNIQUE" : ""
                }
                
                for relation in relations {
                    let queryForTable2Name = "SELECT name FROM tables WHERE id_table == ?"
                    let resultSet: FMResultSet? = db.executeQuery(queryForTable2Name, withArgumentsIn: [relation.id_table2])
                    resultSet!.next()
                    let table2name:String = resultSet!.string(forColumn: "name")!

                    switch relation.relation_type {
                    case 1,2,4,5:
                        if relation.id_table1 == tableId {
                            query += ", FOREIGN KEY ("
                            query += relation.name
                            query += ") REFERENCES (id"
                            query += ") ON DELETE CASCADE ON UPDATE NO ACTION"
                        }
                    default:
                        var queryForRasprTable = "CREATE TABLE system_"
                        queryForRasprTable += name + "_" + table2name
                        queryForRasprTable += "(id integer PRIMARY KEY, "
                        queryForRasprTable += "FOREIGN KEY (table1_id) REFERENCES \(name + String(connectedDataBaseId)) (id) ON DELETE CASCADE ON UPDATE NO ACTION, "
                        queryForRasprTable += "FOREIGN KEY (table2_id) REFERENCES \(table2name + String(connectedDataBaseId)) (id) ON DELETE CASCADE ON UPDATE NO ACTION)"
                        if !db.executeUpdate(queryForRasprTable, withArgumentsIn: []) {
                            rollback.pointee = true
                            return
                        }
                        break
                    }
                }
                query += ")"
                
                if !db.executeUpdate(query, withArgumentsIn: []) {
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
        
        var queryForGetData = "SELECT id"
        for column in resultColumns {
            queryForGetData = queryForGetData + ", " + column.name
        }
        
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
                    data = nil
                default:
                    data = nil
                }
                
                tableStr.append((data: data, type: realType!, columnName: nam))
            }
            
            tableStr.append((data: resultSetData.int(forColumn: "id"), type: ColumnType.integer, columnName: "id"))
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
                rollback.pointee = true
                return
            }
        }
    }
    
    // получить список столбиков для таблицы
    // также приходят столбики, в которых id
    func getColumnList(forTableId idTable: Int32) -> [(type: ColumnType, name: String)] {
        let queryGetColumns = "SELECT * FROM colums WHERE id_table = ?"
        let resultSetColumns: FMResultSet? = db!.executeQuery(queryGetColumns, withArgumentsIn: [idTable])
        var resultColumns:[(type: ColumnType, name: String)] = []
        while (resultSetColumns!.next()) {
            let name = resultSetColumns?.string(forColumn: "name")
            let type = ColumnType(rawValue: (resultSetColumns?.string(forColumn: "type")!)!)
            resultColumns.append((type!, name!))
        }
        
        return resultColumns
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
        
        let resultSetRel: FMResultSet? = db!.executeQuery(queryRelation, withArgumentsIn: [columnName])
        resultSetRel!.next()
        var id1 = resultSetRel?.int(forColumn: "id_table1")
        var id2 = resultSetRel?.int(forColumn: "id_table2")
        
        if id2 == Int32(id) {
            id2 = id1
            id1 = Int32(id)
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
        let deleteSuccessful = db!.executeUpdate(queryDeleteData, withArgumentsIn: [table2fullName, dataId])
        if !deleteSuccessful {
            print("delete failed: \(String(describing: db?.lastErrorMessage()))")
        }
    }
    
    // удалить всю таблицу
    func deleteTable(withId tableId: Int32) {
        let queue:FMDatabaseQueue? = FMDatabaseQueue(path: self.dbFilePath)
        
        queue?.inTransaction { db, rollback in

            let queryTableName = "SELECT name FROM tables WHERE id_table = ?"
            let resultSetTabName: FMResultSet? = db.executeQuery(queryTableName, withArgumentsIn: [tableId])
            resultSetTabName?.next()
            let tableName = resultSetTabName?.string(forColumn: "name")
            let tableFullName = tableName! + String(connectedDataBaseId)

            let queryDeleteFromTables = "DELETE FROM tables WHERE id_table = ?"
            if !db.executeUpdate(queryDeleteFromTables, withArgumentsIn: [tableId]) {
                rollback.pointee = true
                return
            }

            let queryDelete = "DROP TABLE IF EXISTS \(tableFullName)"
            if !db.executeUpdate(queryDelete, withArgumentsIn: []) {
                rollback.pointee = true
                return
            }
        }
    }
    
    //MARK:- help
    private func convertOpt(_ optional:Any?) -> String {
        return optional != nil ? optional! as! String : "NULL"
    }
    private func convertStringOpt(_ optional:Any?) -> String {
        return optional != nil ? "'" + (optional! as! String) + "'" : "NULL"
    }
}
