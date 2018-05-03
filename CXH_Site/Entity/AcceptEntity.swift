//
//  AcceptEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
class AcceptEntity:Mappable {
    var AcceptTime:String?
    var AcceptStation:String?
    var Remark:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        AcceptTime <- map["AcceptTime"]
        AcceptStation <- map["AcceptStation"]
        Remark <- map["Remark"]
    }
}
