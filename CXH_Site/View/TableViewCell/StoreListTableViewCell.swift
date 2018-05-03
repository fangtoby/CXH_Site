//
//  StoreListTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/21.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 司机物流cell
class StoreListTableViewCell:UITableViewCell{
    fileprivate var lblShippingName:UILabel!
    fileprivate var lblTime:UILabel!
    fileprivate var lblStoreCount:UILabel!
    fileprivate var lblName:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        lblShippingName=buildLabel(UIColor.black, font:15, textAlignment: NSTextAlignment.left)
        lblShippingName.frame=CGRect(x: 15,y: 15,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(lblShippingName)
        
        lblTime=buildLabel(UIColor.color666(), font:14, textAlignment: NSTextAlignment.left)
        lblTime.frame=CGRect(x: 15,y: 45,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(lblTime)
        
        lblStoreCount=buildLabel(UIColor.color333(), font:13, textAlignment: NSTextAlignment.right)
        lblStoreCount.frame=CGRect(x: 0,y: 45,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(lblStoreCount)
        
        lblName=buildLabel(UIColor.applicationMainColor(), font:14, textAlignment: NSTextAlignment.left)
        lblName.frame=CGRect(x: 15,y: 75,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(lblName)
        self.selectionStyle = .none
    }
    
    func updateCell(_ entity:ExpressmailStorageEntity){
        if entity.storeName != nil{
            lblShippingName.text="站点名称:\(entity.storeName!)"
        }else{
            lblShippingName.text="请扫描获取包内快件"
        }
        if entity.userCtime != nil{
            lblTime.text="接收时间:\(entity.userCtime!)"
            lblName.text="已接收"
        }else{
            if entity.ctime != nil{
                lblTime.text="生成站点包时间:\(entity.ctime!)"
                lblName.text="未接收"
            }
        }
        if entity.expressmailList != nil{
            let arrCount=entity.expressmailList!.components(separatedBy: ",")
            lblStoreCount.text="\(arrCount.count)个快件包"
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
