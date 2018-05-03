//
//  PrinterEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/12.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 写入entity
class PrinterEntity:Mappable{
    var storeName:String?
    var time:String?
    var code:String?
    var weight:String?
    var freight:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        storeName <- map["storeName"]
        time <- map["time"]
        code <- map["code"]
        weight <- map["weight"]
        freight <- map["freight"]
    }
}
