//
//  BarCodeScanningViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
//定义闭包类型
typealias closureStr = (String) -> Void
/// 条形码扫描
class BarCodeScanningViewController:LBXScanViewController,LBXScanViewControllerDelegate{
    var strClosure:closureStr?
    // MARK: - init functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "条形码扫描"
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
            return
        }
        if scanResult.strScanned == nil{
            return
        }
        if scanResult.strBarCodeType! != "org.iso.QRCode"{//判断是否是二维码
            UIAlertController.showAlertYes(self, title:"", message: scanResult.strScanned!, okButtonTitle:"确定",okHandler: { Void in
                self.strClosure?(scanResult.strScanned!)
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}
