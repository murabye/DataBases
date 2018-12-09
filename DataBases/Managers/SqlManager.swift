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
    
    func setSelectedDb(toId dbId: Int32) {
        connectedDataBaseId = dbId
    }
    
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
    
    func addTable(_ name:String, toDb dbId:Int32, withColumns columns:[columnModel], andRelations relations:[relationModel]) {
        
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
                    query = "INSERT INTO masks (min_value, max_value, max_length) VALUES (?, ?, ?)"
                    if !db.executeUpdate(query, withArgumentsIn: [convertOpt(mask.min_value), convertOpt(mask.min_value), convertOpt(mask.max_length)]) {
                        rollback.pointee = true
                        return
                    }
                    maskId = db.lastInsertRowId
                }
                query = "INSERT INTO colums (id_table, name, type, id_mask, unique, not_null, primary_key) VALUES (?, ?, ?, ?, ?, ?, ?)"
                if !db.executeUpdate(query, withArgumentsIn: [tableId, column.name, column.type, convertOpt(maskId), column.unique, column.not_null, column.primary_key]) {
                    rollback.pointee = true
                    return
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

                    query = "INSERT INTO colums (id_table, name, type, id_mask, unique, not_null, primary_key) VALUES (?, ?, ?, ?, ?, ?, ?)"
                    if !db.executeUpdate(query, withArgumentsIn: [tableId, table2name, "id", "NULL", "false", relation.relation_type < 4, "false"]) {
                        rollback.pointee = true
                        return
                    }
                }
                
                query = "CREATE TABLE \(String(dbId) + name) ( id integer PRIMARY KEY"
                for column in columns {
                    query += ","
                    query += " " + column.name
                    query += " " + column.type
                    query += column.not_null ? " NOT NULL" : ""
                    query += column.unique ? " UNIQUE" : ""
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
                            query += table2name + "_id"
                            query += ") REFERENCES (id"
                            query += ") ON DELETE CASCADE ON UPDATE NO ACTION"
                        }
                    default:
                        var queryForRasprTable = "CREATE TABLE system_"
                        queryForRasprTable += name + "_" + table2name
                        queryForRasprTable += "(id integer PRIMARY KEY, "
                        queryForRasprTable += "FOREIGN KEY (table1_id) REFERENCES \(name) (id) ON DELETE CASCADE ON UPDATE NO ACTION, "
                        queryForRasprTable += "FOREIGN KEY (table2_id) REFERENCES \(table2name) (id) ON DELETE CASCADE ON UPDATE NO ACTION)"
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
    }
    
    //MARK:- user data
    
    func getData(ofTable tableName:String, withId id:Int32) -> [[(data: Any?, type: columnType, columnName: String)]] {
        let queryGetColumns = "SELECT * FROM colums WHERE id_table = ?"
        let resultSetColumns: FMResultSet? = db!.executeQuery(queryGetColumns, withArgumentsIn: [id])
        var resultColumns:[(type: String, name: String)] = []
        while (resultSetColumns!.next()) {
            let name = resultSetColumns?.string(forColumn: "name")
            let type = resultSetColumns?.string(forColumn: "type")
            resultColumns.append((type!, name!))
        }
        
        var queryForGetData = "SELECT (id"
        for column in resultColumns {
            queryForGetData = queryForGetData + ", " + column.name
        }
        
        queryForGetData = queryForGetData + ") FROM ?"
        let resultSetData: FMResultSet? = db!.executeQuery(queryForGetData, withArgumentsIn: [String(connectedDataBaseId) + tableName])
        
        var resultData:[[(data: Any?, type: columnType, columnName: String)]] = []
        while resultSetData!.next() {
            var tableStr: [(data: Any?, type: columnType, columnName: String)] = []
            
            for column in resultColumns {
                let typ = column.type
                let realType = columnType(rawValue: typ)
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
                    data = resultSetData?.int(forColumn: nam)
                default:
                    data = nil
                }
                
                tableStr.append((data: data, type: realType!, columnName: nam))
            }
            resultData.append(tableStr)
        }
        
        return resultData
    }
    
    func addData(toTable name: String, withId id: Int32, data: Dictionary<String, Any>) {
        let queue:FMDatabaseQueue? = FMDatabaseQueue(path: self.dbFilePath)
        
        queue?.inTransaction { db, rollback in
            let tableName = String(connectedDataBaseId) + name
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
    
    //MARK:- relations :3
    func getRelation() {
        // tableName
        // table2name + "_id"
    }
    
    //MARK:- help
    private func convertOpt(_ optional:Any?) -> String {
        return optional != nil ? optional! as! String : "NULL"
    }
    private func convertStringOpt(_ optional:Any?) -> String {
        return optional != nil ? "'" + (optional! as! String) + "'" : "NULL"
    }
}
