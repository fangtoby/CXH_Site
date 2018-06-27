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
    ///1选中 2未选中
    var isSelected:Int?
    ///1，省级单位； 2，市级单位；3，县区级；4，镇级；5 ，村级
    var regionType:Int?
    ///是否还有下级子类 ； 1 有； 2 没有
    var isSubordinate:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        regionId <- map["regionId"]
        regionDesc <- map["regionDesc"]
        regionName <- map["regionName"]
        pid <- map["pid"]
        regionType <- map["regionType"]
        isSubordinate <- map["isSubordinate"]
    }
}
