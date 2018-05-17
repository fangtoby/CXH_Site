//
//  WithdrawalSuccessViewController.swift
//  ddjdConsumer
//
//  Created by hao peng on 2018/1/10.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
///提现成功提示页面
class  WithdrawalSuccessViewController:BaseViewController {
    ///‘提现后的到账周期； T+几’,
    var withdrawNumberDays:Int?
    ///‘提现方式；1，提现后直接到账； 2，以 withdrawNumberDays 这个字段规定的天数进行提现到账’,
    var withdrawCycle:Int?
    ///提现类型 1银行卡  2微信  3支付宝
    var withdrawType:Int?
    ///提现账号信息
    var withdrawAccount:String?
    ///提现手续费
    var cashRateByMoney:String?
    ///提现金额
    var money:String?
    @IBOutlet weak var btn: UIButton!
    ///提示信息
    @IBOutlet weak var lblMsg:UILabel!
    ///手续费
    @IBOutlet weak var lblCashRateBy:UILabel!
    ///金额
    @IBOutlet weak var lblMoney:UILabel!
    ///提现账户文本
    @IBOutlet weak var lblAccount:UILabel!
    ///提现账户value
    @IBOutlet weak var lblAccountValue:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="提现申请成功"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        btn.backgroundColor=UIColor.applicationMainColor()
        btn.layer.cornerRadius=5
        btn.addTarget(self, action:#selector(popVC), for: UIControlEvents.touchUpInside)

        if withdrawCycle == 2{
            lblMsg.text="\(withdrawNumberDays ?? 1)天内到账，请注意前往绑定的提现账号查收!"
        }
        if withdrawType == 1{
            lblAccount.text="到账银行卡"
        }else if withdrawType == 2{
            lblAccount.text="到账微信"
        }else if withdrawType == 3{
            lblAccount.text="到账支付宝"
        }
        lblMoney.text="￥\(money ?? "0")"
        lblCashRateBy.text="￥\(cashRateByMoney ?? "0")"
        lblAccountValue.text=withdrawAccount
    }
    override func navigationShouldPopOnBackButton() -> Bool {
        popVC()
        return false
    }
    @objc private func popVC(){
        for vc:UIViewController in (self.navigationController?.viewControllers)!{
            if vc.isKind(of:PersonalCenterViewController.classForCoder()){
                self.navigationController?.popToViewController(vc, animated:true)
            }
        }
    }
}

