//
//  FreightEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/23.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 运费信息
class FreightEntity:Mappable {
    var sumFreight:Double?
    var storeToHeadquarters:Double?
    var moneyToMember:Double?
    var moneyToStore:Double?
    var moneyToCompany:Double?
    var whetherExemptionFromPostage:Int?
    var specifiedAmountExemptionFromPostage:Double?
    var sumGoodsWeight:Int?
    var memberSubmitOrderSumFreight:Double?
    var orderInfoId:Int?
    var expressName:String?
    var expressCodeId:Int?
    var expressCode:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        whetherExemptionFromPostage <- map["whetherExemptionFromPostage"]
        specifiedAmountExemptionFromPostage <- map["specifiedAmountExemptionFromPostage"]
        moneyToMember <- map["moneyToMember"]
        storeToHeadquarters <- map["storeToHeadquarters"]
        sumFreight <- map["sumFreight"]
        moneyToStore <- map["moneyToStore"]
        sumGoodsWeight <- map["sumGoodsWeight"]
        moneyToCompany <- map["moneyToCompany"]
        memberSubmitOrderSumFreight <- map["memberSubmitOrderSumFreight"]
        orderInfoId <- map["orderInfoId"]
        expressName <- map["expressName"]
        expressCodeId <- map["expressCodeId"]
        expressCode <- map["expressCode"]
    }
}
