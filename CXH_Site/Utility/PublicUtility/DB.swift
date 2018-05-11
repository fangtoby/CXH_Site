//
//  DB.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/11.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import SQLite
import SwiftyJSON
///保存数据
class DB:NSObject{
    static let shared = DB()
    private var db:Connection!
    let table = Table("Courier")
    let id=Expression<Int64>("id")
    let expressCodeId=Expression<Int64>("expressCodeId")
    let expressName=Expression<String>("expressName")
    let expressCode=Expression<String?>("expressCode")
    let letter=Expression<String>("letter")
    private override init() {
        super.init()
        self.tableLampCreate()
    }
    private func tableLampCreate(){
        do{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            db=try Connection("\(path)/db.sqlite3")
            try self.db.run(table.create(ifNotExists: true, block: { (t) in
                t.column(id, primaryKey:true)
                t.column(expressCodeId)
                t.column(expressName)
                t.column(expressCode)
                t.column(letter)
            }))
        } catch {
            print("创建数据库失败--\(error)")
        }
    }
    ///查询所有字母
    func selectLetterArr() -> [String]{
        var arr=[String]()
        do{
            for row in try db.prepare("SELECT letter FROM Courier") {
                arr.append(row[0] as! String)
            }
        }catch{
            print("查询数据错误--\(error)")
        }
        arr.append("#")
        return Array(Set(arr)).sorted()
    }
    ///查询数据
    func selectArr(letter:String) -> [ExpressEntity]{
        var arr=[ExpressEntity]()
        let alice=table.filter(self.letter == letter)
        do{
            if letter=="#"{
                for value in try db.prepare(table).prefix(5) {
                    let entity=ExpressEntity()
                    entity.expressCodeId=Int(value[expressCodeId])
                    entity.expressName=value[expressName]
                    entity.expressCode=value[expressCode]
                    entity.letter=value[self.letter]
                    arr.append(entity)
                }
            }else{
                for value in (try db.prepare(alice)){
                    let entity=ExpressEntity()
                    entity.expressCodeId=Int(value[expressCodeId])
                    entity.expressName=value[expressName]
                    entity.expressCode=value[expressCode]
                    entity.letter=value[self.letter]
                    arr.append(entity)
                }
            }
        }catch{
            print("查询数据错误--\(error)")
        }
        return arr
    }
    ///插入单条数据
    func insertEntity(entity:ExpressEntity) {
        do{
            let count=try db.scalar("SELECT COUNT(expressCodeId) FROM Courier WHERE expressCodeId = ?",entity.expressCodeId!) as? Int64
            if count == 0 {
                let insert=table.insert(expressCodeId <- Int64(entity.expressCodeId!),expressName <- entity.expressName!,expressCode <- entity.expressCode!,letter <- entity.letter!)
                try db.run(insert)
            }
        }catch{
            print("插入数据错误---\(error)")
        }
    }
    ///删除数据
    func deleteArrEntity(){
        do{
            try db.run(table.delete())
        }catch{
            print("删除数据错误---\(error)")
        }
    }
    ///刷新数据
    func refreshData(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.wlQueryExpresscode(), successClosure: { (result) -> Void in
            DispatchQueue.global().async(execute: {
                self.deleteArrEntity()
                let json=JSON(result)
                for(_,value) in json{
                    let entity=self.returnEntity(json:value)
                    entity.letter=chineISInitials(entity.expressName ?? "城乡惠")
                    self.insertEntity(entity:entity)
                }
            })
        }) { (errorMsg) -> Void in

        }
    }
    private func returnEntity(json:JSON) ->ExpressEntity{
        let entity=ExpressEntity()
        entity.expressCodeId=json["expressCodeId"].intValue
        entity.expressName=json["expressName"].stringValue
        entity.expressCode=json["expressCode"].stringValue
        entity.letter=json["letter"].stringValue
        return entity
    }
}
