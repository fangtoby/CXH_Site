//
//  ReturnHistoryTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/25.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 返件记录cell
class ReturnHistoryTableViewCell:UITableViewCell{
    fileprivate var returnStorageSN:UILabel!
    fileprivate var returnStorageName:UILabel!
    fileprivate var returnStoragePhoneNumber:UILabel!
    fileprivate var returnStorageTime:UILabel!
    fileprivate var returnStorageStatu:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        returnStorageSN=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        returnStorageSN.frame=CGRect(x: 15,y: 15,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(returnStorageSN)
        
        returnStorageStatu=buildLabel(UIColor.applicationMainColor(), font:14, textAlignment: NSTextAlignment.right)
        returnStorageStatu.frame=CGRect(x: 0,y: 15,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(returnStorageStatu)
        
        returnStorageName=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        returnStorageName.frame=CGRect(x: 15,y: 45,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(returnStorageName)
        
        returnStoragePhoneNumber=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        returnStoragePhoneNumber.frame=CGRect(x: boundsWidth/2,y: 45,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(returnStoragePhoneNumber)
        
        returnStorageTime=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        returnStorageTime.frame=CGRect(x: 15,y: 75,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(returnStorageTime)
        
        
        self.selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(_ entity:ReturnStorageEntity){
        if entity.returnStorageStatu != 4{
            returnStorageStatu.text="返件中..."
            if entity.returnStorageTime != nil{
                returnStorageTime.text="申请返件时间:\(entity.returnStorageTime!)"
            }
        }else{
            returnStorageStatu.text="已返件"
            if entity.returnStorageHeadquartersReceiveCtime != nil{
                returnStorageTime.text="完成时间:\(entity.returnStorageHeadquartersReceiveCtime!)"
            }
        }
        if entity.returnStorageSN != nil{
            returnStorageSN.text="单号:\(entity.returnStorageSN!)"
        }
        if entity.returnStorageName != nil{
            returnStorageName.text="收件人姓名:\(entity.returnStorageName!)"
        }
        if entity.returnStoragePhoneNumber != nil{
            returnStoragePhoneNumber.text="手机号码:\(entity.returnStoragePhoneNumber!)"
        }
    }
}
