//
//  WXApiManager.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/15.
//  Copyright © 2018年 zltx. All rights reserved.
//
import UIKit
//微信appid
let WX_APPID="wx661bad8146962af5"
//AppSecret
let SECRET="5b4d214ee7ecb54148461beef5731b22"
//微信
class WXApiManager:NSObject,WXApiDelegate {
    static let shared = WXApiManager()
    // 用于弹出警报视图，显示成功或失败的信息
    private weak var sender:UIViewController! //(UIViewController)
    // 支付成功的闭包
    private var paySuccessClosure: (() -> Void)?
    // 支付失败的闭包
    private var payFailClosure: (() -> Void)?
    //登录成功
    private var loginSuccessClosure:((_ code:String) -> Void)?
    //登录失败
    private var loginFailClosure:(() -> Void)?
    // 外部用这个方法调起微信支付
    func payAlertController(_ sender:UIViewController,
                            request:PayReq,
                            paySuccess: @escaping () -> Void,
                            payFail:@escaping () -> Void) {
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.paySuccessClosure = paySuccess
        self.payFailClosure = payFail
        if checkWXInstallAndSupport(){//检查用户是否安装微信
            WXApi.send(request)
        }
    }
    //外部用这个方法调起微信登录
    func login(_ sender:UIViewController,loginSuccess: @escaping ( _ code:String) -> Void,
               loginFail:@escaping () -> Void){
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        if checkWXInstallAndSupport(){
            let req=SendAuthReq()
            req.scope="snsapi_userinfo"
            req.state="app"
            WXApi.send(req)
        }
    }

}
extension WXApiManager {
    func onResp(_ resp: BaseResp!) {
        if resp is PayResp {//支付
            if resp.errCode == 0 {
                self.paySuccessClosure?()
            }else{
                self.payFailClosure?()
            }
        }else if resp is SendAuthResp{//登录结果
            let authResp = resp as! SendAuthResp
            var strMsg: String
            if authResp.errCode == 0{
                strMsg="微信授权成功"
            }else{
                switch authResp.errCode{
                case -4:
                    strMsg="您拒绝使用微信登录"
                    break
                case -2:
                    strMsg="您取消了微信登录"
                    break
                default:
                    strMsg="微信登录失败"
                    break
                }
            }
            UIAlertController.showAlertYes(sender, title: "授权结果", message: strMsg, okButtonTitle:"确定", okHandler: { (alert) in
                if authResp.errCode == 0 {
                    self.loginSuccessClosure?(authResp.code)

                }else{
                    self.loginFailClosure?()
                }
            })
        }
    }
    //    //获取凭证
    //    private func getAccessToken(code:String){
    //        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(target:PayApi.accessToken(code:code), successClosure: { (json) in
    //            let errcode=json["errcode"].int
    //            if errcode == nil{//如果没有错误
    //                let access_token=json["access_token"].stringValue
    //                let openid=json["openid"].stringValue
    //                //获取用户信息
    //                self.getUserInfo(access_token:access_token,openid:openid)
    //            }else{
    //                self.payFailClosure?()
    //            }
    //        }, failClosure: { (error) in
    //            self.sender.showSVProgressHUD(status:error!,type:.error)
    //        })
    //    }
    //    //获取用户信息
    //    private func  getUserInfo(access_token:String,openid:String){
    //        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(target: PayApi.getUserinfo(access_token:access_token, openid: openid), successClosure: { (json) in
    //            let errcode=json["errcode"].int
    //            if errcode == nil{//如果没有错误
    //                self.paySuccessClosure?()
    //            }else{
    //                self.payFailClosure?()
    //            }
    //        }, failClosure: { (error) in
    //            self.sender.showSVProgressHUD(status:error!,type:.error)
    //        })
    //    }
}

extension WXApiManager {
    // 检查用户是否已经安装微信并且有支付功能
    fileprivate func checkWXInstallAndSupport() -> Bool {
        var bool=true
        if !WXApi.isWXAppInstalled() {
            UIAlertController.showAlertYes(sender,title:"", message: "微信未安装", okButtonTitle:"确定")
            bool=false
        }
        if !WXApi.isWXAppSupport() {
            UIAlertController.showAlertYes(sender,title:"", message: "当前微信版本不支持支付", okButtonTitle:"确定")
            bool=false
        }
        return bool
    }
}

