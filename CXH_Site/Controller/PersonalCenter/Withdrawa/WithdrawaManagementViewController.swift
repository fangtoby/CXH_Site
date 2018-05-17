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
    private var segmentedControl:UISegmentedControl!
    fileprivate var table:UITableView!
    fileprivate var txtMoney:UITextField?
    fileprivate var btnSubmit:UIButton!
    fileprivate var lblTitle:UILabel!
    fileprivate var storeId=userDefaults.object(forKey: "storeId") as! Int
    ///是否绑定微信  true是
    private var wxBingStatu=false
    ///微信昵称
    private var wx_nickname:String?
    ///是否绑定支付宝  true是
    private var aliBingStatu=false
    ///支付宝昵称
    private var alipayNickName:String?
    fileprivate var arr=[WithdrawaEntity]()
    //提现时最低要保留的金额；也就是提现后还要剩下多少资金
    fileprivate var withdrawaRetainMoney:Double?
    //提现起始金额；也就是提现金额不能低于这么多
    fileprivate var withdrawaStartMoney:Double?
    ///‘提现后的到账周期； T+几’,
    private var withdrawNumberDays=1
    ///1’ COMMENT ‘提现方式；1，提现后直接到账； 2，以 withdrawNumberDays 这个字段规定的天数进行提现到账’,
    private var withdrawCycle=2
    ///提现方式  1银行卡提现(不收手续费) 2微信  3支付宝
    private var type:Int=1
    ///微信提现手续费
    private var cashRateByWx:Float=0
    ///支付宝提现手续费
    private var cashRateByAli:Float=0
    ///银行卡提现手续费
    private var cashRateByBankCard:Float=0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///默认查询银行卡信息
        queryWithdrawa(storeId)
        ///查询提现信息
        queryCxhSetInfo()
        ///查询微信支付宝信息
        queryStoreBindWxOrAliStatu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="提现申请"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        money=money ?? "0"
        table=UITableView(frame:self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.estimatedRowHeight=0;
        table.estimatedSectionHeaderHeight=0;
        table.estimatedSectionFooterHeight=0;
        table.tableFooterView=footerView()
        table.tableHeaderView=headerView()
        self.view.addSubview(table)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"提现记录", style: UIBarButtonItemStyle.done, target:self, action:#selector(pushWithdrawaRecordVC))
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
    }
}
///设置页面
extension WithdrawaManagementViewController{
    private func headerView() -> UIView{
        let view=UIView.init(frame: CGRect.init(x:0, y:0, width:boundsWidth, height:70))
        segmentedControl=UISegmentedControl(items:["银行卡提现","微信提现","支付宝提现"])
        segmentedControl.frame=CGRect.init(x:15,y:15, width:boundsWidth-30, height:40)
        segmentedControl.tintColor=UIColor.applicationMainColor()
        segmentedControl.selectedSegmentIndex=0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for:   UIControlEvents.valueChanged)
        view.addSubview(segmentedControl)
        return view
    }
    private func footerView() -> UIView{
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
    //选择点击后的事件
    @objc func segmentedControlChanged(sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            type=1
        }else if sender.selectedSegmentIndex == 1{
            type=2
        }else{
            type=3
        }
        self.table.reloadData()
    }
}
///页面逻辑
extension WithdrawaManagementViewController{
    /**
     跳转提现记录
     */
    @objc func pushWithdrawaRecordVC(){
        let vc=WithdrawaRecordViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
    @objc func submit(){
        let withdrawaMoney=txtMoney?.text
        var withdrawaId:Int?
        if withdrawaMoney == nil || withdrawaMoney!.count == 0{
            self.showSVProgressHUD("提现金额不能为空", type: HUD.info)
            return
        }
        if type == 1{
            if arr.count == 0{
                self.showSVProgressHUD("请添加提现银行卡信息", type: HUD.info)
                return
            }
            withdrawaId=arr[0].withdrawaId
        }else if type == 2{
            if !wxBingStatu{
                self.showSVProgressHUD("请绑定微信", type: HUD.info)
                return
            }
        }else if type == 3{
            if !aliBingStatu{
                self.showSVProgressHUD("请绑定支付宝", type: HUD.info)
                return
            }
        }
        self.showSVProgressHUD("正在加载", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.withdrawaTure(withdrawaId:withdrawaId, withdrawaMoney:Int(withdrawaMoney!)!, storeId: storeId, withdrawaType:type), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.dismissHUD()
                UIAlertController.showAlertYesNo(self, title:"城乡惠", message:"申请提现成功", cancelButtonTitle:"返回", okButtonTitle:"查看提现信息", okHandler: {  Void in
                    let vc=UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier:"WithdrawalSuccessVC") as! WithdrawalSuccessViewController
                    vc.money=withdrawaMoney
                    vc.withdrawType=self.type
                    vc.withdrawNumberDays=self.withdrawNumberDays
                    vc.withdrawCycle=self.withdrawCycle
                    if self.type == 1{
                        vc.withdrawAccount=(self.arr[0].withdrawaBankName ?? "")+(self.arr[0].withdrawaBankCardNumber ?? "")
                        vc.cashRateByMoney=self.cashRateByBankCard==0 ? "0": PriceComputationsUtil.decimalNumberWithString(multiplierValue:withdrawaMoney!, multiplicandValue:(self.cashRateByBankCard/1000).description, type:ComputationsType.multiplication, position: 2)
                    }else if self.type == 2{
                        vc.withdrawAccount=self.wx_nickname
                        vc.cashRateByMoney=self.cashRateByWx==0 ? "0": PriceComputationsUtil.decimalNumberWithString(multiplierValue:withdrawaMoney!, multiplicandValue:(self.cashRateByWx/1000).description, type: ComputationsType.multiplication, position: 2)
                    }else if self.type == 3{
                        vc.withdrawAccount=self.alipayNickName
                        vc.cashRateByMoney=self.cashRateByAli==0 ? "0": PriceComputationsUtil.decimalNumberWithString(multiplierValue:withdrawaMoney!, multiplicandValue:(self.cashRateByAli/1000).description, type: ComputationsType.multiplication, position: 2)
                    }

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
            cell!.textLabel?.text="提现手续费"
            if type == 1{
                cell!.detailTextLabel?.text="\(cashRateByBankCard/10)%"
            }else if type == 2{
                cell!.detailTextLabel?.text="\(cashRateByWx/10)%"
            }else if type == 3{
                cell!.detailTextLabel?.text="\(cashRateByAli/10)%"
            }
        }else if indexPath.row == 4{
            if type == 1{
                cell!.textLabel?.text="银行卡"
                if arr.count > 0{
                    let entity=arr[0]
                    if entity.withdrawaName != nil && entity.withdrawaBankCardNumber != nil{
                        cell!.detailTextLabel!.text=entity.withdrawaName!+" "+entity.withdrawaBankCardNumber!
                    }
                }else{
                    cell!.detailTextLabel!.text="请添加银行卡"
                }
            }else if type == 2{
                cell!.textLabel?.text="微信"
                if wxBingStatu{
                    if self.wx_nickname != nil{
                        cell!.detailTextLabel?.text=self.wx_nickname
                    }else{
                        cell!.detailTextLabel!.text="已绑定"
                    }
                }else{
                    cell!.detailTextLabel!.text="请绑定微信"
                }
            }else if type == 3{
                cell!.textLabel?.text="支付宝"
                if aliBingStatu{
                    if self.alipayNickName != nil{
                        cell!.detailTextLabel?.text=self.alipayNickName
                    }else{
                        cell!.detailTextLabel!.text="已绑定"
                    }
                }else{
                    cell!.detailTextLabel!.text="请绑定支付宝"
                }

            }
            cell!.accessoryType = .disclosureIndicator
        }else if indexPath.row == 5{
            cell!.textLabel?.text="提现金额"
            txtMoney=cell!.contentView.viewWithTag(100) as? UITextField
            if txtMoney == nil{
                txtMoney=buildTxt(14, placeholder:"请输入提现金额", tintColor: UIColor.textColor(), keyboardType: UIKeyboardType.numberPad)
                txtMoney?.textAlignment = .right
                txtMoney?.tag=100
                txtMoney?.frame=CGRect(x: 100,y: 0,width: boundsWidth-115,height: 50)
                cell!.contentView.addSubview(txtMoney!)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.row == 4{
            if type == 1{//银行卡
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
            }else{
                let vc=BindWxAndAliViewController()
                vc.wxBindStatu=wxBingStatu
                vc.aliBindStatu=aliBingStatu
                vc.alipayNickName=alipayNickName
                vc.wx_nickname=wx_nickname
                self.navigationController?.pushViewController(vc, animated: true)
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
            self.table.reloadRows(at:[IndexPath.init(row:4, section:0)], with: UITableViewRowAnimation.none)
            self.dismissHUD()
        }) { (errorMsg) -> Void in
            self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    ///查询微信支付宝信息
    func queryStoreBindWxOrAliStatu(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStoreBindWxOrAliStatu(storeId:storeId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            self.wxBingStatu=json["wxBindStatu"].boolValue
            self.aliBingStatu=json["aliBindStatu"].boolValue
            if self.aliBingStatu{
                self.alipayNickName=json["alipayforstoreInfo"]["alipayNickName"].string
            }
            if self.wxBingStatu{
                self.wx_nickname=json["wxforstoreInfo"]["wx_nickname"].string
            }
            self.table.reloadRows(at:[IndexPath.init(row:4, section:0)], with: UITableViewRowAnimation.none)
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///查询提现信息
    func queryCxhSetInfo(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCxhSetInfo(), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            self.withdrawaRetainMoney=json["withdrawaRetainMoney"].doubleValue
            self.withdrawaStartMoney=json["withdrawaStartMoney"].doubleValue
            self.lblTitle.text="提现金额不能低于\(self.withdrawaStartMoney!)"
            self.cashRateByWx=json["cashRateByWx"].floatValue
            self.cashRateByAli=json["cashRateByAli"].floatValue
            self.cashRateByBankCard=json["cashRateByBankCard"].floatValue
            self.withdrawNumberDays=json["withdrawNumberDays"].intValue
            self.withdrawCycle=json["withdrawCycle"].intValue
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

