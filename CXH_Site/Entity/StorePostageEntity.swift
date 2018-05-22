//
//  StorePostageEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/22.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
///店铺包邮信息
class StorePostageEntity:Mappable{
    var storePostageId:Int?
    var specifiedAmountExemptionFromPostage:Double?
    var expressName:String?
    var expressCodeId:Int?
    var expressCode:String?
    var storeId:Int?
    var whetherExemptionFromPostage:Int?
    init(){}
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        storePostageId <- map["storePostageId"]
        specifiedAmountExemptionFromPostage <- map["specifiedAmountExemptionFromPostage"]
        expressName <- map["expressName"]
        expressCodeId <- map["expressCodeId"]
        expressCode <- map["expressCode"]
        storeId <- map["storeId"]
        whetherExemptionFromPostage <- map["whetherExemptionFromPostage"]
    }


}
