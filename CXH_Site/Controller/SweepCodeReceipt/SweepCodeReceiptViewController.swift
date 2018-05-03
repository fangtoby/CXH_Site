//
//  SweepCodeReceiptViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/5/31.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftyJSON
import SVProgressHUD
import ObjectMapper
/// 扫码收件
class SweepCodeReceiptViewController:LBXScanViewController,LBXScanViewControllerDelegate{
//    1，站点包的二维码：名称以 ‘sp’ 开头+站点包ID，内容以 ‘sp-’开头+其他内容；
//    2，物流包的二维码：名称以 ‘lp’ 开头+物流包的ID，内容以 ‘lp-’开头+其他内容；
//    3，快递入库的二维码：名称以 ‘ms’ 开头+入库表的ID，内容以 ‘ms-’开头+其他内容；
//    4，寄件的二维码：名称为系统单号（”em”+时间戳），内容为单号+id；
    fileprivate var codeFlag:String?
    fileprivate let identity=userDefaults.object(forKey: "identity") as! Int
    // MARK: - init functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "二维码扫描"
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.isNeedShowRetangle = true;
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net");
        self.scanStyle=style
        self.isOpenInterestRect = true
        self.scanResultDelegate=self
    }
    override func navigationShouldPopOnBackButton() -> Bool {
        self.navigationController?.popToRootViewController(animated: true)
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        
        if scanResult.strBarCodeType == nil{
            showInfo("未识别二维码")
            return
        }
        if scanResult.strScanned == nil{
            showInfo("未识别二维码内容")
            return
        }
        if scanResult.strBarCodeType! == "org.iso.QRCode"{//判断是否是二维码
            code(scanResult.strScanned!)
        }else{
            codeInfoQueryMain(scanResult.strScanned!)
        }
    }
}
// MARK: - 网络请求
extension SweepCodeReceiptViewController{
    /**
     根据条码查询是揽件还是收件
     
     - parameter codeInfo: 条形码
     */
    func codeInfoQueryMain(_ codeInfo:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.codeInfoQueryMain(codeInfo:codeInfo), successClosure: { (result) -> Void in
            let json=JSON(result)
            let qrcode=json["qrcode"].stringValue
            self.code(qrcode)
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    //二维码
    func code(_ codeStr:String){
        let userId=userDefaults.object(forKey: "userId") as! Int
        let storeId=userDefaults.object(forKey: "storeId") as? Int
        print(codeStr)
        let index=codeStr.index(codeStr.startIndex, offsetBy:2)
        codeFlag=String(codeStr[..<index])
        if codeFlag != nil{
            SVProgressHUD.show(withStatus:"正在加载")
            switch codeFlag!{
            case "sp":
                if identity == 2{
                    self.scanCodeGetStorepack(codeStr, userId:userId,storeId:storeId!)
                }
                break
            case "lp":
                self.scanCodeGetLogisticspack(codeStr,userId:userId)
                break
            case "ms":
                if identity == 2{
                    self.scanCodeGetExpressmailstorag(codeStr, userId:userId,storeId:storeId!)
                }else if identity == 3{//司机接收退件
                    self.driverGetReturn(codeStr, userId:userId)
                }else if identity == 1{//仓库接收退件
                    self.headquartersGetReturn(codeStr, userId:userId)
                }
                break
            case "em":
                if identity == 2{
                    self.scanCodeGetInfo(codeStr)
                }else if identity == 3{
                    self.scanCodeGetExpressmailForGivestoragByDriver(codeStr, userId:userId)
                }else if identity == 1{
                    self.scanCodeGetExpressmailInfo(userId,codeInfo:codeStr)
                }
                break
            default:
                SVProgressHUD.dismiss()
                UIAlertController.showAlertYes(self, title:"亲,不要乱扫二维码", message:"二维码内容:"+codeStr, okButtonTitle:"OK")
                self.navigationController?.popViewController(animated:true)
                break
            }
        }

    }
    /**
     扫码接收物流包（司机）
     */
    func scanCodeGetLogisticspack(_ code:String,userId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetLogisticspack(codeInfo:code, userId:userId, shippingLinesId:0), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"接收物流包成功")
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "received"{
                self.showInfo("物流包已经被接收过了。不能再接收")
            }else if success == "notExist"{
                self.showInfo("物流包不存在")
            }else if success == "error"{
                self.showInfo("无权操作")
            }else{
                self.showInfo("扫码失败")
            }
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    /**
     扫码获取邮寄信息（站点）
     
     - parameter code:
     */
    func scanCodeGetInfo(_ code:String){
    
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetInfo(codeInfo:code), successClosure: { (result) -> Void in
            let json=JSON(result)
            print(json)
            let success=json["success"].stringValue
            if success == "success"{
                let entity=Mapper<ExpressmailEntity>().map(JSONObject:json["emInfo"].object)
                entity!.weight=json["elInfo"]["weight"].int
                entity!.amount=json["elInfo"]["amount"].int
                entity!.freight=json["elInfo"]["freight"].double
                entity!.storeToHeadquarters=json["elInfo"]["storeToHeadquarters"].int
                entity!.insuredMoney=json["elInfo"]["insuredMoney"].double
                entity!.payType=json["elInfo"]["payType"].int
                entity!.expressName=json["elInfo"]["expressName"].string
                entity!.expressNo=json["elInfo"]["expressNo"].string
                entity!.inputRemarks=json["elInfo"]["inputRemarks"].string
                entity!.packagePic=json["elInfo"]["packagePic"].string
                let statu=json["statu"].boolValue
                if statu {//此邮寄是否已经被处理过；true 是；false 否
                    let vc=MyNumberDetailsViewController()
                    vc.entity=entity
                    self.navigationController?.pushViewController(vc, animated:true)
                }else{
                    let vc=UpdateMyNumberDetailsViewController()
                    vc.entity=entity
                    self.navigationController?.pushViewController(vc, animated:true)
                }
            }else if success == "notExist"{
                self.showInfo("单号不存在")
            }else{
                self.showInfo("扫码失败")
            }
            SVProgressHUD.dismiss()
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    /**
     扫码接收站点包（站点）
     
     - parameter code:
     */
    func scanCodeGetStorepack(_ code:String,userId:Int,storeId:Int){
        
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetStorepack(codeInfo:code, userId: userId, storeId: storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success = json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"接收站点包成功")
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "error"{
                self.showInfo("二维码错误")
            }else if success == "haveNoRight"{
                self.showInfo("无权操作")
            }else if success == "haveNoRightReceived"{
                self.showInfo("此站点无权接收此站点包")
            }else if success == "received"{
                self.showInfo("此站点包已经被接收过了。不能再接收")
            }else if success == "notExist"{
                self.showInfo("站点包不存在")
            }else{
                self.showInfo("扫码失败")
            }
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    /**
     扫码接收快件（站点）
     */
    func scanCodeGetExpressmailstorag(_ code:String,userId:Int,storeId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetExpressmailstorag(codeInfo:code, userId: userId, storeId: storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success = json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"接收快件成功")
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "error"{
                self.showInfo("二维码错误")
            }else if success == "haveNoRight"{
                self.showInfo("无权操作")
            }else if success == "haveNoRightReceived"{
                self.showInfo("此站点无权接收此快件")
            }else if success == "received"{
                self.showInfo("此快件已经被接收过了。不能再接收")
            }else if success == "notExist"{
                self.showInfo("快件不存在")
            }else if success == "driverNotExist"{
                self.showInfo("不是司机送来的,不能接收。原因有可能是已经被代签收或者已经被会员本人签收")
            }else{
                self.showInfo("扫码失败")
            }
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    //扫码接收快件（司机）
    func scanCodeGetExpressmailForGivestoragByDriver(_ code:String,userId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetExpressmailForGivestoragByDriver(codeInfo:code, userId:userId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"接收快件成功")
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "haveNoRight"{
                self.showInfo("无权操作")
            }else if success == "exist"{
                self.showInfo("此快件已经被接收过")
            }else if success == "notGive"{
                self.showInfo("快递暂时未由站点录入，不能揽件")
            }else if success == "notExist"{
                self.showInfo("快件不存在")
            }else if success == "luruNotExist"{
                self.showInfo("录入信息不存在")
            }else{
                self.showInfo("扫码失败")
            }
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    //扫码接收快件（总仓）
    func scanCodeGetExpressmailForGivestoragByHeadquarters(_ codeInfo:String,userId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetExpressmailForGivestoragByHeadquarters(codeInfo: codeInfo, userId: userId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"接收快件成功")
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "error"{
                self.showInfo("二维码不匹配")
            }else if success == "haveNoRight"{
                self.showInfo("无权操作")
            }else if success == "exist"{
                self.showInfo("此快件已经被接收过")
            }else if success == "notGive"{
                self.showInfo("快递暂时未由司机录入，不能揽件")
            }else if success == "notExist"{
                self.showInfo("快件不存在")
            }else if success == "luruNotExist"{
                self.showInfo("录入信息不存在")
            }else{
                self.showInfo("扫码失败")
            }
            
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    //总仓接收退件快件
    func headquartersGetReturn(_ codeInfo:String,userId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.headquartersGetReturn(codeInfo:codeInfo, userId: userId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"接收返件成功,入库信息已删除，可以重新入库")
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "haveNoRight"{
                self.showInfo("无权操作")
            }else if success == "returnstorageNotExist"{
                self.showInfo("退件申请不存在")
            }else if success == "notExist"{
                self.showInfo("快件不存在")
            }else{
                self.showInfo("扫码失败")
            }
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    //司机接收退件的快件
    func driverGetReturn(_ codeInfo:String,userId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.driverGetReturn(codeInfo: codeInfo, userId: userId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"接收返件成功")
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "haveNoRight"{
                self.showInfo("无权操作")
            }else if success == "returnstorageNotExist"{
                self.showInfo("返件申请不存在")
            }else if success == "notExist"{
                self.showInfo("快件不存在")
            }else{
                self.showInfo("扫码失败")
            }
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    //扫码查询揽件信息
    func scanCodeGetExpressmailInfo(_ userId:Int,codeInfo:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetExpressmailInfo(userId:userId, codeInfo: codeInfo), successClosure: { (result) -> Void in
            let json=JSON(result)
            print(json)
            SVProgressHUD.dismiss()
            let entity=Mapper<ExpressmailEntity>().map(JSONObject:json.object)
            let vc=SweepCodeCourierDetailsViewController()
            vc.codeInfo=codeInfo
            vc.entity=entity
            self.navigationController?.pushViewController(vc, animated:true)
            
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    /**
     提示信息
     
     - parameter str:
     */
    func showInfo(_ str:String){
        SVProgressHUD.dismiss()
        UIAlertController.showAlertYes(self, title:"", message: str, okButtonTitle:"确定") { Void in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
