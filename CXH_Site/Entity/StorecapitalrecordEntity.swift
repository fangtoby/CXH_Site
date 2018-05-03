//
//  StorecapitalrecordEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 消费/扣除记录
class StorecapitalrecordEntity:Mappable{
    var statu:Int?
    var cTime:String?
    var capitalSum:Double?
    var expressmailSN:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        statu <- map["statu"]
        cTime <- map["cTime"]
        capitalSum <- map["capitalSum"]
        expressmailSN <- map["expressmailSN"]
    }
}
