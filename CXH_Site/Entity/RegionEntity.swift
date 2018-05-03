//
//  RegionEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/9/25.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 省市区信息
class RegionEntity:Mappable{
    var regionId:Int?
    var regionDesc:String?
    var regionName:String?
    var pid:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        regionId <- map["regionId"]
        regionDesc <- map["regionDesc"]
        regionName <- map["regionName"]
        pid <- map["pid"]
    }
}
