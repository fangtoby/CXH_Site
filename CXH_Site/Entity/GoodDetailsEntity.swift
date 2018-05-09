//
//  GoodDetailsEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 商品详情
class GoodDetailsEntity:Mappable{
    var goodLife:String?
    var goodUcode:String?
    var praiseRate:Int?
    var goodUnit:String?
    var ctime:String?
    var goodInfoName:String?
    var fCategoryId:Int?
    var goodSource:String?
    var goodsbasicInfoId:Int?
    var goodsPrice:Double?
    var goodService:String?
    var goodsbasicinfoFlag:Int?
    var whetherRecommendGoods:Int?
    var storeId:Int?
    var hotGoods:Int?
    var goodInfoCode:String?
    var remark:String?
    var goodMixed:String?
    var sCategoryId:Int?
    var goodPic:String?
    var sCategoryName:String?
    var stock:Int?
    var producer:String?
    var sellerAddress:String?
    var goodsMemberPrice:Double?
    var memberPriceMiniCount:Int?
    var goodsSaleFlag:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        goodLife <- map["goodLife"]
        goodUcode <- map["goodUcode"]
        praiseRate <- map["praiseRate"]
        goodUnit <- map["goodUnit"]
        ctime <- map["ctime"]
        goodInfoName <- map["goodInfoName"]
        fCategoryId <- map["fCategoryId"]
        goodSource <- map["goodSource"]
        goodsbasicInfoId <- map["goodsbasicInfoId"]
        goodsPrice <- map["goodsPrice"]
        goodService <- map["goodService"]
        goodsbasicinfoFlag <- map["goodsbasicinfoFlag"]
        whetherRecommendGoods <- map["whetherRecommendGoods"]
        storeId <- map["storeId"]
        hotGoods <- map["hotGoods"]
        goodInfoCode <- map["goodInfoCode"]
        remark <- map["remark"]
        goodMixed <- map["goodMixed"]
        sCategoryId <- map["sCategoryId"]
        goodPic <- map["goodPic"]
        sCategoryName <- map["sCategoryName"]
        stock <- map["stock"]
        producer <- map["producer"]
        sellerAddress <- map["sellerAddress"]
        goodsMemberPrice <- map["goodsMemberPrice"]
        memberPriceMiniCount <- map["memberPriceMiniCount"]
        goodsSaleFlag <- map["goodsSaleFlag"]
    }
}
