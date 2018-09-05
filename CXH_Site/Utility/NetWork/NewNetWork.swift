//
//  NewNetWork.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/8.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import Moya
public enum NewRequestAPI{
    ///修改店铺商品
    case updateGoods(goodsbasicInfoId:Int,goodUnit:String,goodUcode:String,goodsPrice:String?,goodLife:String,stock:Int,storeId:Int,goodsSaleFlag:Int,goodsMemberPrice:String?,memberPriceMiniCount:Int?,weight:String,tag:Int)
    ///站点查询批发商绑定关系
    case queryBindWholesale(storeId:Int,pageNumber:Int,pageSize:Int)
    //修改站点和批发商的绑定关系
    case updateBindWholesale(storeId:Int,storeAndMemberBindWholesaleId:Int,flag:Int)
    ///绑定批发商
    case bindWholesale(storeId:Int,memberAccount:String)
    ///查询是否绑定微信或支付宝
    case queryStoreBindWxOrAliStatu(storeId:Int)
    ///店铺绑定支付宝
    case updateStoreBindAli(storeId:Int,auth_code:String)
    ///店铺绑定微信
    case updateStoreBindWx(storeId:Int,code:String)
    ///站点支付宝授权参数
    case query_store_ali_AuthParams(storeId:Int)
    ///发送验证码
    case sendDuanxin(account:String)
    ///查询站点的邮费设置
    case queryStorePostage(storeId:Int)
    ///新增/修改店铺的邮费设置
    case updateStorePostage(storeId:Int,specifiedAmountExemptionFromPostage:Double,expressCodeId:Int?,storePostageId:Int?,whetherExemptionFromPostage:Int,specifiedProvinceExemptionFromPostage:String)
    ///发货查询运费信息
    case queryOrderFreightByOrderId(orderId:Int)
    ///查询站点信息
    case queryStoreInfo(storeId:Int)
    ///修改站点的部分信息
    case updateStoreInfo(storeId:Int,shareBili:Int)
    ///查询订单扣费明细
    case queryStoreOrderPrepaidrecordDetailByPrepaidrecordId(prepaidrecordId:Int)
    ///店铺查询某种订单的数量
    case queryCountOrderGroupByOrderStatuByStoreId(storeId:Int)
    ///根据村查询站点
    case queryStoreandvillage(villageRegionId:Int)
    ///统计各种数量
    case queryStoreStatisticsByVariousStatesCount(storeId:Int)
    ///揽件历史（站点）供快速选择寄件/收件人
    case queryGiveHistoryForFastMail(pageNumber:Int,pageSize:Int,userId:Int,searchInfo:String?)
    ///根据地址自动识别
    case shaixuanAddress(info:String)
}
extension NewRequestAPI:TargetType{
    public var path: String {
        switch self {
        case .updateGoods(_,_,_,_,_,_,_,_,_,_,_,_):
            return "goodsB/updateGoods"
        case .queryBindWholesale(_,_,_):
            return "adminWholesale/queryBindWholesale"
        case .updateBindWholesale(_,_,_):
            return "adminWholesale/updateBindWholesale"
        case .bindWholesale(_,_):
            return "adminWholesale/bindWholesale"
        case .queryStoreBindWxOrAliStatu(_):
            return "storeBindWxOrAli/queryStoreBindWxOrAliStatu"
        case .updateStoreBindAli(_,_):
            return "storeBindWxOrAli/updateStoreBindAli"
        case .updateStoreBindWx(_,_):
            return "storeBindWxOrAli/updateStoreBindWx"
        case .query_store_ali_AuthParams(_):
            return "queryStoreCommInfo/query_store_ali_AuthParams"
        case .sendDuanxin(_):
            return "sendDuanxin/sendDuanxin"
        case .queryStorePostage(_):
            return "storepostage/queryStorePostage"
        case .updateStorePostage(_,_,_,_,_,_):
            return "storepostage/updateStorePostage"
        case .queryOrderFreightByOrderId(_):
            return "adminOrder/queryOrderFreightByOrderId"
        case .queryStoreInfo(_):
            return "storeInfo/queryStoreInfo"
        case .updateStoreInfo(_,_):
            return "storeInfo/updateStoreInfo"
        case .queryStoreOrderPrepaidrecordDetailByPrepaidrecordId(_):
            return "adminSpc/queryStoreOrderPrepaidrecordDetailByPrepaidrecordId"
        case .queryCountOrderGroupByOrderStatuByStoreId(_):
            return "adminOrder/queryCountOrderGroupByOrderStatuByStoreId"
        case .queryStoreandvillage(_):
            return "addressU/queryStoreandvillage"
        case .queryStoreStatisticsByVariousStatesCount(_):
            return "statisticsAdminFront/queryStoreStatisticsByVariousStatesCount"
        case .queryGiveHistoryForFastMail:
            return "adminGive/queryGiveHistoryForFastMail"
        case .shaixuanAddress:
            return "adminGive/shaixuanAddress"
        

        }
    }

    public var method: Moya.Method {
        switch self {
        case .updateGoods(_,_,_,_,_,_,_,_,_,_,_,_),.updateBindWholesale(_,_,_),.bindWholesale(_,_),.updateStoreBindAli(_,_),.updateStoreBindWx(_,_),.sendDuanxin(_),.updateStorePostage(_,_,_,_,_,_),.updateStoreInfo(_,_):
            return .post
        case .queryBindWholesale(_,_,_),.queryStoreBindWxOrAliStatu(_),.query_store_ali_AuthParams(_),.queryStorePostage(_),.queryOrderFreightByOrderId(_),.queryStoreInfo(_),.queryStoreOrderPrepaidrecordDetailByPrepaidrecordId(_),.queryCountOrderGroupByOrderStatuByStoreId(_),.queryStoreandvillage(_),.queryStoreStatisticsByVariousStatesCount(_),.queryGiveHistoryForFastMail,.shaixuanAddress:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .updateGoods(goodsbasicInfoId, goodUnit, goodUcode, goodsPrice, goodLife, stock, storeId, goodsSaleFlag, goodsMemberPrice, memberPriceMiniCount,weight,tag):
            if goodsSaleFlag == 1{//传普通价格
                return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId,"goodUnit":goodUnit,"goodUcode":goodUcode,"goodLife":goodLife,"stock":stock,"storeId":storeId,"goodsSaleFlag":goodsSaleFlag,"goodsPrice":goodsPrice!,"weight":weight,"tag":tag], encoding:URLEncoding.default)
            }else if goodsSaleFlag == 2{//传批发价 和起订量
                return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId,"goodUnit":goodUnit,"goodUcode":goodUcode,"goodLife":goodLife,"stock":stock,"storeId":storeId,"goodsSaleFlag":goodsSaleFlag,"goodsMemberPrice":goodsMemberPrice!,"memberPriceMiniCount":memberPriceMiniCount!,"weight":weight,"tag":tag], encoding:URLEncoding.default)
            }else{//都传
                return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId,"goodUnit":goodUnit,"goodUcode":goodUcode,"goodLife":goodLife,"stock":stock,"storeId":storeId,"goodsSaleFlag":goodsSaleFlag,"goodsMemberPrice":goodsMemberPrice!,"memberPriceMiniCount":memberPriceMiniCount!,"goodsPrice":goodsPrice!,"weight":weight,"tag":tag], encoding:URLEncoding.default)
            }
        case let .queryBindWholesale(storeId, pageNumber, pageSize):
            return .requestParameters(parameters:["storeId":storeId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .updateBindWholesale(storeId, storeAndMemberBindWholesaleId, flag):
            return .requestParameters(parameters:["storeId":storeId,"storeAndMemberBindWholesaleId":storeAndMemberBindWholesaleId,"flag":flag], encoding: URLEncoding.default)
        case let .bindWholesale(storeId, memberAccount):
            return .requestParameters(parameters:["storeId":storeId,"memberAccount":memberAccount], encoding: URLEncoding.default)
        case let .queryStoreBindWxOrAliStatu(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .updateStoreBindAli(storeId, auth_code):
            return .requestParameters(parameters:["storeId":storeId,"auth_code":auth_code], encoding: URLEncoding.default)
        case let .updateStoreBindWx(storeId, code):
            return .requestParameters(parameters:["storeId":storeId,"code":code], encoding: URLEncoding.default)
        case let .query_store_ali_AuthParams(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .sendDuanxin(account):
            return .requestParameters(parameters:["account":account], encoding: URLEncoding.default)
        case let .queryStorePostage(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .updateStorePostage(storeId, specifiedAmountExemptionFromPostage, expressCodeId, storePostageId,whetherExemptionFromPostage,specifiedProvinceExemptionFromPostage):
            return .requestParameters(parameters:["storeId":storeId,"specifiedAmountExemptionFromPostage":specifiedAmountExemptionFromPostage,"expressCodeId":expressCodeId ?? "","storePostageId":storePostageId ?? "","whetherExemptionFromPostage":whetherExemptionFromPostage,"specifiedProvinceExemptionFromPostage":specifiedProvinceExemptionFromPostage], encoding: URLEncoding.default)
        case let .queryOrderFreightByOrderId(orderId):
            return .requestParameters(parameters:["orderId":orderId], encoding: URLEncoding.default)
        case let .queryStoreInfo(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .updateStoreInfo(storeId, shareBili):
            return .requestParameters(parameters:["storeId":storeId,"shareBili":shareBili], encoding: URLEncoding.default)
        case let .queryStoreOrderPrepaidrecordDetailByPrepaidrecordId(prepaidrecordId):
            return .requestParameters(parameters:["prepaidrecordId":prepaidrecordId], encoding: URLEncoding.default)
        case let .queryCountOrderGroupByOrderStatuByStoreId(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .queryStoreandvillage(villageRegionId):
            return .requestParameters(parameters:["villageRegionId":villageRegionId], encoding: URLEncoding.default)
        case let .queryStoreStatisticsByVariousStatesCount(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .queryGiveHistoryForFastMail(pageNumber, pageSize, userId, searchInfo):
            return .requestParameters(parameters:["pageNumber":pageNumber,"pageSize":pageSize,"userId":userId,"searchInfo":searchInfo ?? ""], encoding: URLEncoding.default)
        case let .shaixuanAddress(info):
            return .requestParameters(parameters:["info":info], encoding: URLEncoding.default)

        }
    }


}
