//
//  WithdrawaEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/12.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 提现信息entity
class WithdrawaEntity:Mappable{
    var withdrawaId:Int?
    ///提现人的名称
    var withdrawaName:String?
    ///提现人的银行账号
    var withdrawaBankCardNumber:String?
    ///提现人所属站点
    var withdrawaStoreId:Int?
    ///提现人银行名称
    var withdrawaBankName:String?
    ///开户支行
    var withdrawaBankBranch:String?
    var withdrawaRecordMoney:Double?
    var withdrawaRecordTime:String?
    init(){}
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        withdrawaId <- map["withdrawaId"]
        withdrawaName <- map["withdrawaName"]
        withdrawaBankCardNumber <- map["withdrawaBankCardNumber"]
        withdrawaStoreId <- map["withdrawaStoreId"]
        withdrawaBankName <- map["withdrawaBankName"]
        withdrawaBankBranch <- map["withdrawaBankBranch"]
        withdrawaRecordMoney <- map["withdrawaRecordMoney"]
        withdrawaRecordTime <- map["withdrawaRecordTime"]
    }
}
