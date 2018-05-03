//
//  ShippingLinesEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 路线entity
class ShippingLinesEntity:Mappable{
    var shippingLinesId:Int?
    var shippingName:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        shippingLinesId <- map["shippingLinesId"]
        shippingName <- map["shippingName"]
    }
}
