//
//  CKSweepCodeReceiptViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/22.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftyJSON
import ObjectMapper
import SVProgressHUD
//import <#module#>
/// 扫码收件
class CKSweepCodeReceiptViewController:LBXScanViewController,LBXScanViewControllerDelegate{
    //    1，站点包的二维码：名称以 ‘sp’ 开头+站点包ID，内容以 ‘sp-’开头+其他内容；
    //    2，物流包的二维码：名称以 ‘lp’ 开头+物流包的ID，内容以 ‘lp-’开头+其他内容；
    //    3，快递入库的二维码：名称以 ‘ms’ 开头+入库表的ID，内容以 ‘ms-’开头+其他内容；
    //    4，寄件的二维码：名称为系统单号（”em”+时间戳），内容为单号+id；
    fileprivate var codeFlag:String?
    fileprivate let identity=userDefaults.object(forKey: "identity") as! Int
    fileprivate let userId=userDefaults.object(forKey: "userId") as! Int
    // MARK: - init functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫码代签收"
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
            scanCodeQueryExpressmailstorag(scanResult.strScanned!)
        }else{
            codeInfoQueryMain(scanResult.strScanned!)
        }
    }
}
// MARK: - 网络请求
extension CKSweepCodeReceiptViewController{
    func scanCodeQueryExpressmailstorag(_ codeInfo:String){
        SVProgressHUD.show(withStatus:"正在加载...")
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeQueryExpressmailstorag(userId:userId, codeInfo:codeInfo), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].string
            if success != nil{
                if success == "notExist"{
                    self.showInfo("快件不存在")
                }else if success == "haveNoRight"{
                    self.showInfo("无权操作")
                }else{
                    self.showInfo("扫码失败")
                }
            }else{
                SVProgressHUD.dismiss()
                let entity=Mapper<ExpressmailStorageEntity>().map(JSONObject:json.object )
                let vc=SweepCodeInboxDetailsViewController()
                vc.entity=entity
                self.navigationController?.pushViewController(vc,animated:true)
                
            }
            
            }) { (errorMsg) -> Void in
                self.showInfo(errorMsg!)
        }
    }
    /**
     根据条码查询是揽件还是收件
     
     - parameter codeInfo: 条形码
     */
    func codeInfoQueryMain(_ codeInfo:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.codeInfoQueryMain(codeInfo:codeInfo), successClosure: { (result) -> Void in
            let json=JSON(result)
            //            let flag=json["flag"].intValue
            let qrcode=json["qrcode"].stringValue
            self.scanCodeQueryExpressmailstorag(qrcode)
            }) { (errorMsg) -> Void in
              
                
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

