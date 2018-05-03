//
//  StorecapitalrecordTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 消费扣除记录cell
class StorecapitalrecordTableViewCell:UITableViewCell{
    fileprivate var time:UILabel!
    fileprivate var capitalSum:UILabel!
    fileprivate var name:UILabel!
    fileprivate var expressmailSN:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        name=buildLabel(UIColor.black, font:15, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 15,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(name)
        
        time=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        time.frame=CGRect(x: 15,y: 45,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(time)
        
        capitalSum=buildLabel(UIColor.applicationMainColor(), font:16, textAlignment: NSTextAlignment.right)
        capitalSum.frame=CGRect(x: 200,y: 30,width: boundsWidth-215,height: 20)
        self.contentView.addSubview(capitalSum)
        
        expressmailSN=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        expressmailSN.frame=CGRect(x: 15,y: time.frame.maxY+5,width: boundsWidth-15,height: 20)
        
        self.contentView.addSubview(expressmailSN)
    }
    /**
     更新cell
     */
    func updateCell(_ entity:StorecapitalrecordEntity){
        if entity.statu == 1{
            name.text="邮寄快递扣除"
        }else if entity.statu == 2{
            name.text="订单发货扣除"
        }else if entity.statu == 3{
            name.text="收件加钱扣除"
        }else if entity.statu == 4{
            name.text="保价扣除"
        }else if entity.statu == 5{
            name.text="总仓修改价格扣除"
        }else if entity.statu == 6{
            name.text="提现扣除"
        }
        if entity.cTime != nil{
            time.text="扣除时间:\(entity.cTime!)"
        }
        if entity.capitalSum != nil{
            capitalSum.text="-\(entity.capitalSum!)"
        }
        if entity.expressmailSN != nil{
            expressmailSN.text="邮寄单号:\(entity.expressmailSN!)"
        }else{
            expressmailSN.text="邮寄单号:没有单号"
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
