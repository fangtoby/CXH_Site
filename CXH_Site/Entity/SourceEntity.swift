//
//  SourceEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/10/23.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 来源entity
class SourceEntity:Mappable{
    var lyImg:String?
    var lyMX:String?
    var testgoodsdetailspicId:Int?
    var miaoshu:String?
    var testgoodsdetailspic:String?
    var testgoodsId:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        testgoodsdetailspicId <- map["testgoodsdetailspicId"]
        miaoshu <- map["miaoshu"]
        testgoodsdetailspic <- map["testgoodsdetailspic"]
        testgoodsId <- map["testgoodsId"]
    }
}
