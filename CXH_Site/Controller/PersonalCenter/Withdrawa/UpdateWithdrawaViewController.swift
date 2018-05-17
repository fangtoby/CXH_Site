//
//  UpdateWithdrawaViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/13.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 添加更新行卡信息
class UpdateWithdrawaViewController:BaseViewController{
    //1更新 2添加
    var flag:Int?
    var entity:WithdrawaEntity?
    fileprivate var txtWithdrawaName:UITextField!
    fileprivate var txtWithdrawaBankCardNumber:UITextField!
    fileprivate var txtWithdrawaBankName:UITextField!
    fileprivate var txtWithdrawaBankBranch:UITextField!
    fileprivate var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.flag == 1{
            self.title="修改银行卡信息"
        }else{
            self.title="添加银行卡信息"
        }
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.separatorColor=UIColor.borderColor()
        table.tableFooterView=footerView()
        self.view.addSubview(table)
    }
    func footerView() -> UIView{
        let view=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 80))
        let borderView=UIView(frame:CGRect(x: 15,y: 0,width: boundsWidth,height: 0.5))
        borderView.backgroundColor=UIColor.borderColor()
        view.addSubview(borderView)
        let btnSubmit=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btnSubmit.frame=CGRect(x: 30,y: 20,width: boundsWidth-60,height: 40)
        btnSubmit.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        view.addSubview(btnSubmit)
        return view
    }
    /**
     提交
     */
    @objc func submit(){
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        let withdrawaBankBranch=txtWithdrawaBankBranch.text
        let withdrawaBankName=txtWithdrawaBankName.text
        let withdrawaBankCardNumber=txtWithdrawaBankCardNumber.text
        let withdrawaName=txtWithdrawaName.text
        if withdrawaBankBranch == nil || withdrawaBankBranch!.count == 0{
            self.showSVProgressHUD("开户支行不能为空", type: HUD.info)
            return
        }
        if withdrawaBankName == nil || withdrawaBankName!.count == 0{
            self.showSVProgressHUD("银行名称不能为空", type: HUD.info)
            return
        }
        if withdrawaBankCardNumber == nil || withdrawaBankCardNumber!.count == 0{
            self.showSVProgressHUD("银行卡号不能为空", type: HUD.info)
            return
        }
        if withdrawaName == nil || withdrawaName!.count == 0{
            self.showSVProgressHUD("真实姓名不能为空", type: HUD.info)
            return
        }
        let entity=WithdrawaEntity()
        entity.withdrawaName=withdrawaName
        entity.withdrawaBankName=withdrawaBankName
        entity.withdrawaBankCardNumber=withdrawaBankCardNumber
        entity.withdrawaBankBranch=withdrawaBankBranch
        let storeId=userDefaults.object(forKey: "storeId") as! Int
        if flag == 1{
            entity.withdrawaId=self.entity!.withdrawaId
            self.updateWithdrawa(entity, storeId: storeId)
        }else{
            self.addWithdrawa(entity, storeId: storeId)
        }
    }
    //点击view区域收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: - tbale协议
extension UpdateWithdrawaViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "upid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"upid")
        }
        cell!.selectionStyle = .none
        if indexPath.row == 0{
            txtWithdrawaName=buildTxt(15, placeholder:"请输入真实姓名", tintColor:UIColor.textColor(), keyboardType: UIKeyboardType.default)
            txtWithdrawaName.frame=CGRect(x: 15,y: 0,width: boundsWidth-15,height: 50)
            if entity?.withdrawaName != nil{
                txtWithdrawaName.text=entity?.withdrawaName
            }
            cell!.contentView.addSubview(txtWithdrawaName)
        }else if indexPath.row == 1{
            txtWithdrawaBankCardNumber=buildTxt(15, placeholder:"请输入银行卡号", tintColor:UIColor.textColor(), keyboardType: UIKeyboardType.default)
            txtWithdrawaBankCardNumber.frame=CGRect(x: 15,y: 0,width: boundsWidth-15,height: 50)
            if entity?.withdrawaBankCardNumber != nil{
                txtWithdrawaBankCardNumber.text=entity?.withdrawaBankCardNumber
            }
            cell!.contentView.addSubview(txtWithdrawaBankCardNumber)
        }else if indexPath.row == 2{
            txtWithdrawaBankName=buildTxt(15, placeholder:"请输入银行名称", tintColor:UIColor.textColor(), keyboardType: UIKeyboardType.default)
            txtWithdrawaBankName.frame=CGRect(x: 15,y: 0,width: boundsWidth-15,height: 50)
            if entity?.withdrawaBankName != nil{
                txtWithdrawaBankName.text=entity?.withdrawaBankName
            }
            cell!.contentView.addSubview(txtWithdrawaBankName)
        }else if indexPath.row == 3{
            txtWithdrawaBankBranch=buildTxt(15, placeholder:"请输入开户支行", tintColor:UIColor.textColor(), keyboardType: UIKeyboardType.default)
            txtWithdrawaBankBranch.frame=CGRect(x: 15,y: 0,width: boundsWidth-15,height: 50)
            if entity?.withdrawaBankBranch != nil{
                txtWithdrawaBankBranch.text=entity?.withdrawaBankBranch
            }
            cell!.contentView.addSubview(txtWithdrawaBankBranch)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
// MARK: - 网络请求
extension UpdateWithdrawaViewController{
    /**
     修改提现信息
     
     - parameter entity:
     - parameter storeId:
     */
    func updateWithdrawa(_ entity:WithdrawaEntity,storeId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updateWithdrawa(withdrawaId:entity.withdrawaId!, withdrawaName:entity.withdrawaName!, withdrawaBankCardNumber:entity.withdrawaBankCardNumber!, withdrawaStoreId:storeId, withdrawaBankName:entity.withdrawaBankName!, withdrawaBankBranch:entity.withdrawaBankBranch!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("修改成功",type: HUD.success)
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showSVProgressHUD("修改失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    /**
     添加提现信息
     
     - parameter entity:
     */
    func addWithdrawa(_ entity:WithdrawaEntity,storeId:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.addWithdrawa(withdrawaName:entity.withdrawaName!, withdrawaBankCardNumber:entity.withdrawaBankCardNumber!, withdrawaStoreId: storeId, withdrawaBankName:entity.withdrawaBankName!, withdrawaBankBranch:entity.withdrawaBankBranch!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("添加成功",type: HUD.success)
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showSVProgressHUD("添加失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
