//
//  CourierUpdateListTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/24.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
protocol CourierUpdateListTableViewCellDelegate:NSObjectProtocol{
    func confirmUpdate(_ entity:ExpressmailUpdateEntity)
    func pushDetails(_ entity:ExpressmailUpdateEntity)
}
/// 揽件修改记录cell
class CourierUpdateListTableViewCell:UITableViewCell {
    var delegate:CourierUpdateListTableViewCellDelegate?
    fileprivate var lblStatu:UILabel!
    fileprivate var lblTime:UILabel!
    fileprivate var lblFrontFreight:UILabel!
    fileprivate var lblBackFreight:UILabel!
    fileprivate var lblFrontWeight:UILabel!
    fileprivate var lblBackWeight:UILabel!
    fileprivate var btnDetail:UIButton!
    fileprivate var btnUpdate:UIButton!
    fileprivate var entity:ExpressmailUpdateEntity?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        lblStatu=buildLabel(UIColor.applicationMainColor(), font:15, textAlignment: NSTextAlignment.left)
        lblStatu.frame=CGRect(x: 15,y: 15,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(lblStatu)
        
        lblBackFreight=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblBackFreight.frame=CGRect(x: 15,y: 45,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(lblBackFreight)
        
        lblFrontFreight=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblFrontFreight.frame=CGRect(x: boundsWidth/2,y: 45,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(lblFrontFreight)
        
        lblBackWeight=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblBackWeight.frame=CGRect(x: 15,y: 75,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(lblBackWeight)
        
        lblFrontWeight=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblFrontWeight.frame=CGRect(x: boundsWidth/2,y: 75,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(lblFrontWeight)
        
        lblTime=buildLabel(UIColor.textColor(), font:13, textAlignment: NSTextAlignment.left)
        lblTime.frame=CGRect(x: 15,y: lblFrontWeight.frame.maxY+10,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(lblTime)
        
        let borderView=UIView(frame:CGRect(x: 0,y: lblTime.frame.maxY+15,width: boundsWidth,height: 1))
        borderView.backgroundColor=UIColor.borderColor()
        self.contentView.addSubview(borderView)
        
        btnDetail=ButtonControl().button(ButtonType.cornerRadiusButton, text:"详情", textColor:UIColor.white, font:15, backgroundColor: UIColor.applicationMainColor(), cornerRadius:5)
        btnDetail.frame=CGRect(x: boundsWidth-95,y: borderView.frame.maxY+10,width: 80,height: 30)
        btnDetail.addTarget(self, action:#selector(details), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(btnDetail)
        
        btnUpdate=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认修改", textColor:UIColor.white, font:15, backgroundColor: UIColor.applicationMainColor(), cornerRadius:5)
        btnUpdate.addTarget(self, action:#selector(update), for: UIControlEvents.touchUpInside)
        btnUpdate.frame=CGRect(x: boundsWidth-190,y: borderView.frame.maxY+10,width: 80,height: 30)
        self.contentView.addSubview(btnUpdate)
        
        let borderView1=UIView(frame:CGRect(x: 0,y: btnUpdate.frame.maxY+10,width: boundsWidth,height: 4))
        borderView1.backgroundColor=UIColor.viewBackgroundColor()
        self.contentView.addSubview(borderView1)
        self.selectionStyle = .none
    }
    @objc func details(){
        delegate?.pushDetails(entity!)
    }
    @objc func update(){
        delegate?.confirmUpdate(entity!)
    }
    //更新
    func updateCell(_ entity:ExpressmailUpdateEntity){
        self.entity=entity
        if entity.expressmailUpdateStatu == 1{
            lblStatu.text="状态:等待确认"
            btnUpdate.isHidden=false
            if entity.expressmailUpdateTime != nil{
                lblTime.text="申请时间:\(entity.expressmailUpdateTime!)"
            }
        }else{
            lblStatu.text="状态:已确认"
            btnUpdate.isHidden=true
            if entity.expressmailUpdateStoreConfirmTime != nil{
                lblTime.text="确认时间:\(entity.expressmailUpdateStoreConfirmTime!)"
            }
        }
        if entity.expressmailUpdateBackWeight != nil{
            lblBackWeight.text="修改后重量:\(entity.expressmailUpdateBackWeight!)"
        }
        if entity.expressmailUpdateFrontWeight != nil{
            lblFrontWeight.text="修改前重量:\(entity.expressmailUpdateFrontWeight!)"
        }
        if entity.expressmailUpdateBackFreight != nil{
            lblBackFreight.text="修改后运费:\(entity.expressmailUpdateBackFreight!)"
        }
        if entity.expressmailUpdateFrontFreight != nil{
            lblFrontFreight.text="修改前运费:\(entity.expressmailUpdateFrontFreight!)"
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
