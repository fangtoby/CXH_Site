//
//  WholesaleAuthEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/9.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
///授权entity
class WholesaleAuthEntity:Mappable {
    var time:String?
    var flag:Int?
    var account:String?
    var storeAndMemberBindWholesaleId:Int?
    init() {
        
    }
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        time <- map["time"]
        flag <- map["flag"]
        account <- map["account"]
        storeAndMemberBindWholesaleId <- map["storeAndMemberBindWholesaleId"]
    }
}
