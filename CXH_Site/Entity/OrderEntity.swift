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
    ///运费
    var orderSumFreight:Double?
    ///此笔订单是否已经为用户包邮； 1 包邮； 2 不包邮
    var orderWhetherExemptionFromPostage:Int?
    ///分享费
    var orderShareSumPrice:Double?
    ///总佣金
    var orderComment:Double?
    ///确认收货时间
    var receiptTime:String?
    ///重量
    var orderSumGoodsWeight:Int?
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
        orderSumFreight <- map["orderSumFreight"]
        orderWhetherExemptionFromPostage <- map["orderWhetherExemptionFromPostage"]
        orderShareSumPrice <- map["orderShareSumPrice"]
        orderComment <- map["orderComment"]
        receiptTime <- map["receiptTime"]
        orderSumGoodsWeight <- map["orderSumGoodsWeight"]
    }
}
