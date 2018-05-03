//
//  ReplaceSignListTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/25.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
///代签收记录cell
class ReplaceSignListTableViewCell:UITableViewCell{
    fileprivate var SN:UILabel!
    fileprivate var name:UILabel!
    fileprivate var phoneNumber:UILabel!
    fileprivate var time:UILabel!
    fileprivate var statu:UILabel!
    fileprivate var addMoney:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        SN=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        SN.frame=CGRect(x: 15,y: 15,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(SN)
        
        statu=buildLabel(UIColor.applicationMainColor(), font:14, textAlignment: NSTextAlignment.right)
        statu.frame=CGRect(x: 0,y: 15,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(statu)
        
        name=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 45,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(name)
        
        phoneNumber=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        phoneNumber.frame=CGRect(x: boundsWidth/2,y: 45,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(phoneNumber)
        
        addMoney=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        addMoney.frame=CGRect(x: 15,y: 75,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(addMoney)
        
        time=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        time.frame=CGRect(x: 15,y: 105,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(time)
        
        
        self.selectionStyle = .none

    }
    func updateCell(_ entity:ExpressmailStorageEntity){
        if entity.expressmailStorageToCompanySN != nil{
            SN.text="单号:\(entity.expressmailStorageToCompanySN!)"
        }
        if entity.expressmailStorageName != nil{
            name.text="收件人姓名:\(entity.expressmailStorageName!)"
        }
        if entity.expressmailStoragePhoneNumber != nil{
            phoneNumber.text="手机号码:\(entity.expressmailStoragePhoneNumber!)"
        }
        if entity.signTime != nil{
            time.text="代签收时间:\(entity.signTime!)"
        }
        if entity.addMoney != nil{
            addMoney.text="加钱金额:\(entity.addMoney!)元"
        }
        statu.text="已代签收"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
