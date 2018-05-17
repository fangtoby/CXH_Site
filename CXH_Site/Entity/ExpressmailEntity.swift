//
//  ExpressmailEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 揽件entity
class ExpressmailEntity:Mappable{
    var expressmailId:Int?
    var fromcity:String?
    var fromprovince:String?
    var tocity:String?
    var toName:String?
    var memberId:Int?
    var toRemarks:String?
    var fromRemarks:String?
    var toprovince:String?
    var expressmailSN:String?
    var tocounty:String?
    var fromcounty:String?
    var ctime:String?
    var todetailAddress:String?
    var tophoneNumber:String?
    var fromphoneNumber:String?
    var status:Int?
    var qrcode:String?
    var fromName:String?
    var inputRemarks:String?
    var weight:Int?
    var amount:Int?
    var freight:Double?
    var expressName:String?
    var expressNo:String?
    var storeToHeadquarters:Int?
    var insuredMoney:Double?
    var payType:Int?
    var qrcodeContent:String?
    var height:Int?
    var width:Int?
    var length:Int?
    var expressCode:String?
    var expressLinkId:Int?
    var idCard:String?
    var packagePic:String?
    var storeName:String?
    var storeNo:String?
    init(){}
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        expressmailId <- map["expressmailId"]
        fromcity <- map["fromcity"]
        fromprovince <- map["fromprovince"]
        tocity <- map["tocity"]
        toName <- map["toName"]
        memberId <- map["memberId"]
        toRemarks <- map["toRemarks"]
        fromRemarks <- map["fromRemarks"]
        toprovince <- map["toprovince"]
        expressmailSN <- map["expressmailSN"]
        tocounty <- map["tocounty"]
        fromcounty <- map["fromcounty"]
        ctime <- map["ctime"]
        todetailAddress <- map["todetailAddress"]
        tophoneNumber <- map["tophoneNumber"]
        fromphoneNumber <- map["fromphoneNumber"]
        status <- map["status"]
        qrcode <- map["qrcode"]
        fromName <- map["fromName"]
        inputRemarks <- map["inputRemarks"]
        weight <- map["weight"]
        amount <- map["amount"]
        freight <- map["freight"]
        expressName <- map["expressName"]
        expressNo <- map["expressNo"]
        storeToHeadquarters <- map["storeToHeadquarters"]
        insuredMoney <- map["insuredMoney"]
        payType <- map["payType"]
        qrcodeContent <- map["qrcodeContent"]
        height <- map["height"]
        width <- map["width"]
        length <- map["length"]
        expressCode <- map["expressCode"]
        expressLinkId <- map["expressLinkId"]
        idCard <- map["idCard"]
        packagePic <- map["packagePic"]
        storeName <- map["storeName"]
        storeNo <- map["storeNo"]
    }

}
