//
//  StoreEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/26.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
///店铺信息
class StoreEntity:Mappable{
    var capitalSumMoney:Double?
    var ownerName:String?
    var storeName:String?
    var shareBili:Int?
    var zipcode:String?
    var tel:String?
    var state:Int?
    var map_coordinate:String?
    var storeNo:String?
    var applyRemark:String?
    var address:String?
    var addTime:String?
    var provinceText:String?
    var countyText:String?
    var cityText:String?
    var storeId:Int?
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        capitalSumMoney <- map["capitalSumMoney"]
        ownerName <- map["ownerName"]
        storeName <- map["storeName"]
        shareBili <- map["shareBili"]
        zipcode <- map["zipcode"]
        tel <- map["tel"]
        state <- map["state"]
        map_coordinate <- map["map_coordinate"]
        storeNo <- map["storeNo"]
        applyRemark <- map["applyRemark"]
        address <- map["address"]
        addTime <- map["addTime"]
        provinceText <- map["provinceText"]
        countyText <- map["countyText"]
        cityText <- map["cityText"]
        storeId <- map["storeId"]
    }


}
