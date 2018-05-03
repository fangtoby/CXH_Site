//
//  AcceptTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
///物流信息 cell
class AcceptTableViewCell:UITableViewCell{
    fileprivate var leftBorderView:UIView!
    fileprivate var leftGarden:UIView!
    fileprivate var borderView:UIView!
    fileprivate var lblAcceptTime:UILabel!
    fileprivate var lblAcceptStation:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftBorderView=UIView()
        self.contentView.addSubview(leftBorderView)
        leftGarden=UIView()
        leftGarden.layer.cornerRadius=15/2
        self.contentView.addSubview(leftGarden)
        borderView=UIView()
        borderView.backgroundColor=UIColor.borderColor()
        
        lblAcceptTime=buildLabel(UIColor.color999(), font:13, textAlignment: NSTextAlignment.left)
        lblAcceptTime.frame=CGRect(x: 25,y: 15,width: boundsWidth-25,height: 20)
        self.contentView.addSubview(lblAcceptTime)
        lblAcceptStation=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
        lblAcceptStation.numberOfLines=0
        lblAcceptStation.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(lblAcceptStation)
        self.contentView.addSubview(borderView)
        self.selectionStyle = .none
    }
    /**
     更新cell
     
     - parameter entity:
     */
    func updateCell(_ entity:AcceptEntity,row:Int){
        if row == 0{
            leftBorderView.backgroundColor=UIColor.applicationMainColor()
            leftGarden.backgroundColor=UIColor.applicationMainColor()
        }else{
            leftBorderView.backgroundColor=UIColor.borderColor()
            leftGarden.backgroundColor=UIColor.borderColor()
        }
        lblAcceptStation.text=entity.AcceptStation
        let size=lblAcceptStation.text!.textSizeWithFont(lblAcceptStation.font, constrainedToSize:CGSize(width: boundsWidth-25,height: 200))
        lblAcceptStation.frame=CGRect(x: 25,y: lblAcceptTime.frame.maxY+15,width: boundsWidth-40,height: size.height)
        lblAcceptTime.text=entity.AcceptTime
        self.frame.size.height=lblAcceptStation.frame.maxY+15
        leftBorderView.frame=CGRect(x: 15,y: 0,width: 1,height: self.frame.size.height)
        leftGarden.frame=CGRect(x: 8,y: (self.frame.size.height-15)/2,width: 15,height: 15)
        borderView.frame=CGRect(x: 25,y: self.frame.size.height-0.5,width: boundsHeight-25,height: 0.5)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
