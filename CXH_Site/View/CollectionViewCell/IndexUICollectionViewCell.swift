//
//  IndexCollectionViewCell.swift
//  CXHSalesman
//
//  Created by hao peng on 2017/4/11.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
///首页cell
class IndexCollectionViewCell:LWLineSeparatorCollectionViewCell{
    fileprivate var img:UIImageView!
    fileprivate var lblName:UILabel!
    fileprivate var view:UIView!
    override init(frame: CGRect) {
        super.init(frame:frame)
        let width=boundsWidth/3
        img=UIImageView(frame:CGRect(x:(width-40)/2,y:(width-65)/2,width:40,height:40))
        self.contentView.addSubview(img)
        lblName=buildLabel(UIColor.color333(), font:16, textAlignment: NSTextAlignment.center)
        lblName.font=UIFont.systemFont(ofSize: 14)
        lblName.frame=CGRect(x:0,y:img.frame.maxY+5,width:width,height:20)
        self.contentView.addSubview(lblName)
        self.contentView.backgroundColor=UIColor.white
        
    }
    
    /// 更新数据
    ///
    /// - Parameters:
    ///   - imgStr: 图片
    ///   - str: 名称
    func updateCell(_ imgStr:String,str:String){
        img.image=UIImage(named:imgStr)
        lblName.text=str
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
