//
//  QrcodeViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
///二维码
class QrcodeViewController:BaseViewController{
    //1收件 2揽件
    var flag:Int?
    var expressmailStorageEntity:ExpressmailStorageEntity?
    var expressEntity:ExpressmailEntity?
    fileprivate var qrcodeImageView:UIImageView!
    fileprivate var maskView:UIView!
    fileprivate var qrcodeView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="二维码"
        self.view.backgroundColor=UIColor(red:45/255, green:29/255, blue:50/255, alpha: 1)
        maskView=UIView(frame:self.view.bounds)
        maskView.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5)
        self.view.addSubview(maskView)
        qrcodeView=UIView(frame:CGRect(x: 0,y: 0,width: 260,height: 260))
        qrcodeView.layer.cornerRadius=3
        qrcodeView.backgroundColor=UIColor.white
        qrcodeView.center=maskView.center
        maskView.addSubview(qrcodeView)
        qrcodeImageView=UIImageView(frame:CGRect(x: 10,y: 10,width: 240,height: 240))
        if flag == 1{
            qrcodeImageView.sd_setImage(with: Foundation.URL(string:URLIMG+expressmailStorageEntity!.expressmailStorageQrcode!), placeholderImage:UIImage(named: "default_icon"))
        }else{
            qrcodeImageView.sd_setImage(with: Foundation.URL(string:URLIMG+expressEntity!.qrcode!), placeholderImage:UIImage(named: "default_icon"))
                let identity=userDefaults.object(forKey: "identity") as! Int
                if identity == 2{//如果是站点待揽件打印二维码信息
                    if expressEntity!.status == 2{
                        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"打印二维码", style: UIBarButtonItemStyle.done, target:self, action:#selector(connectThePrinter))
                    }
                }
        }
        qrcodeView.addSubview(qrcodeImageView)
        
    }
    /**
     连接打印机
     */
    @objc func connectThePrinter(){
        let vc=ConnectThePrinterViewController()
        let entity=PrinterEntity()
        entity.code=expressEntity!.qrcodeContent
        entity.weight="\(expressEntity!.weight!)"
        entity.time=expressEntity!.ctime
        entity.freight="\(expressEntity!.freight!)"
        entity.storeName=userDefaults.object(forKey: "userName") as? String
        vc.entity=entity
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
