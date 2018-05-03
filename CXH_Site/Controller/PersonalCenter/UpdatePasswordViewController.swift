//
//  UpdatePasswordViewController.swift
//  CXH
//
//  Created by hao peng on 2017/5/18.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 修改密码
class UpdatePasswordViewController:BaseViewController{
    //旧密码
    fileprivate var txtOldPwd:UITextField!
    //新密码
    fileprivate var txtNewPwd:UITextField!
    fileprivate var txtNewPwds:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="修改密码"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        txtOldPwd=UITextField(frame:CGRect(x: 40,y:navHeight+20,width: boundsWidth-80,height: 45))
        //设置密码输入框
        txtOldPwd.font=UIFont.systemFont(ofSize: 14)
        txtOldPwd.attributedPlaceholder=NSAttributedString(string:"请输入原密码", attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor("#999999")])
        txtOldPwd.adjustsFontSizeToFitWidth=true;
        txtOldPwd.tintColor=UIColor.applicationMainColor()
        txtOldPwd.isSecureTextEntry=true
        txtOldPwd.keyboardType=UIKeyboardType.default;
        txtOldPwd.layer.cornerRadius=45/2
        txtOldPwd.backgroundColor=UIColor.white
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtOldPwd.clearButtonMode=UITextFieldViewMode.whileEditing;
        //左视图
        let txtPasswordLeft=UIView(frame:CGRect(x:0,y:0,width:50,height:45))
        let txtPasswordLeftImg=UIImageView(frame:CGRect(x:20,y:12.5,width:20,height:20))
        txtPasswordLeftImg.image=UIImage(named: "login_password")
        txtPasswordLeft.addSubview(txtPasswordLeftImg)
        txtOldPwd.leftView=txtPasswordLeft
        txtOldPwd.leftViewMode=UITextFieldViewMode.always;
        self.view.addSubview(txtOldPwd)
        
        txtNewPwd=UITextField(frame:CGRect(x: 40,y: txtOldPwd.frame.maxY+15,width: boundsWidth-80,height: 45))
        //设置密码输入框
        txtNewPwd.font=UIFont.systemFont(ofSize: 14)
        txtNewPwd.attributedPlaceholder=NSAttributedString(string:"请输入新密码", attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor("#999999")])
        txtNewPwd.adjustsFontSizeToFitWidth=true;
        txtNewPwd.tintColor=UIColor.applicationMainColor()
        txtNewPwd.isSecureTextEntry=true
        txtNewPwd.keyboardType=UIKeyboardType.default;
        txtNewPwd.layer.cornerRadius=45/2
        txtNewPwd.backgroundColor=UIColor.white
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtNewPwd.clearButtonMode=UITextFieldViewMode.whileEditing;
        //左视图
        let txtNewPwdLeft=UIView(frame:CGRect(x:0,y:0,width:50,height:45))
        let txtNewPwdLeftImg=UIImageView(frame:CGRect(x:20,y:12.5,width:20,height:20))
        txtNewPwdLeftImg.image=UIImage(named: "login_password")
        txtNewPwdLeft.addSubview(txtNewPwdLeftImg)
        txtNewPwd.leftView=txtNewPwdLeft
        txtNewPwd.leftViewMode=UITextFieldViewMode.always;
        self.view.addSubview(txtNewPwd)
        
        txtNewPwds=UITextField(frame:CGRect(x: 40,y: txtNewPwd.frame.maxY+15,width: boundsWidth-80,height: 45))
        //设置密码输入框
        txtNewPwds.font=UIFont.systemFont(ofSize: 14)
        txtNewPwds.attributedPlaceholder=NSAttributedString(string:"请重复输入新密码", attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor("#999999")])
        txtNewPwds.adjustsFontSizeToFitWidth=true;
        txtNewPwds.tintColor=UIColor.applicationMainColor()
        txtNewPwds.isSecureTextEntry=true
        txtNewPwds.keyboardType=UIKeyboardType.default;
        txtNewPwds.layer.cornerRadius=45/2
        txtNewPwds.backgroundColor=UIColor.white
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtNewPwd.clearButtonMode=UITextFieldViewMode.whileEditing;
        //左视图
        let txtNewPwdsLeft=UIView(frame:CGRect(x:0,y:0,width:50,height:45))
        let txtNewPwdsLeftImg=UIImageView(frame:CGRect(x:20,y:12.5,width:20,height:20))
        txtNewPwdsLeftImg.image=UIImage(named: "login_password")
        txtNewPwdsLeft.addSubview(txtNewPwdsLeftImg)
        txtNewPwds.leftView=txtNewPwdsLeft
        txtNewPwds.leftViewMode=UITextFieldViewMode.always;
        self.view.addSubview(txtNewPwds)
        
        let btnSubmit=ButtonControl().button(ButtonType.cornerRadiusButton, text:"完成", textColor:UIColor.white, font:18, backgroundColor:UIColor.applicationMainColor(), cornerRadius:45/2)
        btnSubmit.frame=CGRect(x: 40,y: txtNewPwds.frame.maxY+20,width: boundsWidth-80,height: 45)
        btnSubmit.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnSubmit)

    }
    @objc func submit(){
        let newPwd=txtNewPwd.text
        let newPwds=txtNewPwds.text
        let oldPwd=txtOldPwd.text
        if oldPwd == nil || oldPwd!.count == 0{
            self.showSVProgressHUD("请输入原密码", type: HUD.info)
            return
        }
        if newPwd == nil || newPwd!.count == 0{
            self.showSVProgressHUD("新密码不能为空", type: HUD.info)
            return
        }
        if newPwd!.count < 6{
            self.showSVProgressHUD("新密码最少需要6位数", type: HUD.info)
            return
        }
        if newPwd != newPwds{
            self.showSVProgressHUD("两次输入的密码不一致", type: HUD.info)
            return
        }
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.savePwd(account: userDefaults.object(forKey: "userAccount") as! String, oldPwd: oldPwd!, newPwd: newPwd!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.dismissHUD()
                UIAlertController.showAlertYes(self, title:"城乡惠", message:"修改密码成功,请重新登录",okButtonTitle:"确定", okHandler: {  Void in
                    userDefaults.removeObject(forKey: "storeId")
                    userDefaults.removeObject(forKey: "userId")
                    userDefaults.synchronize();
                    //切换根视图
                    let app=UIApplication.shared.delegate as! AppDelegate
                    let vc=LoginViewController()
                    app.window?.rootViewController=UINavigationController(rootViewController:vc);
                })
            }else if success == "errorPwd"{
                self.showSVProgressHUD("账号或旧密码错误", type: HUD.error)
            }else{
                self.showSVProgressHUD("修改密码失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
        
    }
}
