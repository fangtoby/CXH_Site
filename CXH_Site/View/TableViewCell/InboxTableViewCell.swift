//
//  InboxTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/7.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
protocol InboxTableViewCellDelegate:NSObjectProtocol{
    func pushDetails(_ entity:ExpressmailStorageEntity)
    func replaceSignForUser(_ entity:ExpressmailStorageEntity)
    func storeReturn(_ entity:ExpressmailStorageEntity)
}
/// 收件cell
class InboxTableViewCell:UITableViewCell{
    var delegate:InboxTableViewCellDelegate?
    fileprivate var entity:ExpressmailStorageEntity?
    fileprivate var topBacView:UIView!
    fileprivate var lblNumberSN:UILabel!
    fileprivate var lblTime:UILabel!
    fileprivate var borderView:UIView!
    fileprivate var btnFJ:UIButton!
    fileprivate var btnDQC:UIButton!
    fileprivate var btnDetails:UIButton!
    fileprivate var lblName:UILabel!
    fileprivate var lblTh:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        topBacView=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 8))
        topBacView.backgroundColor=UIColor.viewBackgroundColor()
        self.contentView.addSubview(topBacView)
        
        lblNumberSN=UILabel(frame:CGRect(x: 15,y: 23,width: 220,height: 20))
        lblNumberSN.font=UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(lblNumberSN)
        
        lblTh=buildLabel(UIColor.applicationMainColor(), font:14, textAlignment: NSTextAlignment.right)
        lblTh.frame=CGRect(x: 235,y: 23,width: boundsWidth-250,height: 20)
        self.contentView.addSubview(lblTh)
        
        
        lblTime=UILabel(frame:CGRect(x: 15,y: lblNumberSN.frame.maxY+10,width: boundsWidth-30,height: 20))
        lblTime.textColor=UIColor.color666()
        lblTime.font=UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(lblTime)
        
        borderView=UIView(frame:CGRect(x: 0,y: lblTime.frame.maxY+15,width: boundsWidth,height: 1))
        borderView.backgroundColor=UIColor.borderColor()
        self.contentView.addSubview(borderView)
        
        lblName=buildLabel(UIColor.applicationMainColor(), font:14, textAlignment: NSTextAlignment.left)
        lblName.frame=CGRect(x: 15,y: borderView.frame.maxY+10,width: boundsWidth-280,height: 30)
        self.contentView.addSubview(lblName)
        
        btnDetails=ButtonControl().button(ButtonType.cornerRadiusButton, text:"详情", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:5)
        btnDetails.addTarget(self, action:#selector(details), for: UIControlEvents.touchUpInside)
        btnDetails.frame=CGRect(x: boundsWidth-75,y: borderView.frame.maxY+10,width: 60,height: 30)
        self.contentView.addSubview(btnDetails)
        
        btnDQC=ButtonControl().button(ButtonType.cornerRadiusButton, text:"代签收", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:5)
        btnDQC.addTarget(self, action:#selector(dqc), for: UIControlEvents.touchUpInside)
        btnDQC.frame=CGRect(x: boundsWidth-150,y: borderView.frame.maxY+10,width: 60,height: 30)
        self.contentView.addSubview(btnDQC)
        
        btnFJ=ButtonControl().button(ButtonType.cornerRadiusButton, text:"返件", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:5)
        btnFJ.addTarget(self, action:#selector(fj), for: UIControlEvents.touchUpInside)
        btnFJ.frame=CGRect(x: boundsWidth-225,y: borderView.frame.maxY+10,width: 60,height: 30)
        self.contentView.addSubview(btnFJ)
        
        self.selectionStyle = .none
    }
    @objc func details(){
        delegate?.pushDetails(entity!)
    }
    @objc func dqc(){
        delegate?.replaceSignForUser(entity!)
    }
    @objc func fj(){
        delegate?.storeReturn(entity!)
    }
    /**
     更新数据
     
     - parameter entity:
     */
    func updateCell(_ entity:ExpressmailStorageEntity,identity:Int){
        self.entity=entity
        if entity.expressmailStorageToCompanySN != nil{
            lblNumberSN.text="单号:\(entity.expressmailStorageToCompanySN!)"
        }else{
            if entity.expressmailStorageSN != nil{
                lblNumberSN.text="单号:\(entity.expressmailStorageSN!)"
            }
        }
        if entity.ctime != nil{
            lblTime.text="创建时间:\(entity.ctime!)"
        }
        if entity.expressmailStatu != nil{
            switch entity.expressmailStatu!{
            case 1:
                lblName.text="已入库"
                break
            case 2:
                lblName.text="司机已签收"
                break
            case 3:
                lblName.text="已到达配送站"
                break
            case 4:
                lblName.text="站点代签收"
                break
            case 5:
                lblName.text="用户确认签收"
                break
            case 6:
                lblName.text="司机代签收"
                break
            case 7:
                lblName.text="总仓代签收"
                break
            default:break
            }
            if entity.returnStorageStatu != nil{
                if entity.returnStorageStatu == 2{
                    lblTh.text="返件中..."
                    btnFJ.isHidden=true
                    btnDQC.isHidden=true
                }else{
                    lblTh.text=nil
                    if identity == 2{//如果是站点
                        if entity.expressmailStatu == 3{//显示返件按钮/代签收按钮
                            btnFJ.isHidden=false
                            btnDQC.isHidden=false
                        }else{
                            btnFJ.isHidden=true
                            btnDQC.isHidden=true
                        }
                    } else if identity == 3{//如果是司机
                        if entity.expressmailStatu == 2{//显示返件按钮/代签收按钮
                            btnFJ.isHidden=false
                            btnDQC.isHidden=false
                        }else{
                            btnFJ.isHidden=true
                            btnDQC.isHidden=true
                        }
                    }
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
