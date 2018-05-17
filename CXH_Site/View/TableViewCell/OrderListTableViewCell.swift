//
//  OrderListTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 订单cell
class OrderListTableViewCell:UITableViewCell{
    //商品图片
    fileprivate var goodImg:UIImageView!
    //商品名称
    fileprivate var lblGoodName:UILabel!
    //商品价格和单位
    fileprivate var lblPriceOfWeight:UILabel!
    //商品数量
    fileprivate var lblGoodCount:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        goodImg=UIImageView(frame:CGRect(x: 15,y: 15,width: 90,height: 90))
        self.contentView.addSubview(goodImg)
        lblGoodName=UILabel(frame:CGRect(x: goodImg.frame.maxX+5,y: 5,width: boundsWidth-(goodImg.frame.maxX+5)-15,height: 40))
        lblGoodName.font=UIFont.systemFont(ofSize: 14)
        lblGoodName.lineBreakMode=NSLineBreakMode.byWordWrapping
        lblGoodName.numberOfLines=2
        lblGoodName.textColor=UIColor.RGBFromHexColor("#333333")
        self.contentView.addSubview(lblGoodName)
        
        lblPriceOfWeight=UILabel(frame:CGRect(x: goodImg.frame.maxX+5,y: 85,width: 200,height: 20))
        lblPriceOfWeight.font=UIFont.systemFont(ofSize: 15)
        lblPriceOfWeight.textColor=UIColor.RGBFromHexColor("#666666")
        self.contentView.addSubview(lblPriceOfWeight)
        
        lblGoodCount=UILabel(frame:CGRect(x: lblPriceOfWeight.frame.maxX,y: lblPriceOfWeight.frame.origin.y,width: boundsWidth-lblPriceOfWeight.frame.maxX-15,height: 20))
        lblGoodCount.textAlignment = .right
        lblGoodCount.textColor=UIColor.color333()
        lblGoodCount.font=UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(lblGoodCount)
        self.selectionStyle = .none
    }
    /**
     更新cell
     
     - parameter entity: 商品entity
     */
    func updateCell(_ entity:GoodEntity){
        lblGoodCount.text="x\(entity.goodsCount!)"
        let priceCount="\(entity.goodsPrice!)".count
        let str:NSMutableAttributedString=NSMutableAttributedString(string:"￥\(entity.goodsPrice!)/\(entity.goodUnit!)");
        let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 20)]
        str.addAttributes(normalAttributes, range:NSMakeRange(0,priceCount+1))
        lblPriceOfWeight.attributedText=str
        if entity.retailOrWholesaleFlag == 2{
            let goodName="[批发商品]"+(entity.goodInfoName ?? "")
            let str:NSMutableAttributedString=NSMutableAttributedString(string:goodName);
            let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font:UIFont.systemFont(ofSize:14)]
            str.addAttributes(normalAttributes, range:NSMakeRange(0,6))
            lblGoodName.attributedText=str
        }else{
            lblGoodName.text=entity.goodInfoName
        }
        goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "default_icon"))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
