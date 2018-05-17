//
//  WithdrawaRecordTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import UIKit
/// 提现记录
class WithdrawaRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBOutlet weak var lblPrice: UILabel!

    @IBOutlet weak var img:UIImageView!

    @IBOutlet weak var lblWithdrawaType:UILabel!

    @IBOutlet weak var lblWithdrawaRecordStatu:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTime.textColor=UIColor.textColor()
        lblPrice.textColor=UIColor.RGBFromHexColor("e33e68")
        lblWithdrawaRecordStatu.textColor=UIColor.applicationMainColor()
        // Initialization code
    }
    func updateCell(_ entity:WithdrawaRecordEntity){
        lblTime.text="提现时间:"+(entity.withdrawaRecordTime ?? "")
        lblName.text="提现人:\(entity.withdrawaRecordName ?? "")"
        if entity.withdrawaType == 1{
            img.image=UIImage(named:"tx")
            lblWithdrawaType.text="银行卡"
            lblName.text="提现人:\(entity.withdrawaRecordName ?? "")\(entity.withdrawaRecordBankCardNumber ?? "")"
        }else if entity.withdrawaType == 2{
            img.image=UIImage(named:"wx")
            lblWithdrawaType.text="微信"
        }else{
            img.image=UIImage(named:"alipay")
            lblWithdrawaType.text="支付宝"
        }
        switch entity.withdrawaRecordStatu {
        case 1:
            lblWithdrawaRecordStatu.text="未处理"
            break
        case 2:
            lblWithdrawaRecordStatu.text="提现成功"
            if entity.withdrawaType != 1{
                lblTime.text="到账时间:"+(entity.withdrawalsSusscesTime ?? "")
            }
            break
        case 3:
            lblWithdrawaRecordStatu.text="提现失败"
            break
        default:
            lblWithdrawaRecordStatu.text="未处理"
            break
        }
        if entity.withdrawaRecordMoney != nil{
            lblPrice.text="\(entity.withdrawaRecordMoney!)"
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
