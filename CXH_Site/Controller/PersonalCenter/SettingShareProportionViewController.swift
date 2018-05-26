//
//  SettingShareProportionViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/26.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
///设置分享费比例
class SettingShareProportionViewController:BaseViewController{
    private var txt:UITextField!
    private var btn:UIButton!
    private let storeId=userDefaults.object(forKey:"storeId") as! Int
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="设置分享费比例"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        let lblPrompt=buildLabel(UIColor.color666(), font:12, textAlignment: NSTextAlignment.left)
        lblPrompt.text="说明:设置分享费百分比,分享商品差价的百分比；比如零售价4块，批发价2块，用户将此商品分享他人购买一个，就相当于用户赚取了 2块 的百分之多少"
        lblPrompt.numberOfLines=0
        lblPrompt.lineBreakMode = .byWordWrapping
        lblPrompt.frame=CGRect.init(x:15, y:navHeight+20, width:boundsWidth-30, height:50)
        self.view.addSubview(lblPrompt)
        txt=buildTxt(14, placeholder:"请输入分享费比例(%)", tintColor:UIColor.color333(), keyboardType: UIKeyboardType.numberPad)
        txt.frame=CGRect.init(x:15, y:lblPrompt.frame.maxY+5, width:boundsWidth-30,height:40)
        txt.borderStyle = .roundedRect
        self.view.addSubview(txt)
        btn=UIButton.init(frame: CGRect.init(x:15, y:txt.frame.maxY+20, width:boundsWidth-30, height:40))
        btn.backgroundColor=UIColor.applicationMainColor()
        btn.layer.cornerRadius=5
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        btn.setTitle("提交", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.view.addSubview(btn)
        queryStoreInfo()
    }
    ///提交
    @objc private func submit(){
        let txtShareBili=txt.text
        if txtShareBili == nil || txtShareBili!.count == 0{
            self.showSVProgressHUD("分享费比例不能为空", type: HUD.info)
            return
        }
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.updateStoreInfo(storeId:storeId, shareBili:Int(txtShareBili!)!), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("修改成功", type: HUD.success)
            }else{
                self.showSVProgressHUD("修改失败", type: HUD.success)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///查询店铺信息
    private func queryStoreInfo(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStoreInfo(storeId:storeId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let entity=StoreEntity(JSONString:json.description)
            self.txt.text=entity?.shareBili?.description

        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
}
