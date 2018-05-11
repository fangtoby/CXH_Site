//
//  ExpressEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 物流公司编码
class ExpressEntity:Mappable{
    var expressName:String?
    var expressCode:String?
    var expressCodeId:Int?
    var letter:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        expressName <- map["expressName"]
        expressCode <- map["expressCode"]
        expressCodeId <- map["expressCodeId"]
        letter <- map["letter"]
    }
}
