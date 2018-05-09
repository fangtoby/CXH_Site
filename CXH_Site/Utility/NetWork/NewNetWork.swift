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
    case updateGoods(goodsbasicInfoId:Int,goodUnit:String,goodUcode:String,goodsPrice:String?,goodLife:String,stock:Int,storeId:Int,goodsSaleFlag:Int,goodsMemberPrice:String?,memberPriceMiniCount:Int?)
    ///站点查询批发商绑定关系
    case queryBindWholesale(storeId:Int,pageNumber:Int,pageSize:Int)
    //修改站点和批发商的绑定关系
    case updateBindWholesale(storeId:Int,storeAndMemberBindWholesaleId:Int,flag:Int)
    ///绑定批发商
    case bindWholesale(storeId:Int,memberAccount:String)
}
extension NewRequestAPI:TargetType{
    public var path: String {
        switch self {
        case .updateGoods(_,_,_,_,_,_,_,_,_,_):
            return "goodsB/updateGoods"
        case .queryBindWholesale(_,_,_):
            return "adminWholesale/queryBindWholesale"
        case .updateBindWholesale(_,_,_):
            return "adminWholesale/updateBindWholesale"
        case .bindWholesale(_,_):
            return "adminWholesale/bindWholesale"

        }
    }

    public var method: Moya.Method {
        switch self {
        case .updateGoods(_,_,_,_,_,_,_,_,_,_),.updateBindWholesale(_,_,_),.bindWholesale(_,_):
            return .post
        case .queryBindWholesale(_,_,_):
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .updateGoods(goodsbasicInfoId, goodUnit, goodUcode, goodsPrice, goodLife, stock, storeId, goodsSaleFlag, goodsMemberPrice, memberPriceMiniCount):
            if goodsSaleFlag == 1{//传普通价格
                return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId,"goodUnit":goodUnit,"goodUcode":goodUcode,"goodLife":goodLife,"stock":stock,"storeId":storeId,"goodsSaleFlag":goodsSaleFlag,"goodsPrice":goodsPrice!], encoding:URLEncoding.default)
            }else if goodsSaleFlag == 2{//传批发价 和起订量
                return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId,"goodUnit":goodUnit,"goodUcode":goodUcode,"goodLife":goodLife,"stock":stock,"storeId":storeId,"goodsSaleFlag":goodsSaleFlag,"goodsMemberPrice":goodsMemberPrice!,"memberPriceMiniCount":memberPriceMiniCount!], encoding:URLEncoding.default)
            }else{//都传
                return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId,"goodUnit":goodUnit,"goodUcode":goodUcode,"goodLife":goodLife,"stock":stock,"storeId":storeId,"goodsSaleFlag":goodsSaleFlag,"goodsMemberPrice":goodsMemberPrice!,"memberPriceMiniCount":memberPriceMiniCount!,"goodsPrice":goodsPrice!], encoding:URLEncoding.default)
            }
        case let .queryBindWholesale(storeId, pageNumber, pageSize):
            return .requestParameters(parameters:["storeId":storeId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .updateBindWholesale(storeId, storeAndMemberBindWholesaleId, flag):
            return .requestParameters(parameters:["storeId":storeId,"storeAndMemberBindWholesaleId":storeAndMemberBindWholesaleId,"flag":flag], encoding: URLEncoding.default)
        case let .bindWholesale(storeId, memberAccount):
            return .requestParameters(parameters:["storeId":storeId,"memberAccount":memberAccount], encoding: URLEncoding.default)
        }
    }


}
