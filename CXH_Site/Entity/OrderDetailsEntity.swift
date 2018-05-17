//
//  OrderDetailsEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 订单详情entity
class OrderDetailsEntity:Mappable{
    var storeId:Int?
    var paymentTime:String?
    var invoiceType:Int?
    var storeTel:String?
    var orderStatu:Int?
    var deliverTime:String?
    var addMemberId:Int?
    var platform:Int?
    var orderSN:String?
    var addTime:String?
    var shippName:String?
    var orderInfoId:Int?
    var invoiceName:String?
    var orderAndGoods:[GoodEntity]?
    var payMessage:String?
    var orderPrice:Double?
    var tel:String?
    var shipaddress:String?
    var province:String?
    ///确认收货时间
    var receiptTime:String?
    ///此笔订单的总佣金
    var orderComment:String?
    ///此笔订单总的分享费用
    var orderShareSumPrice:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        storeId <- map["storeId"]
        paymentTime <- map["paymentTime"]
        invoiceType <- map["invoiceType"]
        storeTel <- map["storeTel"]
        orderStatu <- map["orderStatu"]
        deliverTime <- map["deliverTime"]
        addMemberId <- map["addMemberId"]
        platform <- map["platform"]
        orderSN <- map["orderSN"]
        addTime <- map["addTime"]
        shippName <- map["shippName"]
        orderInfoId <- map["orderInfoId"]
        invoiceName <- map["invoiceName"]
        payMessage <- map["payMessage"]
        orderPrice <- map["orderPrice"]
        tel <- map["tel"]
        shipaddress <- map["shipaddress"]
        province <- map["province"]
        receiptTime <- map["receiptTime"]
        orderComment <- map["orderComment"]
        orderShareSumPrice <- map["orderShareSumPrice"]
    }
}
