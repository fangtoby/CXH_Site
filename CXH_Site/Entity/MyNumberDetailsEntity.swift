//
//  MyNumberDetailsEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
///单号详情
class MyNumberDetailsEntity:Mappable{
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
    init(){}
    required init?(map: Map) {
        mapping(map: map)
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
    }
}
