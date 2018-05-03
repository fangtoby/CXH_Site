//
//  ReturnGoodsEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 退货entity
class ReturnGoodsEntity:Mappable {
    var orderInfoId:Int?
    var returnGoodsReason:String?
    var returnGoodsExpressName:String?
    var returnGoodsExpressON:String?
    var returnGoodsStatu:Int?
    var returnGoodsApplyTime:String?
    var returnGoodsSubmitTime:String?
    var returnGoodsHeadquartersConfirmTime:String?
    var returnGoodsStoreConfirmTime:String?
    var storeId:Int?
    var memberId:Int?
    var shippName:String?
    var tel:String?
    var orderPrice:Double?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        orderInfoId <- map["orderInfoId"]
        returnGoodsReason <- map["returnGoodsReason"]
        returnGoodsExpressName <- map["returnGoodsExpressName"]
        returnGoodsExpressON <- map["returnGoodsExpressON"]
        returnGoodsStatu <- map["returnGoodsStatu"]
        returnGoodsApplyTime <- map["returnGoodsApplyTime"]
        returnGoodsSubmitTime <- map["returnGoodsSubmitTime"]
        returnGoodsHeadquartersConfirmTime <- map["returnGoodsHeadquartersConfirmTime"]
        returnGoodsStoreConfirmTime <- map["returnGoodsStoreConfirmTime"]
        storeId <- map["storeId"]
        memberId <- map["memberId"]
        shippName <- map["shippName"]
        tel <- map["tel"]
        orderPrice <- map["orderPrice"]
        
    }
}
