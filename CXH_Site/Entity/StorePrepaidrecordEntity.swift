//
//  StorePrepaidrecordEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 充值记录
class StorePrepaidrecordEntity:Mappable{
    var prepaidTime:String?
    var prepaidMoney:Double?
    var prepaidType:Int?
    var prepaidrecordId:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        prepaidTime <- map["prepaidTime"]
        prepaidMoney <- map["prepaidMoney"]
        prepaidType <- map["prepaidType"]
        prepaidrecordId <- map["prepaidrecordId"]
    }
}
