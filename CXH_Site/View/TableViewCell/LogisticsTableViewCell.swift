//
//  LogisticsTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/21.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 司机物流cell
class LogisticsTableViewCell:UITableViewCell{
    fileprivate var lblShippingName:UILabel!
    fileprivate var lblTime:UILabel!
    fileprivate var lblStoreCount:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        lblShippingName=buildLabel(UIColor.black, font:15, textAlignment: NSTextAlignment.left)
        lblShippingName.frame=CGRect(x: 15,y: 15,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(lblShippingName)
        
        lblTime=buildLabel(UIColor.color666(), font:14, textAlignment: NSTextAlignment.left)
        lblTime.frame=CGRect(x: 15,y: 45,width: boundsWidth-15,height: 20)
        self.contentView.addSubview(lblTime)
        
        lblStoreCount=buildLabel(UIColor.color333(), font:13, textAlignment: NSTextAlignment.right)
        lblStoreCount.frame=CGRect(x: 0,y: 30,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(lblStoreCount)
        self.selectionStyle = .none
    }
    
    func updateCell(_ entity:ExpressmailStorageEntity){
        if entity.shippingName != nil{
            lblShippingName.text="路线:\(entity.shippingName!)"
        }
        if entity.userCtime != nil{
            lblTime.text="接收时间:\(entity.userCtime!)"
        }
        if entity.storePackList != nil{
            let arrCount=entity.storePackList!.components(separatedBy: ",")
            lblStoreCount.text="\(arrCount.count)个站点包"
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
