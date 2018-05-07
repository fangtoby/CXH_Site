//
//  WithdrawaManagementViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/12.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 提现
class WithdrawaManagementViewController:BaseViewController{
    //接收可提金额
    var money:String?
    fileprivate var table:UITableView!
    fileprivate var txtMoney:UITextField!
    fileprivate var btnSubmit:UIButton!
    fileprivate var lblTitle:UILabel!
    fileprivate var storeId=userDefaults.object(forKey: "storeId") as! Int
    fileprivate var arr=[WithdrawaEntity]()
    //提现时最低要保留的金额；也就是提现后还要剩下多少资金
    fileprivate var withdrawaRetainMoney:Double?
    //提现起始金额；也就是提现金额不能低于这么多
    fileprivate var withdrawaStartMoney:Double?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryWithdrawa(storeId)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="提现申请"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.tableFooterView=footerView()
        table.separatorColor=UIColor.borderColor()
        self.view.addSubview(table)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"提现记录", style: UIBarButtonItemStyle.done, target:self, action:#selector(pushWithdrawaRecordVC))
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        queryWithdrawa(storeId)
    }
    func footerView() -> UIView{
        let view=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 80))
        let borderView=UIView(frame:CGRect(x: 15,y: 0,width: boundsWidth,height: 0.5))
        borderView.backgroundColor=UIColor.borderColor()
        view.addSubview(borderView)
        lblTitle=UILabel(frame:CGRect(x: 15,y: 10,width: boundsWidth-15,height: 20))
        lblTitle.font=UIFont.systemFont(ofSize: 13)
        lblTitle.textColor=UIColor.red
        view.addSubview(lblTitle)
        btnSubmit=ButtonControl().button(ButtonType.cornerRadiusButton, text:"申请提现", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btnSubmit.frame=CGRect(x: 30,y: 40,width: boundsWidth-60,height: 40)
        btnSubmit.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        view.addSubview(btnSubmit)
        return view
    }
    /**
     跳转提现记录
     */
    @objc func pushWithdrawaRecordVC(){
        let vc=WithdrawaRecordViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
    @objc func submit(){
        self.showSVProgressHUD("正在加载", type: HUD.info)
        let withdrawaMoney=txtMoney.text
        if withdrawaMoney == nil || withdrawaMoney!.count == 0{
            self.showSVProgressHUD("提现金额不能为空", type: HUD.info)
            return
        }
        if arr.count == 0{
            self.showSVProgressHUD("请添加提现银行卡信息", type: HUD.info)
            return
        }
        let withdrawaId=arr[0].withdrawaId!
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.withdrawaTure(withdrawaId:withdrawaId, withdrawaMoney:Int(withdrawaMoney!)!, storeId: storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.dismissHUD()
                UIAlertController.showAlertYesNo(self, title:"城乡惠", message:"申请提现成功", cancelButtonTitle:"返回", okButtonTitle:"查看提现信息", okHandler: {  Void in
                    self.money=(Double(self.money!)!-Double(withdrawaMoney!)!).description
                    let vc=WithdrawaRecordViewController()
                    self.navigationController?.pushViewController(vc,animated:true)
                    }, cancelHandler: {
                        Void in
                        self.navigationController?.popViewController(animated: true)
                        
                })
            }else if success == "withdrawaStartMoney"{
                self.showSVProgressHUD("最低起提金额不足", type: HUD.info)
            }else if success == "capitalSumMoney"{
                self.showSVProgressHUD("余额不足", type: HUD.info)
            }else{
                self.showSVProgressHUD("申请提现失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.info)
        }
    }
}
extension WithdrawaManagementViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "txid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"txid")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
        if indexPath.row == 0{
            cell!.textLabel?.text="总金额"
            cell!.detailTextLabel!.text=money!+"元"
        }else if indexPath.row == 1{
            cell!.textLabel?.text="最低保留金额"
            if withdrawaRetainMoney != nil{
                cell!.detailTextLabel!.text="\(withdrawaRetainMoney!)元"
            }
        }else if indexPath.row == 2{
            cell!.textLabel?.text="可提金额"
            if withdrawaRetainMoney != nil{
                var ktMoney=Double(money!)!-withdrawaRetainMoney!
                if ktMoney <= 0{
                    ktMoney=0
                }
                cell!.detailTextLabel!.text="\(ktMoney)元"
            }
        }else if indexPath.row == 3{
            cell!.textLabel?.text="提现银行卡"
            if arr.count > 0{
                let entity=arr[0]
                cell!.detailTextLabel!.text=entity.withdrawaName!+" "+entity.withdrawaBankCardNumber!
            }else{
                cell!.detailTextLabel!.text="请添加银行卡"
            }
            cell!.accessoryType = .disclosureIndicator
        }else if indexPath.row == 4{
            cell!.textLabel?.text="提现金额"
            txtMoney=buildTxt(14, placeholder:"请输入提现金额", tintColor: UIColor.textColor(), keyboardType: UIKeyboardType.numberPad)
            txtMoney.textAlignment = .right
            txtMoney.frame=CGRect(x: 100,y: 0,width: boundsWidth-115,height: 50)
            cell!.contentView.addSubview(txtMoney)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.row == 3{
            if arr.count > 0{
                let vc=UpdateWithdrawaViewController()
                vc.flag=1
                vc.entity=arr[0]
                self.navigationController?.pushViewController(vc, animated:true)
            }else{
                let vc=UpdateWithdrawaViewController()
                vc.flag=2
                self.navigationController?.pushViewController(vc, animated:true)
            }
        }
    }
}
// MARK: - 网络请求
extension WithdrawaManagementViewController{
    /**
     查询提现银行卡
     
     - parameter storeId: 站点id
     */
    func queryWithdrawa(_ storeId:Int){
        
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryWithdrawa(storeId: storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print("json:\(json)")
            self.arr.removeAll()
            for(_,value) in json{
                let entity=self.jsonMappingEntity(WithdrawaEntity(), object:value.object)
                self.arr.append(entity!)
            }
            self.queryCxhSetInfo()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    func queryCxhSetInfo(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCxhSetInfo(), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            self.withdrawaRetainMoney=json["withdrawaRetainMoney"].doubleValue
            self.withdrawaStartMoney=json["withdrawaStartMoney"].doubleValue
            self.lblTitle.text="提现金额不能低于\(self.withdrawaStartMoney!)"
            self.table.reloadData()
            self.dismissHUD()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    //点击view区域收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
