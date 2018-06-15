//
//  OrderCountEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2018/6/15.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
///订单数量
class OrderCountEntity:Mappable{
    var orderStatu:Int?
    var countOrder:Int?
    init() {

    }
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        orderStatu <- map["orderStatu"]
        countOrder <- map["countOrder"]
    }
}
