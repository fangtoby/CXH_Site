//
//  PHNetWork.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/8/8.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import Moya
/// 成功
typealias SuccessClosure = (_ result: Any) -> Void
/// 失败
typealias FailClosure = (_ errorMsg: String?) -> Void
/// 网络请求
open class PHMoyaHttp {
    /// 共享实例
    static let sharedInstance = PHMoyaHttp()
    private init(){}
    private let SERVERERROR="数据解析失败"
    /**
     根据target请求JSON数据

     - parameter target:         RequestAPI(先定义好,发送什么请求用什么case)
     - parameter successClosure: 成功结果
     - parameter failClosure:    失败结果
     */
    func requestDataWithTargetJSON<T:TargetType>(_ target:T,successClosure:@escaping SuccessClosure,failClosure: @escaping FailClosure) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let json = try response.mapJSON()
                    successClosure(json)
                } catch {
                    failClosure(self.SERVERERROR)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    /**
     根据target请求String数据

     - parameter target:         RequestAPI(先定义好,发送什么请求用什么case)
     - parameter successClosure: 成功结果
     - parameter failClosure:    失败结果
     */
    func requestDataWithTargetString<T:TargetType>(_ target:T,successClosure:@escaping SuccessClosure,failClosure:@escaping FailClosure) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let str = try response.mapString()
                    successClosure(str)
                } catch {
                    failClosure(self.SERVERERROR)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }

        }
    }
    //设置请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target:T) -> MoyaProvider<T>.RequestClosure{
        let requestTimeoutClosure = { (endpoint:Endpoint<T>, done: @escaping MoyaProvider<T>.RequestResultClosure) in
            do{
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 20 //设置请求超时时间
                done(.success(request))
            }catch{
                return
            }
        }
        return requestTimeoutClosure
    }
}
extension TargetType{
    public var baseURL:Foundation.URL{
        return Foundation.URL(string:URL)!
    }
    public var headers: [String : String]? {
        return nil
    }
    //  单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
}
public enum RequestAPI {
    //业务员登录
    case adminUserLogin(userAccount:String,userPossword:String)
    
    /***商品接口****/
    
    //新增商品接口
    case saveGoods(goodInfoName:String,goodUcode:String,goodUnit:String,goodsPrice:String,stock:Int,goodLife:String,goodSource:String,goodService:String,goodPic:String,goodsDetailsPic:String,goodInfoCode:String,goodMixed:String,remark:String,fCategoryId:Int,sCategoryId:Int,storeId:Int,lyPic:String,lyMiaoshu:String,producer:String,goodsMemberPrice:String,memberPriceMiniCount:Int,goodsSaleFlag:Int,sellerAddress:String,weight:String)
    //查询商品
    case getAllGoods(flagHidden:Int,pageNumber:Int,pageSize:Int,storeId:Int)
    //商品详情接口
    case getGoodsById(goodsbasicInfoId:Int)
    //修改商品分类接口
    case changeGoodsCategory(goodsbasicInfoId:Int,fCategoryId:Int,sCategoryId:Int)
    //删除商品接口
    case delGoods(goodsbasicInfoId:Int)
    //商品上下架接口
    case changeGoodsFlag(goodsbasicInfoId:Int)
    //修改商品展示图片接口
    case changeGoodsPic(goodsDetailsPicId:Int,goodsDetailsPic:String)
    
    /*********扫码***********/
    
    //扫码获取邮寄信息（站点）
    case scanCodeGetInfo(codeInfo:String)
    //扫码接收物流包（司机）
    case scanCodeGetLogisticspack(codeInfo:String,userId:Int,shippingLinesId:Int)
    //扫码接收站点包（站点）
    case scanCodeGetStorepack(codeInfo:String,userId:Int,storeId:Int)
    //扫码接收快件（站点）
    case scanCodeGetExpressmailstorag(codeInfo:String,userId:Int,storeId:Int)
    //扫码接收快件（司机）
    case scanCodeGetExpressmailForGivestoragByDriver(codeInfo:String,userId:Int)
    //扫码接收快件（总仓）
    case scanCodeGetExpressmailForGivestoragByHeadquarters(codeInfo:String,userId:Int)
    
    /***********收件**************/
    
    //收件历史（站点）
    case queryCollectHistory(userId:Int,pageNumber:Int,pageSize:Int,statu:Int)
    //单号搜索收件历史（站点）
    case searchCollectHistory(userId:Int,sn:String)
    //时间搜索收件历史（站点）
    case searchCollectHistoryForStoreBystoreUserCtime(userId:Int,startTime:String,endTime:String,pageNumber:Int,pageSize:Int)
    //站点确认收件完成
    case storeTransferToMember(userId:Int,expressmailStorageId:Int)
    //收件历史（司机）--查询物流包
    case queryCollectHistoryForDriverForLogisticspack(userId:Int,pageNumber:Int,pageSize:Int)
    //收件历史（司机）
    case queryCollectHistoryForDriver(userId:Int,pageNumber:Int,pageSize:Int,statu:Int)
    //时间搜索收件历史(司机)
    case searchCollectHistoryForDriverByDriverUserCtime(userId:Int,startTime:String,endTime:String,pageNumber:Int,pageSize:Int)
    
    /***********揽件*************/
    //录入邮寄快递(也就是给快递公司的时候)
    case inputExpress(expressmailId:Int,weight:String,amount:Int,freight:String,payType:Int,inputRemarks:String,expressName:String,expressCode:String,expressNo:String,userId:Int,userAllSave:Int?,storeToHeadquarters:String,insuredStatu:Int,insuredMoney:Int,height:String?,width:String?,length:String?,moneyToMember:String,moneyToStore:String,moneyToCompany:String,expressCodeId:Int,facePic:String,conPic:String,idCard:String,emIdentityId:Int?,idCardFlag:Int,packagePic:String)
    //揽件历史（站点）
    case queryGiveHistory(userId:Int,pageNumber:Int,pageSize:Int,statu:Int)
    //单号搜索揽件历史（站点）
    case searchGiveHistory(userId:Int,sn:String)
    //揽件历史(司机)
    case queryGiveHistoryForDriver(userId:Int,pageNumber:Int,pageSize:Int,statu:Int)
    //时间搜索揽件历史(站点)
    case searchGiveHistoryForExpressLinkTime(userId:Int,startTime:String,endTime:String,pageNumber:Int,pageSize:Int)
    //时间搜索揽件历史(司机)
    case searchGiveHistoryForDriverUserCtime(userId:Int,startTime:String,endTime:String,pageNumber:Int,pageSize:Int)
    //路线明细
    case queryShippinglines()
    //查询所有快递公司编码
    case wlQueryExpresscode()
    //查询一级分类
    case queryGoodsCateGoryForOne()
    //查询下级分类
    case queryGoodsCateGoryWhereGoodsCateGoryPId(pid:Int)
    
    //保存邮寄快递
    case saveExpress(fromName:String,fromprovince:String,fromcity:String,fromcounty:String,fromphoneNumber:String,fromRemarks:String,toName:String,toprovince:String,tocity:String,tocounty:String,todetailAddress:String,tophoneNumber:String,toRemarks:String,savaType:Int)
    //站点业务员查询订单列表
    case queryOrderInfoAndGoods(storeId:Int,pageNumber:Int,pageSize:Int,orderStatu:Int)
    //查询订单详情
    case queryOrderDetailsInfoAndGoods(orderInfoId:Int)
    //站点人员发货
    case storeTodeliver(orderInfoId:Int,storeId:Int,expressCode:String,logisticsSN:String,freight:String,storeToHeadquarters:String,weight:Int,expressName:String,userId:Int,moneyToMember:String,moneyToStore:String,moneyToCompany:String,length:String?,width:String?,height:String?,expressCodeId:Int)
    //计算运费
    case expressmailFreight(expressCode:String,weight:Int,province:String,length:String?,width:String?,height:String?,insuredMoney:Int,city:String)
    //查询积分余额
    case queryStoreCapitalSumMoney(storeId:Int)
    //查询物流设置信息
    case queryCxhSetInfo()
    //新建提现信息
    case addWithdrawa(withdrawaName:String,withdrawaBankCardNumber:String,withdrawaStoreId:Int,withdrawaBankName:String,withdrawaBankBranch:String)
    //修改提现信息
    case updateWithdrawa(withdrawaId:Int,withdrawaName:String,withdrawaBankCardNumber:String,withdrawaStoreId:Int,withdrawaBankName:String,withdrawaBankBranch:String)
    //查询提现信息
    case queryWithdrawa(storeId:Int)
    //提现
    case withdrawaTure(withdrawaId:Int?,withdrawaMoney:Int,storeId:Int,withdrawaType:Int)
    
    //查询退货申请
    case storeQueryReturngoodsapply(storeId:Int,statu:Int,pageNumber:Int,pageSize:Int)
    //站点确认退货
    case storeConfirmReturngoods(storeId:Int,orderInfoId:Int)
    //消费/扣除记录
    case queryStorecapitalrecord(storeId:Int,pageNumber:Int,pageSize:Int)
    //提现记录
    case queryWithdrawaRecord(storeId:Int,pageNumber:Int,pageSize:Int)
    //充值记录
    case queryStorePrepaidrecord(storeId:Int,pageNumber:Int,pageSize:Int)
    //根据条码查询是揽件还是收件
    case codeInfoQueryMain(codeInfo:String)
    //代签收
    case replaceSignForUser(userId:Int,expressmailStorageId:Int,identity:Int)
    //快递申请退件
    case storeReturn(userId:Int,expressmailStorageId:Int,identity:Int)
    //根据物流包查询站点包--司机
    case queryCollectHistoryForDriverForStorepackByLogisticsPackId(logisticsPackId:Int,pageNumber:Int,pageSize:Int)
    //根据站点包查询快件
    case queryCollectHistoryForDriverForExpressmailstoragByStorePackId(storePackId:Int,pageNumber:Int,pageSize:Int)
    //收件历史（站点）--查询站点包
    case queryCollectHistoryForStorepackByStoreUserId(userId:Int,pageNumber:Int,pageSize:Int)
    //司机接收退件的快件
    case driverGetReturn(codeInfo:String,userId:Int)
    //总仓接收退件快件
    case headquartersGetReturn(codeInfo:String,userId:Int)
    //代签收记录
    case queryReplaceSignForUser(userId:Int,identity:Int,pageNumber:Int,pageSize:Int)
    //总仓扫码代签收
    case scanCodeQueryExpressmailstorag(userId:Int,codeInfo:String)
    //扫码查询揽件信息
    case scanCodeGetExpressmailInfo(userId:Int,codeInfo:String)
    //总仓提交修改重量
    case updateExpressmailInfoByHeadquarters(expressmailId:Int,expressLinkId:Int,userId:Int,weight:Int,freight:String,moneyToMember:String,moneyToStore:String,moneyToCompany:String,length:String?,width:String?,height:String?)
    //站点查询重量修改记录
    case storeQueryExpressmailUpdateInfo(storeId:Int,pageNumber:Int,pageSize:Int)
    //站点确定修改
    case storeConfirmUpdateExpressmailInfo(storeId:Int,expressmailUpdateRecordId:Int,userId:Int)
    //返件记录
    case queryReturnHistory(userId:Int,identity:Int,pageNumber:Int,pageSize:Int)
    //按揽件id查询单号详情
    case queryExpressmailDetail(expressmailId:Int)
    //修改密码
    case savePwd(account:String,oldPwd:String,newPwd:String)
    //司机手动揽件
    case getExpressmailForGivestoragByDriver(codeInfo:String,userId:Int)
    //站点收支统计
    case storeTongji(storeId:Int,time:String?)
    //查询省市区信息
    case selectAddressInfo(pid:Int)
    //体验店菜品列表
    case getFoodByTestStoreId(pageNumber:Int,pageSize:Int,testStoreId:Int,flagHidden:Int)
    //上传菜品
    case saveFood(foodName:String,foodPrice:String,foodRemark:String,foodUnit:String,foodPic:String,testStoreId:Int,foodUcode:String,foodMixed:String,foodCode:String,stock:Int,foodDetailPic:String)
    //菜品上下架
    case foodUpDown(foodId:Int,stock:Int?)
    //获取菜品详情
    case getFoodById(foodId:Int)
    //通过身份证号码查询是否以前有录入过
    case queryIdentityByEmIdentityId(idCard:String)
    //上传身份证
    case idCardUploads(idCardImg:String,filePath:String)
    case testStoreUpload(Img:String,filePath:String)
    case goodsUploads(goodsImg:String,filePath:String)
    
}
extension RequestAPI:TargetType{
    public var headers: [String : String]? {
        return nil
    }
    
    public var baseURL:Foundation.URL{
        return Foundation.URL(string:URL)!
    }
    public var path:String{
        switch self{
        case .adminUserLogin(_,_):
            return "adminUser/adminUserLogin"
        case .saveGoods(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_):
            return "goodsB/saveGoods"
        case .getAllGoods(_,_,_,_):
            return "goodsB/getAllGoods"
        case .getGoodsById(_):
            return "goodsB/getGoodsById"
        case .changeGoodsCategory(_,_,_):
            return "goodsB/changeGoodsCategory"
        case .delGoods(_):
            return "goodsB/delGoods"
        case .changeGoodsFlag(_):
            return "goodsB/changeGoodsFlag"
        case .changeGoodsPic(_,_):
            return "goodsB/changeGoodsPic"
        case .scanCodeGetInfo(_):
            return "adminUser/scanCodeGetInfo"
        case .scanCodeGetLogisticspack(_,_,_):
            return "adminUser/scanCodeGetLogisticspack"
        case .scanCodeGetStorepack(_,_,_):
            return "adminUser/scanCodeGetStorepack"
        case .scanCodeGetExpressmailstorag(_,_,_):
            return "adminUser/scanCodeGetExpressmailstorag"
        case .queryCollectHistory(_,_,_,_):
            return "adminCollect/queryCollectHistory"
        case .searchCollectHistory(_,_):
            return "adminCollect/searchCollectHistory"
        case .inputExpress(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_):
            return "express/inputExpress"
        case .queryGiveHistory(_,_,_,_):
            return "adminGive/queryGiveHistory"
        case .searchGiveHistory(_,_):
            return "adminGive/searchGiveHistory"
        case .queryShippinglines():
            return "adminUser/queryShippinglines"
        case .wlQueryExpresscode():
            return "wl/wlQueryExpresscode"
        case .queryGoodsCateGoryForOne():
            return "fl/queryGoodsCateGoryForOne"
        case .queryGoodsCateGoryWhereGoodsCateGoryPId(_):
            return "fl/queryGoodsCateGoryWhereGoodsCateGoryPId"
        case .saveExpress(_,_,_,_,_,_,_,_,_,_,_,_,_,_):
            return "express/saveExpress"
        case .queryOrderInfoAndGoods(_,_,_,_):
            return "adminOrder/queryOrderInfoAndGoods"
        case .queryOrderDetailsInfoAndGoods(_):
            return "queryOrder/queryOrderDetailsInfoAndGoods"
        case .storeTodeliver(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_):
            return "adminOrder/storeTodeliver"
        case .expressmailFreight(_,_,_,_,_,_,_,_):
            return "adminGive/expressmailFreight"
        case .scanCodeGetExpressmailForGivestoragByDriver(_,_):
            return "adminGive/scanCodeGetExpressmailForGivestoragByDriver"
        case .queryStoreCapitalSumMoney(_):
            return "adminUser/queryStoreCapitalSumMoney"
        case .searchCollectHistoryForStoreBystoreUserCtime(_,_,_,_,_):
            return "adminCollect/searchCollectHistoryForStoreBystoreUserCtime"
        case .queryCollectHistoryForDriver(_,_,_,_):
            return "adminCollect/queryCollectHistoryForDriver"
        case .queryGiveHistoryForDriver(_,_,_,_):
            return "adminGive/queryGiveHistoryForDriver"
        case .searchCollectHistoryForDriverByDriverUserCtime(_,_,_,_,_):
            return "adminCollect/searchCollectHistoryForDriverByDriverUserCtime"
        case .searchGiveHistoryForExpressLinkTime(_,_,_,_,_):
            return "adminGive/searchGiveHistoryForExpressLinkTime"
        case .searchGiveHistoryForDriverUserCtime(_,_,_,_,_):
            return "adminGive/searchGiveHistoryForDriverUserCtime"
        case .queryCxhSetInfo():
            return "adminUser/queryCxhSetInfo"
        case .addWithdrawa(_,_,_,_,_):
            return "withdrawa/addWithdrawa"
        case .updateWithdrawa(_,_,_,_,_,_):
            return "withdrawa/updateWithdrawa"
        case .queryWithdrawa(_):
            return "withdrawa/queryWithdrawa"
        case .withdrawaTure(_,_,_,_):
            return "withdrawa/withdrawaTure"
        case .storeTransferToMember(_,_):
            return "adminCollect/storeTransferToMember"
        case .scanCodeGetExpressmailForGivestoragByHeadquarters(_,_):
            return "adminGive/scanCodeGetExpressmailForGivestoragByHeadquarters"
        case .storeQueryReturngoodsapply(_,_,_,_):
            return "adminRgc/storeQueryReturngoodsapply"
        case .storeConfirmReturngoods(_,_):
            return "adminRgc/storeConfirmReturngoods"
        case .queryStorecapitalrecord(_,_,_):
            return "cc/queryStorecapitalrecord"
        case .queryWithdrawaRecord(_,_,_):
            return "withdrawa/queryWithdrawaRecord"
        case .queryStorePrepaidrecord(_,_,_):
            return "adminSpc/queryStorePrepaidrecord"
        case .codeInfoQueryMain(_):
            return "adminUser/codeInfoQueryMain"
        case .replaceSignForUser(_,_,_):
            return "wl/replaceSignForUser"
        case .storeReturn(_,_,_):
            return "rs/storeReturn"
        case .queryCollectHistoryForDriverForLogisticspack(_,_,_):
            return "adminCollect/queryCollectHistoryForDriverForLogisticspack"
        case .queryCollectHistoryForDriverForStorepackByLogisticsPackId(_,_,_):
            return "adminCollect/queryCollectHistoryForDriverForStorepackByLogisticsPackId"
        case .queryCollectHistoryForDriverForExpressmailstoragByStorePackId(_,_,_):
            return "adminCollect/queryCollectHistoryForDriverForExpressmailstoragByStorePackId"
        case .queryCollectHistoryForStorepackByStoreUserId(_,_,_):
            return "adminCollect/queryCollectHistoryForStorepackByStoreUserId"
        case .driverGetReturn(_,_):
            return "rs/driverGetReturn"
        case .headquartersGetReturn(_,_):
            return "rs/headquartersGetReturn"
        case .queryReplaceSignForUser(_,_,_,_):
            return "wl/queryReplaceSignForUser"
        case .scanCodeQueryExpressmailstorag(_,_):
            return "adminCollect/scanCodeQueryExpressmailstorag"
        case .scanCodeGetExpressmailInfo(_,_):
            return "adminGive/scanCodeGetExpressmailInfo"
        case .updateExpressmailInfoByHeadquarters(_,_,_,_,_,_,_,_,_,_,_):
            return "adminGive/updateExpressmailInfoByHeadquarters"
        case .storeQueryExpressmailUpdateInfo(_,_,_):
            return "adminGive/storeQueryExpressmailUpdateInfo"
        case .storeConfirmUpdateExpressmailInfo(_,_,_):
            return "adminGive/storeConfirmUpdateExpressmailInfo"
        case .queryReturnHistory(_,_,_,_):
            return "rs/queryReturnHistory"
        case .queryExpressmailDetail(_):
            return "express/queryExpressmailDetail"
        case .savePwd(_,_,_):
            return "user/savePwd"
        case .getExpressmailForGivestoragByDriver(_,_):
            return "adminGive/getExpressmailForGivestoragByDriver"
        case .storeTongji(_,_):
            return "store/storeTongji"
        case .selectAddressInfo(_):
            return "addressU/getAddressByPid"
        case .getFoodByTestStoreId(_,_,_,_):
            return "tsF/getFoodByTestStoreId"
        case .saveFood(_,_,_,_,_,_,_,_,_,_,_):
            return "tgF/saveFood"
        case .foodUpDown(_,_):
            return "tgF/foodUpDown"
        case .getFoodById(_):
            return "tgF/getFoodById"
        case .queryIdentityByEmIdentityId(_):
            return "express/queryIdentityByEmIdentityId"
        case .idCardUploads(_,_):
            return "goodsUp/idCardUploads"
        case .testStoreUpload(_,_):
            return "goodsUp/testStoreUpload"
        case .goodsUploads(_,_):
            return "goodsUp/goodsUploads"
        }
        
    }
    public var method:Moya.Method{
        switch self{
        case .adminUserLogin(_,_),.saveGoods(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),.getAllGoods(_,_,_,_),.changeGoodsCategory(_,_,_),.delGoods(_),.changeGoodsFlag(_),.changeGoodsPic(_,_),.scanCodeGetInfo(_),.scanCodeGetLogisticspack(_,_,_),.scanCodeGetStorepack(_,_,_),.scanCodeGetExpressmailstorag(_,_,_),.searchCollectHistory(_,_),.inputExpress(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),.searchGiveHistory(_,_),.saveExpress(_,_,_,_,_,_,_,_,_,_,_,_,_,_),.storeTodeliver(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),.expressmailFreight(_,_,_,_,_,_,_,_),.scanCodeGetExpressmailForGivestoragByDriver(_,_),.addWithdrawa(_,_,_,_,_),.updateWithdrawa(_,_,_,_,_,_),.withdrawaTure(_,_,_,_),.storeTransferToMember(_,_),.scanCodeGetExpressmailForGivestoragByHeadquarters(_,_),.storeConfirmReturngoods(_,_),.codeInfoQueryMain(_),.replaceSignForUser(_,_,_),.driverGetReturn(_,_),.headquartersGetReturn(_,_),.updateExpressmailInfoByHeadquarters(_,_,_,_,_,_,_,_,_,_,_),.storeConfirmUpdateExpressmailInfo(_,_,_),.savePwd(_,_,_),.storeTongji(_,_),.getFoodByTestStoreId(_,_,_,_),.saveFood(_,_,_,_,_,_,_,_,_,_,_),.foodUpDown(_,_),.getFoodById(_),.queryIdentityByEmIdentityId(_),.idCardUploads(_,_),.testStoreUpload(_,_),.goodsUploads(_,_):
            return .post
        case .getGoodsById(_),.queryCollectHistory(_,_,_,_),.queryGiveHistory(_,_,_,_),.queryShippinglines(),.wlQueryExpresscode(),.queryGoodsCateGoryForOne(),.queryGoodsCateGoryWhereGoodsCateGoryPId(_),.queryOrderInfoAndGoods(_,_,_,_),.queryOrderDetailsInfoAndGoods(_),.queryStoreCapitalSumMoney(_),.searchCollectHistoryForStoreBystoreUserCtime(_,_,_,_,_),.queryCollectHistoryForDriver(_,_,_,_),.queryGiveHistoryForDriver(_,_,_,_),.searchCollectHistoryForDriverByDriverUserCtime(_,_,_,_,_),.searchGiveHistoryForExpressLinkTime(_,_,_,_,_),.searchGiveHistoryForDriverUserCtime(_,_,_,_,_),.queryCxhSetInfo(),.queryWithdrawa(_),.storeQueryReturngoodsapply(_,_,_,_),.queryStorecapitalrecord(_,_,_),.queryWithdrawaRecord(_,_,_),.queryStorePrepaidrecord(_,_,_),.storeReturn(_,_,_),.queryCollectHistoryForDriverForLogisticspack(_,_,_),.queryCollectHistoryForDriverForStorepackByLogisticsPackId(_,_,_),.queryCollectHistoryForDriverForExpressmailstoragByStorePackId(_,_,_),.queryCollectHistoryForStorepackByStoreUserId(_,_,_),.queryReplaceSignForUser(_,_,_,_),.scanCodeQueryExpressmailstorag(_,_),.scanCodeGetExpressmailInfo(_,_),.storeQueryExpressmailUpdateInfo(_,_,_),.queryReturnHistory(_,_,_,_),.queryExpressmailDetail(_),.getExpressmailForGivestoragByDriver(_,_),.selectAddressInfo(_):
            return .get
        }
    }
    public var task: Task {
        switch self {
        case let .adminUserLogin(userAccount, userPossword):
            return .requestParameters(parameters: ["userAccount":userAccount,"userPossword":userPossword], encoding: URLEncoding.default)
        case let .saveGoods(goodInfoName, goodUcode, goodUnit, goodsPrice, stock, goodLife, goodSource, goodService, goodPic, goodsDetailsPic, goodInfoCode, goodMixed, remark, fCategoryId, sCategoryId,storeId,lyPic,lyMiaoshu,producer,goodsMemberPrice,memberPriceMiniCount,goodsSaleFlag,sellerAddress,weight):
            return .requestParameters(parameters:["goodInfoName":goodInfoName,"goodUcode":goodUcode,"goodUnit":goodUnit,"goodsPrice":goodsPrice,"stock":stock,"goodLife":goodLife,"goodSource":goodSource,"goodService":goodService,"goodPic":goodPic,"goodsDetailsPic":goodsDetailsPic,"goodInfoCode":goodInfoCode,"goodMixed":goodMixed,"remark":remark,"fCategoryId":fCategoryId,"sCategoryId":sCategoryId,"storeId":storeId,"lyPic":lyPic,"lyMiaoshu":lyMiaoshu,"producer":producer,"goodsMemberPrice":goodsMemberPrice,"memberPriceMiniCount":memberPriceMiniCount,"goodsSaleFlag":goodsSaleFlag,"sellerAddress":sellerAddress,"weight":weight], encoding: URLEncoding.default)
        case let.getAllGoods(flagHidden, pageNumber, pageSize,storeId):
            return .requestParameters(parameters:["flagHidden":flagHidden,"pageNumber":pageNumber,"pageSize":pageSize,"storeId":storeId], encoding: URLEncoding.default)
        case let .getGoodsById(goodsbasicInfoId):
            return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId], encoding: URLEncoding.default)
        case let .changeGoodsCategory(goodsbasicInfoId, fCategoryId, sCategoryId):
            return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId,"fCategoryId":fCategoryId,"sCategoryId":sCategoryId], encoding: URLEncoding.default)
        case let .delGoods(goodsbasicInfoId):
            return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId], encoding: URLEncoding.default)
        case let .changeGoodsFlag(goodsbasicInfoId):
            return .requestParameters(parameters:["goodsbasicInfoId":goodsbasicInfoId], encoding: URLEncoding.default)
        case let .changeGoodsPic(goodsDetailsPicId, goodsDetailsPic):
            return .requestParameters(parameters:["goodsDetailsPicId":goodsDetailsPicId,"goodsDetailsPic":goodsDetailsPic], encoding: URLEncoding.default)
        case let .scanCodeGetInfo(codeInfo):
            return .requestParameters(parameters:["codeInfo":codeInfo], encoding: URLEncoding.default)
        case let .scanCodeGetLogisticspack(codeInfo, userId, shippingLinesId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId,"shippingLinesId":shippingLinesId], encoding: URLEncoding.default)
        case let .scanCodeGetStorepack(codeInfo, userId, storeId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId,"storeId":storeId], encoding: URLEncoding.default)
        case let .scanCodeGetExpressmailstorag(codeInfo, userId, storeId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId,"storeId":storeId], encoding: URLEncoding.default)
        case let .queryCollectHistory(userId, pageNumber, pageSize,statu):
            return .requestParameters(parameters:["userId":userId,"pageNumber":pageNumber,"pageSize":pageSize,"statu":statu], encoding: URLEncoding.default)
        case let .searchCollectHistory(userId, sn):
            return .requestParameters(parameters:["userId":userId,"sn":sn], encoding: URLEncoding.default)
        case let .inputExpress(expressmailId, weight, amount, freight, payType, inputRemarks, expressName, expressCode, expressNo, userId, userAllSave,storeToHeadquarters,insuredStatu,insuredMoney,height,width,length,moneyToMember, moneyToStore, moneyToCompany,expressCodeId,facePic,conPic,idCard,emIdentityId,idCardFlag,packagePic):
            if userAllSave == nil{
                if emIdentityId != nil{
                    return .requestParameters(parameters:["expressmailId":expressmailId,"weight":weight,"amount":amount,"freight":freight,"payType":payType,"inputRemarks":inputRemarks,"expressName":expressName,"expressCode":expressCode,"expressNo":expressNo,"userId":userId,"storeToHeadquarters":storeToHeadquarters,"insuredStatu":insuredStatu,"insuredMoney":insuredMoney,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"expressCodeId":expressCodeId,"facePic":facePic,"conPic":conPic,"idCard":idCard,"emIdentityId":emIdentityId!,"idCardFlag":idCardFlag,"packagePic":packagePic], encoding: URLEncoding.default)
                }else{
                    return .requestParameters(parameters:["expressmailId":expressmailId,"weight":weight,"amount":amount,"freight":freight,"payType":payType,"inputRemarks":inputRemarks,"expressName":expressName,"expressCode":expressCode,"expressNo":expressNo,"userId":userId,"storeToHeadquarters":storeToHeadquarters,"insuredStatu":insuredStatu,"insuredMoney":insuredMoney,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"expressCodeId":expressCodeId,"facePic":facePic,"conPic":conPic,"idCard":idCard,"idCardFlag":idCardFlag,"packagePic":packagePic], encoding: URLEncoding.default)
                }
            }else{
                if height == nil{
                    if emIdentityId != nil{
                        return .requestParameters(parameters:["expressmailId":expressmailId,"weight":weight,"amount":amount,"freight":freight,"payType":payType,"inputRemarks":inputRemarks,"expressName":expressName,"expressCode":expressCode,"expressNo":expressNo,"userId":userId,"userAllSave":userAllSave!,"storeToHeadquarters":storeToHeadquarters,"insuredStatu":insuredStatu,"insuredMoney":insuredMoney,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"expressCodeId":expressCodeId,"facePic":facePic,"conPic":conPic,"idCard":idCard,"emIdentityId":emIdentityId!,"idCardFlag":idCardFlag,"packagePic":packagePic], encoding: URLEncoding.default)
                    }else{
                        return .requestParameters(parameters:["expressmailId":expressmailId,"weight":weight,"amount":amount,"freight":freight,"payType":payType,"inputRemarks":inputRemarks,"expressName":expressName,"expressCode":expressCode,"expressNo":expressNo,"userId":userId,"userAllSave":userAllSave!,"storeToHeadquarters":storeToHeadquarters,"insuredStatu":insuredStatu,"insuredMoney":insuredMoney,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"expressCodeId":expressCodeId,"facePic":facePic,"conPic":conPic,"idCard":idCard,"idCardFlag":idCardFlag,"packagePic":packagePic], encoding: URLEncoding.default)
                    }
                }else{
                    if emIdentityId != nil{
                        return .requestParameters(parameters:["expressmailId":expressmailId,"weight":weight,"amount":amount,"freight":freight,"payType":payType,"inputRemarks":inputRemarks,"expressName":expressName,"expressCode":expressCode,"expressNo":expressNo,"userId":userId,"userAllSave":userAllSave!,"storeToHeadquarters":storeToHeadquarters,"insuredStatu":insuredStatu,"insuredMoney":insuredMoney,"height":height!,"width":width!,"length":length!,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"expressCodeId":expressCodeId,"facePic":facePic,"conPic":conPic,"idCard":idCard,"emIdentityId":emIdentityId!,"idCardFlag":idCardFlag,"packagePic":packagePic], encoding: URLEncoding.default)
                    }else{
                        return .requestParameters(parameters:["expressmailId":expressmailId,"weight":weight,"amount":amount,"freight":freight,"payType":payType,"inputRemarks":inputRemarks,"expressName":expressName,"expressCode":expressCode,"expressNo":expressNo,"userId":userId,"userAllSave":userAllSave!,"storeToHeadquarters":storeToHeadquarters,"insuredStatu":insuredStatu,"insuredMoney":insuredMoney,"height":height!,"width":width!,"length":length!,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"expressCodeId":expressCodeId,"facePic":facePic,"conPic":conPic,"idCard":idCard,"idCardFlag":idCardFlag,"packagePic":packagePic], encoding: URLEncoding.default)
                    }
                }
            }
        case let .queryGiveHistory(userId, pageNumber, pageSize,statu):
            return .requestParameters(parameters:["userId":userId,"pageNumber":pageNumber,"pageSize":pageSize,"statu":statu], encoding: URLEncoding.default)
        case let .searchGiveHistory(userId, sn):
            return .requestParameters(parameters:["userId":userId,"sn":sn], encoding: URLEncoding.default)
        case .queryShippinglines():
            return .requestPlain
        case .wlQueryExpresscode():
            return .requestPlain
        case .queryGoodsCateGoryForOne():
            return .requestPlain
        case let .queryGoodsCateGoryWhereGoodsCateGoryPId(pid):
            return .requestParameters(parameters:["pid":pid], encoding: URLEncoding.default)
        case let .saveExpress(fromName, fromprovince, fromcity, fromcounty, fromphoneNumber, fromRemarks, toName, toprovince, tocity, tocounty, todetailAddress, tophoneNumber, toRemarks, savaType):
            return .requestParameters(parameters:["fromName":fromName,"fromprovince":fromprovince,"fromcity":fromcity,"fromcounty":fromcounty,"fromphoneNumber":fromphoneNumber,"fromRemarks":fromRemarks,"toName":toName,"toprovince":toprovince,"tocity":tocity,"tocounty":tocounty,"todetailAddress":todetailAddress,"tophoneNumber":tophoneNumber,"toRemarks":toRemarks,"savaType":savaType], encoding: URLEncoding.default)
        case let .queryOrderInfoAndGoods(storeId, pageNumber, pageSize, orderStatu):
            return .requestParameters(parameters:["storeId":storeId,"pageNumber":pageNumber,"pageSize":pageSize,"orderStatu":orderStatu], encoding: URLEncoding.default)
        case let .queryOrderDetailsInfoAndGoods(orderInfoId):
            return .requestParameters(parameters:["orderInfoId":orderInfoId], encoding: URLEncoding.default)
        case let .storeTodeliver(orderInfoId, storeId, expressCode, logisticsSN, freight, storeToHeadquarters,weight,expressName,userId,moneyToMember,moneyToStore,moneyToCompany,length,width,height,expressCodeId):
            if length != nil{
                return .requestParameters(parameters:["orderInfoId":orderInfoId,"storeId":storeId,"expressCode":expressCode,"logisticsSN":logisticsSN,"freight":freight,"storeToHeadquarters":storeToHeadquarters,"weight":weight,"expressName":expressName,"userId":userId,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"length":length!,"width":width!,"height":height!,"expressCodeId":expressCodeId], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["orderInfoId":orderInfoId,"storeId":storeId,"expressCode":expressCode,"logisticsSN":logisticsSN,"freight":freight,"storeToHeadquarters":storeToHeadquarters,"weight":weight,"expressName":expressName,"userId":userId,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"expressCodeId":expressCodeId], encoding: URLEncoding.default)
            }
        case let .expressmailFreight(expressCode, weight,province,length,width,height,insuredMoney,city):
            if length != nil{
                return .requestParameters(parameters:["expressCode":expressCode,"weight":weight,"province":province,"length":length!,"width":width!,"height":height!,"insuredMoney":insuredMoney,"city":city], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["expressCode":expressCode,"weight":weight,"province":province,"insuredMoney":insuredMoney,"city":city], encoding: URLEncoding.default)
            }
        case let .scanCodeGetExpressmailForGivestoragByDriver(codeInfo,userId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId], encoding: URLEncoding.default)
        case let .queryStoreCapitalSumMoney(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .searchCollectHistoryForStoreBystoreUserCtime(userId, startTime, endTime, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"startTime":startTime,"endTime":endTime,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryCollectHistoryForDriver(userId, pageNumber, pageSize, statu):
            return .requestParameters(parameters:["userId":userId,"pageNumber":pageNumber,"pageSize":pageSize,"statu":statu], encoding: URLEncoding.default)
        case let .queryGiveHistoryForDriver(userId, pageNumber, pageSize, statu):
            return .requestParameters(parameters:["userId":userId,"pageNumber":pageNumber,"pageSize":pageSize,"statu":statu], encoding: URLEncoding.default)
        case let .searchCollectHistoryForDriverByDriverUserCtime(userId, startTime, endTime, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"startTime":startTime,"endTime":endTime,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .searchGiveHistoryForExpressLinkTime(userId, startTime, endTime, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"startTime":startTime,"endTime":endTime,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .searchGiveHistoryForDriverUserCtime(userId, startTime, endTime, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"startTime":startTime,"endTime":endTime,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case .queryCxhSetInfo():
            return .requestPlain
        case let .addWithdrawa(withdrawaName, withdrawaBankCardNumber, withdrawaStoreId,withdrawaBankName, withdrawaBankBranch):
            return .requestParameters(parameters:["withdrawaName":withdrawaName,"withdrawaBankCardNumber":withdrawaBankCardNumber,"withdrawaStoreId":withdrawaStoreId,"withdrawaBankBranch":withdrawaBankBranch,"withdrawaBankName":withdrawaBankName], encoding: URLEncoding.default)
        case let .updateWithdrawa(withdrawaId, withdrawaName, withdrawaBankCardNumber, withdrawaStoreId, withdrawaBankName, withdrawaBankBranch):
            return .requestParameters(parameters:["withdrawaId":withdrawaId,"withdrawaName":withdrawaName,"withdrawaBankCardNumber":withdrawaBankCardNumber,"withdrawaStoreId":withdrawaStoreId,"withdrawaBankName":withdrawaBankName,"withdrawaBankBranch":withdrawaBankBranch], encoding: URLEncoding.default)
        case let .queryWithdrawa(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .withdrawaTure(withdrawaId, withdrawaMoney, storeId,withdrawaType):
            if withdrawaId != nil{
                return .requestParameters(parameters:["withdrawaId":withdrawaId!,"withdrawaMoney":withdrawaMoney,"storeId":storeId,"withdrawaType":withdrawaType], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["withdrawaMoney":withdrawaMoney,"storeId":storeId,"withdrawaType":withdrawaType], encoding: URLEncoding.default)
            }
        case let .storeTransferToMember(userId, expressmailStorageId):
            return .requestParameters(parameters:["userId":userId,"expressmailStorageId":expressmailStorageId], encoding: URLEncoding.default)
        case let .scanCodeGetExpressmailForGivestoragByHeadquarters(codeInfo, userId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId], encoding: URLEncoding.default)
        case let .storeQueryReturngoodsapply(storeId, statu, pageNumber, pageSize):
            return .requestParameters(parameters:["storeId":storeId,"statu":statu,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .storeConfirmReturngoods(storeId, orderInfoId):
            return .requestParameters(parameters:["storeId":storeId,"orderInfoId":orderInfoId], encoding: URLEncoding.default)
        case let .queryStorecapitalrecord(storeId, pageNumber, pageSize):
            return .requestParameters(parameters:["storeId":storeId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryWithdrawaRecord(storeId, pageNumber, pageSize):
            return .requestParameters(parameters:["storeId":storeId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryStorePrepaidrecord(storeId, pageNumber, pageSize):
            return .requestParameters(parameters:["storeId":storeId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .codeInfoQueryMain(codeInfo):
            return .requestParameters(parameters:["codeInfo":codeInfo], encoding: URLEncoding.default)
        case let .replaceSignForUser(userId, expressmailStorageId, identity):
            return .requestParameters(parameters:["userId":userId,"expressmailStorageId":expressmailStorageId,"identity":identity], encoding: URLEncoding.default)
        case let .storeReturn(userId, expressmailStorageId, identity):
            return .requestParameters(parameters:["userId":userId,"expressmailStorageId":expressmailStorageId,"identity":identity], encoding: URLEncoding.default)
        case let .queryCollectHistoryForDriverForLogisticspack(userId, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryCollectHistoryForDriverForStorepackByLogisticsPackId(logisticsPackId,pageNumber,pageSize):
            return .requestParameters(parameters:["logisticsPackId":logisticsPackId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryCollectHistoryForDriverForExpressmailstoragByStorePackId(storePackId, pageNumber, pageSize):
            return .requestParameters(parameters:["storePackId":storePackId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryCollectHistoryForStorepackByStoreUserId(userId, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .driverGetReturn(codeInfo, userId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId], encoding: URLEncoding.default)
        case let .headquartersGetReturn(codeInfo, userId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId], encoding: URLEncoding.default)
        case let .queryReplaceSignForUser(userId, identity, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"identity":identity,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .scanCodeQueryExpressmailstorag(userId, codeInfo):
            return .requestParameters(parameters:["userId":userId,"codeInfo":codeInfo], encoding: URLEncoding.default)
        case let .scanCodeGetExpressmailInfo(userId, codeInfo):
            return .requestParameters(parameters:["userId":userId,"codeInfo":codeInfo], encoding: URLEncoding.default)
        case let .updateExpressmailInfoByHeadquarters(expressmailId, expressLinkId, userId, weight, freight, moneyToMember, moneyToStore, moneyToCompany, length, width, height):
            if length != nil{
                return .requestParameters(parameters:["expressmailId":expressmailId,"expressLinkId":expressLinkId,"userId":userId,"weight":weight,"freight":freight,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany,"length":length!,"width":width!,"height":height!], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["expressmailId":expressmailId,"expressLinkId":expressLinkId,"userId":userId,"weight":weight,"freight":freight,"moneyToMember":moneyToMember,"moneyToStore":moneyToStore,"moneyToCompany":moneyToCompany], encoding: URLEncoding.default)
            }
        case let .storeQueryExpressmailUpdateInfo(storeId, pageNumber, pageSize):
            return .requestParameters(parameters:["storeId":storeId,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .storeConfirmUpdateExpressmailInfo(storeId, expressmailUpdateRecordId, userId):
            return .requestParameters(parameters:["storeId":storeId,"expressmailUpdateRecordId":expressmailUpdateRecordId,"userId":userId], encoding: URLEncoding.default)
        case let .queryReturnHistory(userId, identity, pageNumber, pageSize):
            return .requestParameters(parameters:["userId":userId,"identity":identity,"pageNumber":pageNumber,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryExpressmailDetail(expressmailId):
            return .requestParameters(parameters:["expressmailId":expressmailId], encoding: URLEncoding.default)
        case let .savePwd(account, oldPwd, newPwd):
            return .requestParameters(parameters:["account":account,"oldPwd":oldPwd,"newPwd":newPwd], encoding: URLEncoding.default)
        case let .getExpressmailForGivestoragByDriver(codeInfo, userId):
            return .requestParameters(parameters:["codeInfo":codeInfo,"userId":userId], encoding: URLEncoding.default)
        case let .storeTongji(storeId, time):
            if time != nil{
                return .requestParameters(parameters:["storeId":storeId,"time":time!], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
            }
        case let .selectAddressInfo(pid):
            return .requestParameters(parameters:["pid":pid], encoding: URLEncoding.default)
        case let .getFoodByTestStoreId(pageNumber, pageSize, testStoreId, flagHidden):
            return .requestParameters(parameters:["pageNumber":pageNumber,"pageSize":pageSize,"testStoreId":testStoreId,"flagHidden":flagHidden], encoding: URLEncoding.default)
        case let .saveFood(foodName, foodPrice, foodRemark, foodUnit, foodPic, testStoreId, foodUcode, foodMixed, foodCode, stock, foodDetailPic):
            return .requestParameters(parameters:["foodName":foodName,"foodPrice":foodPrice,"foodRemark":foodRemark,"foodUnit":foodUnit,"foodPic":foodPic,"testStoreId":testStoreId,"foodUcode":foodUcode,"foodMixed":foodMixed,"foodCode":foodCode,"stock":stock,"foodDetailPic":foodDetailPic], encoding: URLEncoding.default)
        case let .foodUpDown(foodId,stock):
            if stock == nil{
                return .requestParameters(parameters:["foodId":foodId], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["foodId":foodId,"stock":stock!], encoding: URLEncoding.default)
            }
        case let .getFoodById(foodId):
            return .requestParameters(parameters:["foodId":foodId], encoding: URLEncoding.default)
        case let .queryIdentityByEmIdentityId(idCard):
            return .requestParameters(parameters:["idCard":idCard], encoding: URLEncoding.default)
        case let .idCardUploads(idCardImg, filePath):
            let imgData = MultipartFormData(provider: MultipartFormData.FormDataProvider.file(Foundation.URL(fileURLWithPath:filePath)),name:idCardImg)
            return .uploadMultipart([imgData])
        case let .testStoreUpload(Img, filePath):
            let imgData = MultipartFormData(provider: MultipartFormData.FormDataProvider.file(Foundation.URL(fileURLWithPath:filePath)),name:Img)
            return .uploadMultipart([imgData])
        case let .goodsUploads(goodsImg, filePath):
            let imgData = MultipartFormData(provider: MultipartFormData.FormDataProvider.file(Foundation.URL(fileURLWithPath:filePath)),name:goodsImg)
            return .uploadMultipart([imgData])
        }
    
    }
    //  单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
}
