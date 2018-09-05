//
//  CourierEntryHistoryListTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2018/9/5.
//  Copyright © 2018年 zltx. All rights reserved.
// cehid

import UIKit

class CourierEntryHistoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!

    @IBOutlet weak var lblTel:UILabel!

    @IBOutlet weak var lblAddress:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        // Initialization code
        self.accessoryType = .disclosureIndicator
    }

    func updateCell(entity:ExpressmailEntity,flag:Int){
        if flag == 1{///寄件人信息
            lblName.text=entity.fromName
            lblTel.text=entity.fromphoneNumber
            lblAddress.text="\(entity.fromprovince ?? "")\(entity.fromcity  ?? "")\(entity.fromcounty ?? "")"
        }else{///收件人信息
            lblName.text=entity.toName
            lblTel.text=entity.tophoneNumber
            lblAddress.text="\(entity.toprovince ?? "")\(entity.tocity  ?? "")\(entity.tocounty ?? "")\(entity.todetailAddress ?? "")"
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
