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
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        sumFreight <- map["sumFreight"]
        storeToHeadquarters <- map["storeToHeadquarters"]
        moneyToMember <- map["moneyToMember"]
        moneyToStore <- map["moneyToStore"]
        moneyToCompany <- map["moneyToCompany"]
    }
}
