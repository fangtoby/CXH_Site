//
//  ProvinceCollectionViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2018/6/15.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 搜索cell
class ProvinceCollectionViewCell:UICollectionViewCell{
    fileprivate var lblName:UILabel!
    override init(frame: CGRect) {
        super.init(frame:frame)
        lblName=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.center)
        self.contentView.addSubview(lblName)
        self.contentView.layer.cornerRadius=5
        self.contentView.layer.borderColor=UIColor.borderColor().cgColor
        self.contentView.layer.borderWidth=0.5
        lblName.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left)
            make.top.equalTo(7.5)
            make.height.equalTo(20)
            make.right.equalTo(self.contentView.snp.right)
        }
    }
    /**
     更新cell

     - parameter str:
     */
    func updateCell(_ str:String){
        if str == "清除"{
            self.contentView.backgroundColor=UIColor.applicationMainColor()
            lblName.textColor=UIColor.white
        }else{
            self.contentView.backgroundColor=UIColor.white
            lblName.textColor=UIColor.color999()
        }
        lblName.text=str
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes=super.preferredLayoutAttributesFitting(layoutAttributes)
        let size=lblName.text!.textSizeWithFont(lblName.font, constrainedToSize:CGSize(width:400,height: self.lblName.frame.size.height))
        frame.size.height=35
        frame.size.width=size.width+30
        attributes.frame=frame
        return attributes
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
