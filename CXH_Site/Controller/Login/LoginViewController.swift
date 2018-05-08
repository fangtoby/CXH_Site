//
//  LoginViewController.swift
//  CXH_Salesman
//
//  Created by hao peng on 2017/4/7.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit

/// 登录
class LoginViewController:BaseViewController{
    /// log图片
    fileprivate var logImg:UIImageView!
    
    /// log标题
    fileprivate var logName:UILabel!
    
    /// 版权所有
    fileprivate var lblCopyright:UILabel!
    
    /// 账号密码登录view
    fileprivate var loginView:UIView!
    
    /// 会员账号
    fileprivate var txtMemberName:UITextField!
    
    ///会员密码
    fileprivate var txtPassword:UITextField!
    
    /// 登录按钮
    fileprivate var btnLogin:UIButton!

    //是否同意用户协议
    fileprivate var isImg:UIButton!
    //用户协议文字按
    fileprivate var btnUserAgreement:UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //导航栏隐藏
        self.navigationController?.setNavigationBarHidden(true, animated:true)
        //设置状态栏颜色为默认颜色
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //设置状态栏颜色为白色
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        buildView()
    }
    //点击view区域收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - 页面布局
extension LoginViewController{
    /// 构建页面
    func buildView(){
        logImg=UIImageView()
        logImg.image=UIImage(named:"login_log")
        self.view.addSubview(logImg)
        
        logName=buildLabel(UIColor.applicationMainColor(), font:20, textAlignment: NSTextAlignment.center)
        logName.text="城乡惠站点"
        self.view.addSubview(logName)
        
        loginView=UIView()
        loginView.backgroundColor=UIColor.white
        loginView.layer.cornerRadius=10
        loginView.layer.borderWidth=0.5
        loginView.layer.borderColor=UIColor(red:221/255, green:222/255, blue: 223/255, alpha: 1).cgColor
        self.view.addSubview(loginView)
        
        let loginBorderView=UIView()
        loginBorderView.backgroundColor=UIColor(red:221/255, green:222/255, blue: 223/255, alpha: 1)
        loginView.addSubview(loginBorderView)
        
        txtMemberName=UITextField()
        txtMemberName.attributedPlaceholder=NSAttributedString(string:"账号/手机号码", attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor("#999999")])
        txtMemberName.adjustsFontSizeToFitWidth=true;
        let userAccount=userDefaults.object(forKey:"userAccount") as? String
        if userAccount != nil{
            txtMemberName.text=userAccount
        }
        txtMemberName.tintColor=UIColor.RGBFromHexColor("#999999")
        txtMemberName.keyboardType=UIKeyboardType.default
        txtMemberName.font=UIFont.systemFont(ofSize: 14)
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtMemberName.clearButtonMode=UITextFieldViewMode.whileEditing
        //左视图
        let txtNameLeft=UIView(frame: CGRect(x:0, y:0, width:40, height:40))
        let txtNameLeftImg=UIImageView(frame:CGRect(x:10,y:7.5,width:25,height:25))
        txtNameLeftImg.image=UIImage(named: "login_memberName")
        txtNameLeft.addSubview(txtNameLeftImg)
        txtMemberName.leftView=txtNameLeft
        txtMemberName.leftViewMode=UITextFieldViewMode.always;
        loginView.addSubview(txtMemberName)
        
        txtPassword=UITextField()
        //设置密码输入框
        txtPassword.font=UIFont.systemFont(ofSize: 14)
        txtPassword.attributedPlaceholder=NSAttributedString(string:"请输入密码", attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor("#999999")])
        txtPassword.adjustsFontSizeToFitWidth=true;
        txtPassword.tintColor=UIColor.RGBFromHexColor("#999999")
        txtPassword.isSecureTextEntry=true
        txtPassword.keyboardType=UIKeyboardType.default;
        txtPassword.delegate=self
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtPassword!.clearButtonMode=UITextFieldViewMode.whileEditing;
        //左视图
        let txtPasswordLeft=UIView(frame:CGRect(x:0,y:0,width:40,height:40))
        let txtPasswordLeftImg=UIImageView(frame:CGRect(x:10,y:7.5,width:25,height:25))
        txtPasswordLeftImg.image=UIImage(named: "login_password")
        txtPasswordLeft.addSubview(txtPasswordLeftImg)
        txtPassword.leftView=txtPasswordLeft
        txtPassword.leftViewMode=UITextFieldViewMode.always;
        txtPassword.addTarget(self, action:#selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        loginView.addSubview(txtPassword)
        
        btnLogin=ButtonControl().button(ButtonType.cornerRadiusButton, text:"登录", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:10)
        btnLogin.disable()
        btnLogin.addTarget(self, action:#selector(loginSubmit), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnLogin)

        isImg=UIButton()
        isImg.setBackgroundImage(UIImage(named:"register_selected"), for: UIControlState.selected)
        isImg.isSelected=true
        isImg.setBackgroundImage(UIImage(named:"register_select"), for: UIControlState.normal)
        isImg.addTarget(self, action:#selector(isSelectedUserAgreement), for: UIControlEvents.touchUpInside)
        self.view.addSubview(isImg)

        btnUserAgreement=UIButton()
        btnUserAgreement.setTitleColor(UIColor.color999(), for: UIControlState.normal)
        btnUserAgreement.setTitle("登录即代表您已经同意", for: UIControlState.normal)
        btnUserAgreement.titleLabel!.font=UIFont.systemFont(ofSize: 14)
        btnUserAgreement.addTarget(self, action:#selector(isSelectedUserAgreement), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnUserAgreement)

        let btnQualityAssuranceAgreement=UIButton()
        btnQualityAssuranceAgreement.setTitle("《质量保证协议》", for: UIControlState.normal)
        btnQualityAssuranceAgreement.titleLabel!.font=UIFont.systemFont(ofSize: 14)
        btnQualityAssuranceAgreement.setTitleColor(UIColor.applicationMainColor(), for: UIControlState.normal)
        self.view.addSubview(btnQualityAssuranceAgreement)
        
        lblCopyright=buildLabel(UIColor.applicationMainColor(), font:13, textAlignment: NSTextAlignment.center)
        lblCopyright.text=""
        self.view.addSubview(lblCopyright)


        logImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.top.equalTo(100)
            make.left.equalTo((boundsWidth-100)/2)
        }
        logName.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth)
            make.left.equalTo(0)
            make.top.equalTo(logImg.snp.bottom).offset(10)
        }
        loginView.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth-80)
            make.height.equalTo(80.5)
            make.left.equalTo(40)
            make.top.equalTo(logName.snp.bottom).offset(30)
            
        }
        txtMemberName.snp.makeConstraints { (make) in
            make.width.equalTo(loginView.snp.width)
            make.left.top.equalTo(0)
            make.height.equalTo(40)
        }
        txtPassword.snp.makeConstraints { (make) in
            make.width.equalTo(loginView.snp.width)
            make.left.equalTo(0)
            make.top.equalTo(40.5)
            make.height.equalTo(40)
        }
        loginBorderView.snp.makeConstraints { (make) in
            make.width.equalTo(loginView.snp.width)
            make.height.equalTo(0.5)
            make.left.equalTo(0)
            make.top.equalTo(40)
        }
        isImg.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(25)
            make.left.equalTo(loginView.snp.left)
            make.top.equalTo(loginView.snp.bottom).offset(15)
        }
        btnUserAgreement.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(143)
            make.left.equalTo(isImg.snp.right).offset(5)
            make.top.equalTo(isImg.snp.top)
            make.height.equalTo(25)
        }
        btnQualityAssuranceAgreement.snp.makeConstraints { (make) in
            make.width.equalTo(115)
            make.left.equalTo(btnUserAgreement.snp.right)
            make.top.equalTo(isImg.snp.top)
            make.height.equalTo(25)
        }
        btnLogin.snp.makeConstraints { (make) in
            make.width.equalTo(loginView.snp.width)
            make.height.equalTo(40)
            make.top.equalTo(isImg.snp.bottom).offset(10)
            make.left.equalTo(loginView.snp.left)
        }
        lblCopyright.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth)
            make.height.equalTo(20)
            make.left.equalTo(0)
            make.top.equalTo(boundsHeight-40)
        }
    }
}


extension LoginViewController{
    ///选择用户协议
    @objc private func isSelectedUserAgreement(sender:UIButton){
        if isImg.isSelected{
            isImg.isSelected=false
        }else{
            isImg.isSelected=true
        }
    }
    
    /// 登录
    ///
    /// - Parameter seder:
    @objc func loginSubmit(_ seder:UIButton){
        let memberName=txtMemberName.text
        let password=txtPassword.text
        if memberName == nil || memberName?.count == 0{
            showSVProgressHUD("用户名不能为空", type: HUD.info)
            return
        }
        if password == nil || password?.count == 0{
            showSVProgressHUD("密码不能为空", type: HUD.info)
            return
        }
        if isImg.isSelected == false{
            showSVProgressHUD("请同意质量保证协议", type: HUD.info)
            return
        }
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.adminUserLogin(userAccount: memberName!, userPossword: password!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                print(json)
                let entity=self.jsonMappingEntity(MemberEntity(), object:json["userInfo"].object)
                userDefaults.set(entity!.storeId, forKey:"storeId")
                userDefaults.set(entity!.userId, forKey:"userId")
                userDefaults.set(entity!.userAccount, forKey:"userAccount")
                userDefaults.set(entity!.userName, forKey:"userName")
                userDefaults.set(entity!.identity, forKey:"identity")
                userDefaults.set(entity!.testStoreId, forKey:"testStoreId")
                userDefaults.synchronize()
                if entity!.storeId != nil{
                    JPUSHService.setTags(["\(entity!.storeId!)"], completion: nil, seq: 11)

                }else{
                    if entity!.userId != nil{
                    JPUSHService.setAlias("\(entity!.userId!)", completion: nil, seq: 22)
                    
                    }
                }
                let vc=UINavigationController(rootViewController:IndexViewController())
                let app=UIApplication.shared.delegate as! AppDelegate
                app.window?.rootViewController=vc
                self.dismissHUD()
            }else if success == "notExist"{
                self.showSVProgressHUD("账号密码不正确", type: HUD.info)
            }else if success == "deleteTrue"{
                self.showSVProgressHUD("账号已删除", type: HUD.info)
            }else{
                self.showSVProgressHUD("服务器异常", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
// MARK: - 实现协议
extension LoginViewController:UITextFieldDelegate{
    //监听密码框输入
    @objc func textFieldDidChange(_ textField:UITextField){
        if textField.text != nil && textField.text != ""{
            btnLogin.enable()
        }else{
            btnLogin.disable()
        }
    }
}
