//
//  ReturnStorageEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/25.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 返件entity
class ReturnStorageEntity:Mappable {
    var returnStorageSN:String?
    var returnStoragePhoneNumber:String?
    var returnStorageName:String?
    var returnStorageTime:String?
    var returnStorageStatu:Int?
    var returnStorageHeadquartersReceiveCtime:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        returnStorageSN <- map["returnStorageSN"]
        returnStoragePhoneNumber <- map["returnStoragePhoneNumber"]
        returnStorageName <- map["returnStorageName"]
        returnStorageTime <- map["returnStorageTime"]
        returnStorageStatu <- map["returnStorageStatu"]
        returnStorageHeadquartersReceiveCtime <- map["returnStorageHeadquartersReceiveCtime"]
    }
}
