//
//  ExpressmailUpdateEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/24.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 揽件修改entity
class ExpressmailUpdateEntity:Mappable{
    var expressmailUpdateRecordId:Int?
    var expressmailUpdateUserId:Int?
    var expressmailUpdateStoreId:Int?
    var expressmailUpdateExpressmailId:Int?
    var expressmailUpdateTime:String?
    var expressmailUpdateStoreConfirmTime:String?
    var expressmailUpdateStoreConfirmUserId:Int?
    var expressmailUpdateStatu:Int?
    var expressmailUpdateFrontFreight:Double?
    var expressmailUpdateBackFreight:Double?
    var expressmailUpdateFrontWeight:Int?
    var expressmailUpdateBackWeight:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        expressmailUpdateRecordId <- map["expressmailUpdateRecordId"]
        expressmailUpdateUserId <- map["expressmailUpdateUserId"]
        expressmailUpdateStoreId <- map["expressmailUpdateStoreId"]
        expressmailUpdateExpressmailId <- map["expressmailUpdateExpressmailId"]
        expressmailUpdateTime <- map["expressmailUpdateTime"]
        expressmailUpdateStoreConfirmTime <- map["expressmailUpdateStoreConfirmTime"]
        expressmailUpdateStoreConfirmUserId <- map["expressmailUpdateStoreConfirmUserId"]
        expressmailUpdateStatu <- map["expressmailUpdateStatu"]
        expressmailUpdateFrontFreight <- map["expressmailUpdateFrontFreight"]
        expressmailUpdateBackFreight <- map["expressmailUpdateBackFreight"]
        expressmailUpdateFrontWeight <- map["expressmailUpdateFrontWeight"]
        expressmailUpdateBackWeight <- map["expressmailUpdateBackWeight"]
        
    }
}
