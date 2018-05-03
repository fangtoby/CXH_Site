//
//  OrderEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 订单entity
class OrderEntity:Mappable{
    var orderandgoods:[GoodEntity]?
    var orderInfoId:Int?
    var orderSN:String?
    var orderPrice:Double?
    var addTime:String?
    var province:String?
    var city:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        orderInfoId <- map["orderInfoId"]
        orderSN <- map["orderSN"]
        orderPrice <- map["orderPrice"]
        addTime <- map["addTime"]
        province <- map["province"]
        city <- map["city"]
    }
}
