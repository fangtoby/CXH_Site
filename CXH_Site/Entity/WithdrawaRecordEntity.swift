//
//  WithdrawaRecordEntity.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/16.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import ObjectMapper
/// 提现信息entity
class WithdrawaRecordEntity:Mappable{
    var withdrawaRecordId:Int?
    ///提现人的名称
    var withdrawaRecordName:String?
    ///提现人的银行账号
    var withdrawaRecordBankCardNumber:String?
    ///提现人所属站点
    var withdrawaRecordStoreId:Int?
    ///提现人银行名称
    var withdrawaRecordBankName:String?
    ///开户支行
    var withdrawaRecordBankBranch:String?
    ///提现金额’
    var withdrawaRecordMoney:Double?
    ///卡提现时间’,
    var withdrawaRecordTime:String?
    ///提现类型1 银行卡提现； 2 微信提现； 3 支付
    var withdrawaType:Int?
    ///提现状态 ‘提现状态 默认1 未处理 2 已处理 3 提现失败’,
    var withdrawaRecordStatu:Int?
    ///‘微信支付宝 提现失败的描述’,
    var withdrawalsFailMs:String?
    ///‘微信支付宝 提现成功时间’,
    var withdrawalsSusscesTime:String?
    init(){}
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        withdrawaRecordId <- map["withdrawaRecordId"]
        withdrawaRecordName <- map["withdrawaRecordName"]
        withdrawaRecordBankCardNumber <- map["withdrawaRecordBankCardNumber"]
        withdrawaRecordStoreId <- map["withdrawaRecordStoreId"]
        withdrawaRecordBankName <- map["withdrawaRecordBankName"]
        withdrawaRecordBankBranch <- map["withdrawaRecordBankBranch"]
        withdrawaRecordMoney <- map["withdrawaRecordMoney"]
        withdrawaRecordTime <- map["withdrawaRecordTime"]
        withdrawaType <- map["withdrawaType"]
        withdrawaRecordStatu <- map["withdrawaRecordStatu"]
        withdrawalsFailMs <- map["withdrawalsFailMs"]
        withdrawalsSusscesTime <- map["withdrawalsSusscesTime"]
    }
}
