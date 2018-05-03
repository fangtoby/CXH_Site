//
//  ExpressmailStorageEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/7.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 收件entity
class ExpressmailStorageEntity:Mappable{
    var expressmailStorageToCompanySN:String?
    var expressmailStorageSN:String?
    var ctime:String?
    var expressmailStorageQrcode:String?
    var expressmailStorageId:Int?
    var addMoney:Int?
    var expressmailStatu:Int?
    var qrcodeContent:String?
    var addMoneyStatu:Int?
    var expressmailStorageForExpressName:String?
    var expressmailStoragePhoneNumber:String?
    var expressmailStorageName:String?
    var storeUserCtime:String?
    var driverUserCtime:String?
    var returnStorageStatu:Int?
    var storePackList:String?
    var userCtime:String?
    var shippingName:String?
    var storeName:String?
    var expressmailList:String?
    var logisticsPackId:Int?
    var storePackId:Int?
    var signTime:String?
    
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        expressmailStorageToCompanySN <- map["expressmailStorageToCompanySN"]
        expressmailStorageSN <- map["expressmailStorageSN"]
        ctime <- map["ctime"]
        expressmailStorageQrcode <- map["expressmailStorageQrcode"]
        expressmailStorageId <- map["expressmailStorageId"]
        addMoney <- map["addMoney"]
        expressmailStatu <- map["expressmailStatu"]
        qrcodeContent <- map["qrcodeContent"]
        addMoneyStatu <- map["addMoneyStatu"]
        expressmailStorageForExpressName <- map["expressmailStorageForExpressName"]
        expressmailStoragePhoneNumber <- map["expressmailStoragePhoneNumber"]
        expressmailStorageName <- map["expressmailStorageName"]
        storeUserCtime <- map["storeUserCtime"]
        driverUserCtime <- map["driverUserCtime"]
        returnStorageStatu <- map["returnStorageStatu"]
        storePackList <- map["storePackList"]
        userCtime <- map["userCtime"]
        shippingName <- map["shippingName"]
        storeName <- map["storeName"]
        expressmailList <- map["expressmailList"]
        logisticsPackId <- map["logisticsPackId"]
        storePackId <- map["storePackId"]
        signTime <- map["signTime"]
    }
}
