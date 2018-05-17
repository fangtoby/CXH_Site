//
//  GoodEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/3.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 商品entity
class GoodEntity:Mappable{
    var goodPic:String?
    var ctime:String?
    var goodUnit:String?
    var goodInfoName:String?
    var goodsbasicinfoFlag:Int?
    var goodInfoCode:Int?
    var goodUcode:String?
    var goodsPrice:Double?
    var goodsbasicInfoId:Int?
    var goodLife:String?
    var goodsCount:Int?
    var stock:Int?
    var salesCount:Int?
    var qrcode:String?
    var goodsMemberPrice:Double?
    var memberPriceMiniCount:Int?
    var goodsSaleFlag:Int?
    ///商品状态 1零售 2批发
    var retailOrWholesaleFlag:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        goodPic <- map["goodPic"]
        ctime <- map["ctime"]
        goodUnit <- map["goodUnit"]
        goodInfoName <- map["goodInfoName"]
        goodsbasicinfoFlag <- map["goodsbasicinfoFlag"]
        goodInfoCode <- map["goodInfoCode"]
        goodUcode <- map["goodUcode"]
        goodsPrice <- map["goodsPrice"]
        goodsbasicInfoId <- map["goodsbasicInfoId"]
        goodLife <- map["goodLife"]
        goodsCount <- map["goodsCount"]
        stock <- map["stock"]
        salesCount <- map["salesCount"]
        qrcode <- map["qrcode"]
        goodsMemberPrice <- map["goodsMemberPrice"]
        memberPriceMiniCount <- map["memberPriceMiniCount"]
        goodsSaleFlag <- map["goodsSaleFlag"]
        retailOrWholesaleFlag <- map["retailOrWholesaleFlag"]
        
    }
}
