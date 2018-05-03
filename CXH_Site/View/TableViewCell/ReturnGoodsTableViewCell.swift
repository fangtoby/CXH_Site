//
//  ReturnGoodsTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
protocol ReturnGoodsTableViewCellDelegate:NSObjectProtocol{
    func confirmedReturn(_ entity:ReturnGoodsEntity)
    func pushDetails(_ entity:ReturnGoodsEntity)
}
/// 退货信息cell
class ReturnGoodsTableViewCell:UITableViewCell {
    var delegate:ReturnGoodsTableViewCellDelegate?
    fileprivate var name:UILabel!
    fileprivate var tel:UILabel!
    fileprivate var expressName:UILabel!
    fileprivate var expressON:UILabel!
    fileprivate var submitTime:UILabel!
    fileprivate var btn:UIButton!
    fileprivate var btnDetails:UIButton!
    fileprivate var price:UILabel!
    fileprivate var returnGoodsReason:UILabel!
    fileprivate var entity:ReturnGoodsEntity?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        name=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 15,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(name)
        
        tel=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        tel.frame=CGRect(x: name.frame.maxX,y: 15,width: boundsWidth/2,height: 20)
        self.contentView.addSubview(tel)
        
        returnGoodsReason=buildLabel(UIColor.black, font: 14, textAlignment: NSTextAlignment.left)
        returnGoodsReason.frame=CGRect(x: 15,y: 45,width: boundsWidth-30,height: 20)
        self.contentView.addSubview(returnGoodsReason)
        
        expressName=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        expressName.frame=CGRect(x: 15,y: 75,width: boundsWidth/2-15,height: 20)
        self.contentView.addSubview(expressName)
        
        expressON=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        expressON.frame=CGRect(x: 15,y: 105,width: boundsWidth/2,height: 20)
        self.contentView.addSubview(expressON)
        
        submitTime=buildLabel(UIColor.textColor(), font:13, textAlignment: NSTextAlignment.left)
        submitTime.frame=CGRect(x: 15,y: expressON.frame.maxY+10,width: boundsWidth-15, height: 20)
        self.contentView.addSubview(submitTime)
        
        let borderView=UIView(frame:CGRect(x: 0,y: submitTime.frame.maxY+15,width: boundsWidth,height: 1))
        borderView.backgroundColor=UIColor.borderColor()
        self.contentView.addSubview(borderView)
        
        btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认退货", textColor:UIColor.white, font:15, backgroundColor: UIColor.applicationMainColor(), cornerRadius:5)
        btn.addTarget(self, action:#selector(th), for: UIControlEvents.touchUpInside)
        btn.frame=CGRect(x: boundsWidth-190,y: borderView.frame.maxY+10,width: 80,height: 30)
        self.contentView.addSubview(btn)
        
        btnDetails=ButtonControl().button(ButtonType.cornerRadiusButton, text:"详情", textColor:UIColor.white, font:15, backgroundColor: UIColor.applicationMainColor(), cornerRadius:5)
        btnDetails.addTarget(self, action:#selector(pushOrderDetails), for: UIControlEvents.touchUpInside)
        btnDetails.frame=CGRect(x: boundsWidth-95,y: borderView.frame.maxY+10,width: 80,height: 30)
        self.contentView.addSubview(btnDetails)
        price=buildLabel(UIColor.red, font:13, textAlignment: NSTextAlignment.left)
        price.frame=CGRect(x: 15,y: borderView.frame.maxY+10,width: boundsWidth-110,height: 30)
        self.contentView.addSubview(price)
        
        
        
        let borderView1=UIView(frame:CGRect(x: 0,y: btn.frame.maxY+10,width: boundsWidth,height: 4))
        borderView1.backgroundColor=UIColor.viewBackgroundColor()
        self.contentView.addSubview(borderView1)
        self.selectionStyle = .none
    }
    @objc func th(){
        delegate?.confirmedReturn(self.entity!)
    }
    @objc func pushOrderDetails(){
        delegate?.pushDetails(self.entity!)
    }
    func updateCell(_ entity:ReturnGoodsEntity,flag:Int){
        self.entity=entity
        if entity.shippName != nil{
            name.text="退货人:\(entity.shippName!)"
        }
        if entity.orderPrice != nil{
            price.text="退货金额:\(entity.orderPrice!)"
        }
        if entity.tel != nil{
            tel.text="电话:\(entity.tel!)"
        }
        if entity.returnGoodsSubmitTime != nil{
            submitTime.text="提交时间:\(entity.returnGoodsSubmitTime!)"
        }
        if entity.returnGoodsExpressName != nil{
            expressName.text="快递公司:\(entity.returnGoodsExpressName!)"
        }
        if entity.returnGoodsExpressON != nil{
            expressON.text="快递单号:\(entity.returnGoodsExpressON!)"
        }
        if entity.returnGoodsReason != nil{
            returnGoodsReason.text="退货理由:\(entity.returnGoodsReason!)"
        }
        if flag == 1{
            btn.isHidden=true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
