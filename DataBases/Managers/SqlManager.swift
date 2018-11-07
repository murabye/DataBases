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
    
    // TODO: дописать
    func addTable(_ name:String, toDb dbId:Int32, withColumns columns:[columnModel]) {
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
                    query = "INSERT INTO masks (min_value, max_value, string_mask, max_length) VALUES (\(convertOpt(mask.min_value)), \(convertOpt(mask.min_value)), \(convertStringOpt(mask.string_mask)), \(convertOpt(mask.max_length))"
                    if !db.executeUpdate(query, withArgumentsIn: []) {
                        rollback.pointee = true
                        return
                    }
                    maskId = db.lastInsertRowId
                }
                query = "INSERT INTO colums (id_table, name, default_value, type, id_mask, unique, not_null, auto_increment, primary_key) VALUES (\(tableId), '\(column.name)', '\(column.default_value)', \(column.type), \(convertOpt(maskId)), \(column.unique), \(column.not_null), \(column.auto_increment), \(column.primary_key))"
                if !db.executeUpdate(query, withArgumentsIn: []) {
                    rollback.pointee = true
                    return
                }
            }
            
        }

        
        
    }
    
    private func convertOpt(_ optional:Any?) -> String {
        return optional != nil ? optional! as! String : "NULL"
    }
    private func convertStringOpt(_ optional:Any?) -> String {
        return optional != nil ? "'" + (optional! as! String) + "'" : "NULL"
    }
}
