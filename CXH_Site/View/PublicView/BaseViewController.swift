//
//  BaseViewController.swift
//  DDJDSupplier
//
//  Created by penghao on 16/11/28.
//  Copyright © 2016年 彭浩. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftyJSON
import ObjectMapper
import SnapKit


/// 基类
class BaseViewController:UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //页面将要消失的时候判断SVProgressHUD是否已经关闭 如果没有 关闭
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - SwiftyJSON
extension BaseViewController{
    /**
     解析JSON
     
     - parameter object:AnyObject
     
     - returns: JSON对象
     */
    func swiftJSON(_ object:Any) -> JSON{
        return JSON(object)
    }
}
// MARK: - ObjectMapper
extension BaseViewController{
    /**
     json映射entity(泛型)传入entity返回对应已经解析的entity
     
     - parameter object:AnyObject
     
     - returns:Mappable
     */
    func jsonMappingEntity<N:Mappable>(_ enitty:N,object:Any) -> N?{
        return Mapper<N>().map(JSONObject:object)
    }
}
// MARK: - 跳转页面
extension BaseViewController{
    /**
     用Storyboard构建页面需要StoryboardId找到页面
     
     - parameter storyboardId:
     
     - returns: 返回UIViewController
     */
    func storyboardPushView(_ storyboardId:String) -> UIViewController{
        //先拿到main文件
        let storyboard=UIStoryboard(name:"Main", bundle:nil);
        let vc=storyboard.instantiateViewController(withIdentifier: storyboardId) as UIViewController;
        return vc
    }
}
/**
 弹出对应的窗体
 
 - Error:   错误提示
 - Success: 成功提示
 - Info:    警告提示
 - Text:    文本提示
 - TextClear:文本提示(不允许用户交互)
 */
public enum HUD {
    case error
    case success
    case info
    case text
    case textClear
    case textGradient
}
// MARK: - SVProgressHUD
extension BaseViewController{
    /**
     弹出对应的提示视图
     
     - parameter status: 内容
     - parameter type:   弹出类型(HUD)
     */
    func showSVProgressHUD(_ status:String,type:HUD){
        switch type {
        case .error:
            return showError(status)
        case .success:
            return showSuccess(status)
        case .info:
            return showInfo(status)
        case .text:
            return showText(status)
        case .textClear:
            return showTextClear(status)
        case .textGradient:
            return showTextGradient(status)
        }
    }
    /**
     关闭弹出视图
     */
    func dismissHUD(){
        SVProgressHUD.dismiss()
    }
    /**
     弹出错误
     
     - parameter status: 内容
     */
    fileprivate func showError(_ status:String){
        SVProgressHUD.showError(withStatus: status)
        dismissTimeDelay()
    }
    /**
     弹出成功
     
     - parameter status: 内容
     */
    fileprivate func showSuccess(_ status:String){
        SVProgressHUD.showSuccess(withStatus: status)
        dismissTimeDelay()
    }
    /**
     弹出警告
     
     - parameter status: 内容
     */
    fileprivate func showInfo(_ status:String){
        SVProgressHUD.showInfo(withStatus: status)
        dismissTimeDelay()
    }
    /**
     弹出文字
     
     - parameter status: 内容
     */
    fileprivate func showText(_ status:String){
        SVProgressHUD.show(withStatus: status)
        dismissTimeDelay()
    }
    /**
     弹出文字(用户不可交互)
     
     - parameter status: 内容
     */
    fileprivate func showTextClear(_ status:String){
        SVProgressHUD.show(withStatus: status)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
    }
    /**
     弹出文字(用户不可交互)带背景
     
     - parameter status: 内容
     */
    fileprivate func showTextGradient(_ status:String){
        SVProgressHUD.show(withStatus: status)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
    }
    //延时2秒关闭
    private func dismissTimeDelay(){
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.dismiss(withDelay:2)
    }
}

