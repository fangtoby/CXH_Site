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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTime.textColor=UIColor.textColor()
        lblPrice.textColor=UIColor.applicationMainColor()
        // Initialization code
    }
    func updateCell(_ entity:WithdrawaEntity){
        if entity.withdrawaName != nil{
            if entity.withdrawaBankCardNumber != nil{
                lblName.text=entity.withdrawaName!+"   "+entity.withdrawaBankCardNumber!
            }
        }
        if entity.withdrawaRecordTime != nil{
            lblTime.text=entity.withdrawaRecordTime
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
