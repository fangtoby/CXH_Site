//
//  GoodsCategoryEntity.swift
//  CXH
//
//  Created by hao peng on 2017/4/28.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 分类entity
class GoodsCategoryEntity:Mappable{
    var goodsCategoryIdRemark:String?
    var goodscategoryPid:Int?
    var goodscategoryName:String?
    var goodsCategoryIco:String?
    var displayStatu:Int?
    var goodscategoryId:Int?
    var goodsCategorySort:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        goodsCategoryIdRemark <- map["goodsCategoryIdRemark"]
        goodscategoryPid <- map["goodscategoryPid"]
        goodscategoryName <- map["goodscategoryName"]
        goodsCategoryIco <- map["goodsCategoryIco"]
        displayStatu <- map["displayStatu"]
        goodscategoryId <- map["goodscategoryId"]
        goodsCategorySort <- map["goodsCategorySort"]
    }

}
