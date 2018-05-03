//
//  MemberEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/5/31.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 会员entity
class MemberEntity:Mappable{
    var userId:Int?
    var ctime:String?
    var userName:String?
    var userPossword:String?
    var flag:Int?
    var storeId:Int?
    var identity:Int?
    var userAccount:String?
    var testStoreId:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        userId <- map["userId"]
        ctime <- map["ctime"]
        userName <- map["userName"]
        userPossword <- map["userPossword"]
        flag <- map["flag"]
        storeId <- map["storeId"]
        identity <- map["identity"]
        userAccount <- map["userAccount"]
        testStoreId <- map["testStoreId"]
    }
}
