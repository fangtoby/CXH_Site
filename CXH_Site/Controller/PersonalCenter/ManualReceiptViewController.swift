//
//  ManualReceiptViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/7/21.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 手动收件
class ManualReceiptViewController:BaseViewController {
    //3表示司机  2表示站点
    var flag:Int?
    fileprivate var txtName:UITextField!
    fileprivate var userId=userDefaults.object(forKey: "userId") as! Int
    fileprivate var storeId=userDefaults.object(forKey: "storeId") as? Int
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        let txtNameView=UIView(frame:CGRect(x: 30,y:navHeight+26,width: boundsWidth-60,height: 40))
        txtNameView.layer.cornerRadius=20
        txtNameView.backgroundColor=UIColor.white
        self.view.addSubview(txtNameView)
        if flag == 2{
            self.title="手动收件"
            txtName=buildTxt(13, placeholder:"请输入识别码/快件单号", tintColor: UIColor.black, keyboardType: UIKeyboardType.default)
            txtName.frame=CGRect(x: 20,y: 0,width: txtNameView.frame.width-40,height: 40)
            txtName.layer.cornerRadius=20
            txtName.text="sp"
            txtName.adjustsFontSizeToFitWidth=true;
            txtName.backgroundColor=UIColor.white
            txtNameView.addSubview(txtName)
            let title=buildLabel(UIColor.applicationMainColor(), font:12, textAlignment: NSTextAlignment.left)
            title.frame=CGRect(x: 30,y:txtNameView.frame.maxY+10,width: boundsWidth-60,height: 20)
            title.text="注意:请输入站点包/快件包识别码进行收件"
            self.view.addSubview(title)
            let btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认收件", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
            btn.frame=CGRect(x: 30,y:title.frame.maxY+20,width: boundsWidth-60,height: 40)
            btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
            self.view.addSubview(btn)
        }else if flag == 3{
            self.title="手动揽件"
            txtName=buildTxt(13, placeholder:"请输入揽件单号", tintColor: UIColor.black, keyboardType: UIKeyboardType.default)
            txtName.frame=CGRect(x: 20,y: 0,width: txtNameView.frame.width-40,height: 40)
            txtName.layer.cornerRadius=20
            txtName.text="em"
            txtName.adjustsFontSizeToFitWidth=true;
            txtName.backgroundColor=UIColor.white
            txtNameView.addSubview(txtName)
            let title=buildLabel(UIColor.applicationMainColor(), font:12, textAlignment: NSTextAlignment.left)
            title.frame=CGRect(x: 30,y:76+navHeight,width: boundsWidth-60,height: 20)
            title.text="注意:只能输入揽件单号"
            self.view.addSubview(title)
            let btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认揽件", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
            btn.frame=CGRect(x: 30,y: 180,width: boundsWidth-60,height: 40)
            btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
            self.view.addSubview(btn)
        }
        
        
    }
    @objc func submit(){
        if txtName.text == nil || txtName.text! == ""{
            self.showSVProgressHUD("单号不能为空",type:HUD.info)
            return
        }
        self.showSVProgressHUD("正在加载...", type:HUD.textClear)
        if txtName.text!.count > 2{
            if flag == 2 {//站点手动收件
                let index = txtName.text!.index(txtName.text!.startIndex, offsetBy:2)
                let code=txtName.text![..<index]
                if code == "sp"{
                    scanCodeGetStorepack(txtName.text!, userId:userId, storeId: storeId ?? -1)
                }else if code == "ms"{
                    scanCodeGetExpressmailstorag(txtName.text!,userId:userId,storeId: storeId ?? -1)
                }else if code == "em"{
                    self.showSVProgressHUD("亲,这是邮寄快递", type: HUD.info)
                }else if code == "lp"{
                    self.showSVProgressHUD("亲,这是物流包", type: HUD.info)
                }else{
                    self.codeInfoQueryMain(txtName.text!)
                }
            }else if flag == 3{//司机手动揽件
                getExpressmailForGivestoragByDriver(txtName.text!, userId:userId)
            }
        }else{
            self.showSVProgressHUD("请输入正确的识别码", type: HUD.info)
        }
    }
    /**
     根据条码查询是揽件还是收件
     
     - parameter codeInfo: 条形码
     */
    func codeInfoQueryMain(_ codeInfo:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.codeInfoQueryMain(codeInfo:codeInfo), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let qrcode=json["qrcode"].stringValue
            let index = qrcode.index(qrcode.startIndex,offsetBy:2)
            let code=qrcode[..<index]
            if code == "sp"{
                self.scanCodeGetStorepack(qrcode, userId:self.userId, storeId: self.storeId ?? -1)
            }else if code == "ms"{
                self.scanCodeGetExpressmailstorag(qrcode,userId:self.userId,storeId: self.storeId ?? -1)
            }else if code == "em"{
                self.showSVProgressHUD("亲,这是邮寄快递", type: HUD.info)
            }else if code == "lp"{
                self.showSVProgressHUD("亲,这是物流包", type: HUD.info)
            }else{
                self.showSVProgressHUD("请输入正确的识别码", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    func scanCodeGetExpressmailstorag(_ code:String,userId:Int,storeId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetExpressmailstorag(codeInfo:code, userId: userId, storeId: storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success = json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("接收快件成功", type: HUD.success)
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "error"{
                self.showSVProgressHUD("二维码错误", type: HUD.info)
            }else if success == "haveNoRight"{
                self.showSVProgressHUD("无权操作", type: HUD.info)
            }else if success == "haveNoRightReceived"{
                self.showSVProgressHUD("此站点无权接收此快件", type: HUD.info)
            }else if success == "received"{
                self.showSVProgressHUD("此快件已经被接收过了。不能再接收", type: HUD.info)
            }else if success == "notExist"{
                self.showSVProgressHUD("快件不存在", type: HUD.info)
            }else if success == "driverNotExist"{
                self.showSVProgressHUD("不是司机送来的,不能接收。原因有可能是已经被代签收或者已经被会员本人签收", type: HUD.info)
            }else{
                self.showSVProgressHUD("收件失败", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!,type: HUD.error)
        }
    }

    /**
     扫码接收站点包（站点）
     
     - parameter code:
     */
    func scanCodeGetStorepack(_ code:String,userId:Int,storeId:Int){
        
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetStorepack(codeInfo:code, userId: userId, storeId: storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success = json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("接收站点包成功", type: HUD.success)
            }else if success == "error"{
                self.showSVProgressHUD("二维码错误", type: HUD.info)
            }else if success == "haveNoRight"{
                self.showSVProgressHUD("无权操作", type: HUD.info)
            }else if success == "haveNoRightReceived"{
                self.showSVProgressHUD("此站点无权接收此站点包", type: HUD.info)
            }else if success == "received"{
                self.showSVProgressHUD("此站点包已经被接收过了。不能再接收", type: HUD.info)
            }else if success == "notExist"{
                self.showSVProgressHUD("站点包不存在", type: HUD.info)
            }else{
                self.showSVProgressHUD("接收站点包失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!,type: .error)
        }
    }
    /**
     手动揽件
     */
    func getExpressmailForGivestoragByDriver(_ code:String,userId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.getExpressmailForGivestoragByDriver(codeInfo:code, userId: userId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("揽件成功", type: HUD.success)
            }else if success == "error"{
                self.showSVProgressHUD("邮寄单号不存在", type: HUD.info)
            }else if success == "notGive"{
                self.showSVProgressHUD("该揽件暂未录入或已被接收", type: HUD.info)
            }else if success == "notExist"{
                self.showSVProgressHUD("快件不存在", type: HUD.info)
            }else if success == "luruNotExist"{
                self.showSVProgressHUD("邮寄录入信息不存在", type: HUD.info)
            }else if success == "exist"{
                self.showSVProgressHUD("此快件已经被接收过", type: HUD.info)
            }else if success == "haveNoRight"{
                self.showSVProgressHUD("无权操作", type: HUD.info)
            }else{
                self.showSVProgressHUD("揽件失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    //点击view区域收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
