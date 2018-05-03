//
//  TouchBalanceEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/8/18.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 返件entity
class TouchBalanceEntity:Mappable {
    var k1:Double?
    var k2:Double?
    var k3:Double?
    var k4:Double?
    var k5:Double?
    var k6:Double?
    var c1:Double?
    var c2:Double?
    var c3:Double?
    var c4:Double?
    var c5:Double?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        k1 <- map["k1"]
        k2 <- map["k2"]
        k3 <- map["k3"]
        k4 <- map["k4"]
        k5 <- map["k5"]
        k6 <- map["k6"]
        c1 <- map["c1"]
        c2 <- map["c2"]
        c3 <- map["c3"]
        c4 <- map["c4"]
        c5 <- map["c5"]
    }
}
