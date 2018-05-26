//
//  StorePrepaidrecordTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 充值记录cell
class StorePrepaidrecordTableViewCell:UITableViewCell{
    fileprivate var time:UILabel!
    fileprivate var capitalSum:UILabel!
    fileprivate var name:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        name=buildLabel(UIColor.black, font:15, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 15,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(name)
        
        time=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        time.frame=CGRect(x: 15,y: 45,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(time)
        
        capitalSum=buildLabel(UIColor.applicationMainColor(), font:16, textAlignment: NSTextAlignment.right)
        capitalSum.frame=CGRect(x: 200,y: 30,width: boundsWidth-230,height: 20)
        self.contentView.addSubview(capitalSum)

    }
    /**
     更新cell
     */
    func updateCell(_ entity:StorePrepaidrecordEntity){
        self.accessoryType = .none
        if entity.prepaidType == 1{
            name.text="后台管理人员充值"
        }else if entity.prepaidType == 2{
            name.text="系统返回销售金额"
            self.accessoryType = .disclosureIndicator
        }else if entity.prepaidType == 3{
            name.text="系统返回快递费"
        }else if entity.prepaidType == 4{
            name.text="系统返回物流费"
        }else if entity.prepaidType == 5{
            name.text="退件退回快递费"
        }
        if entity.prepaidTime != nil{
            time.text="充值时间:\(entity.prepaidTime!)"
        }
        if entity.prepaidMoney != nil{
            capitalSum.text="+\(entity.prepaidMoney!)"
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
