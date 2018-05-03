//
//  FoodEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/10/20.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 菜品entity
class FoodEntity:Mappable{
    var stock:Int?
    var foodPrice:String?
    var foodName:String?
    var foodCode:String?
    var foodMixed:String?
    var tel:String?
    var foodRemark:String?
    var foodPic:String?
    var foodUnit:String?
    var foodUcode:String?
    var testStoreId:Int?
    var testStoreName:String?
    var foodId:Int?
    var salesCount:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        stock <- map["stock"]
        foodPrice <- map["foodPrice"]
        foodName <- map["foodName"]
        foodCode <- map["foodCode"]
        foodMixed <- map["foodMixed"]
        tel <- map["tel"]
        foodRemark <- map["foodRemark"]
        foodPic <- map["foodPic"]
        foodUnit <- map["foodUnit"]
        foodUcode <- map["foodUcode"]
        testStoreId <- map["testStoreId"]
        testStoreName <- map["testStoreName"]
        foodId <- map["foodId"]
        salesCount <- map["salesCount"]
    }
}
