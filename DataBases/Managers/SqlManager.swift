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
    
    //MARK:- init and opening
    var dbFilePath:String = ""
    let DATABASE_RESOURCE_NAME = "db"
    let DATABASE_RESOURCE_TYPE = "sqlite"
    let DATABASE_FILE_NAME = "db.sqlite"
    var db:FMDatabase? = nil
    
    private init() {
    }
    
    func initializeDb() -> Bool {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
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
    
    func addDatabase(_ name:String) {
        let query = "INSERT INTO databases (name) VALUES ('\(name)')"
        let addSuccessful = db!.executeUpdate(query, withArgumentsIn: [])
        if !addSuccessful {
            print("insert failed: \(db!.lastErrorMessage())")
        }
    }
    
    //MARK:- tables
    func getTableList(forDbId dbId:Int32) -> [(Int32, String)]  {
        let query = "SELECT id_table, name FROM tables WHERE id_database = \(dbId)"
        let resultSet: FMResultSet? = db!.executeQuery(query, withArgumentsIn: [])
        var result:[(Int32, String)] = []
        
        while (resultSet!.next()) {
            let name = resultSet?.string(forColumn: "name")
            let ind = resultSet?.int(forColumn: "id_table")
            result.append((ind!, name!))
        }
        return result
    }
    
    func addTable(_ name:String, toDb dbId:Int32, withColumns columns:[columnModel], andRelations relations:[relationModel]) {
        let queue:FMDatabaseQueue? = FMDatabaseQueue(path: self.dbFilePath)

        queue?.inTransaction { db, rollback in
            var query = "INSERT INTO tables (name, id_database) VALUES ('\(name)', \(dbId))"
            if !db.executeUpdate(query, withArgumentsIn: []) {
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
                query = "INSERT INTO colums (id_table, name, type, id_mask, unique, not_null, primary_key) VALUES (\(tableId), '\(column.name)', \(column.type), \(convertOpt(maskId)), \(column.unique), \(column.not_null), \(column.primary_key))"
                if !db.executeUpdate(query, withArgumentsIn: []) {
                    rollback.pointee = true
                    return
                }
                
                for relation in relations {
                    query = "INSERT INTO relations (id_table1, id_table2, relation_type) VALUES (\(relation.id_table1), \(relation.id_table2), \(relation.relation_type)"
                    if !db.executeUpdate(query, withArgumentsIn: []) {
                        rollback.pointee = true
                        return
                    }
                }
                
                query = "CREATE TABLE \(name) ( id integer PRIMARY KEY"
                for column in columns {
                    query += ","
                    query += " " + column.name
                    query += " " + column.type
                    query += column.not_null ? " NOT NULL" : ""
                    query += column.unique ? " UNIQUE" : ""
                }
                
                for relation in relations {
                    let queryForTable2Name = "SELECT name FROM tables WHERE id_table == \(relation.id_table2)"
                    let resultSet: FMResultSet? = db.executeQuery(queryForTable2Name, withArgumentsIn: [])
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
    func getData(ofTable tableName:String, withId id:Int32) -> [(String, String)] {
        let queryGetColumns = "SELECT * FROM colums WHERE id_table = \(id)"
        let resultSetColumns: FMResultSet? = db!.executeQuery(queryGetColumns, withArgumentsIn: [])
        // name - type
        var resultColumns:[(String, String)] = []
        
        while (resultSetColumns!.next()) {
            let name = resultSetColumns?.string(forColumn: "name")
            let type = resultSetColumns?.string(forColumn: "type")
            resultColumns.append((type!, name!))
        }
        
        let queryGetRelations = "SELECT * FROM relations WHERE table1_id = \(tableName)"
        let resultGetRelations: FMResultSet? = db!.executeQuery(queryGetRelations, withArgumentsIn: [])
        // tableName
        var resultRelations:[String] = []
        while (resultGetRelations!.next()) {
            let rowid:Int32 = (resultGetRelations?.int(forColumn: "table2_id"))!
            
            let queryGetTable2Name = "SELECT name FROM tables WHERE id = \(rowid)"
            let resultGetRelations: FMResultSet? = db!.executeQuery(queryGetTable2Name, withArgumentsIn: [])
            while (resultGetRelations!.next()) {
                resultRelations.append((resultGetRelations?.string(forColumn: "name"))!)
            }
        }
        
        let queryForGetData = "SELECT * FROM \(tableName))"
        let resultSetData: FMResultSet? = db!.executeQuery(queryForGetData, withArgumentsIn: [])
        // data - type
        var resultData:[(String, String)] = []
        
        
        while (resultSetColumns!.next()) {
            for column in resultColumns {
                let userCellValue = resultSetData?.string(forColumn: column.0)
                resultData.append((userCellValue!, column.1))
            }
            for relation in resultRelations {
                resultData.append((relation, "id"))
            }
        }
        return resultData
    }
    
    func getData(ofTable tableName:String, withId id:Int32, inConnected connected:String) -> [(String, String)] {
        return []
    }
    
    func addData() {
        
    }
    
    
    //MARK:- help
    private func convertOpt(_ optional:Any?) -> String {
        return optional != nil ? optional! as! String : "NULL"
    }
    private func convertStringOpt(_ optional:Any?) -> String {
        return optional != nil ? "'" + (optional! as! String) + "'" : "NULL"
    }
}
