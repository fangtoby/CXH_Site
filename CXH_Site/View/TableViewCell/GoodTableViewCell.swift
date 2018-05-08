//
//  GoodTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/8.
//  Copyright © 2018年 zltx. All rights reserved.
//

//
//  GoodTableViewCell.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/4.
//  Copyright © 2017年 zltx. All rights reserved.
//

import UIKit
/**
 *  协议
 */
protocol GoodTableViewCellDelegate:NSObjectProtocol{
    func pushDetailsVC(_ entity:GoodEntity)
    func theShelvesOperate(_ entity:GoodEntity)
    func theShelvesOperateFood(_ entity:FoodEntity)
    func pushPrintCodeVC(_ entity:GoodEntity)
    func pushFoodDetailsVC(_ entity:FoodEntity)
}
/// 商品cell
class GoodTableViewCell: UITableViewCell {

    weak var delegate:GoodTableViewCellDelegate?
    var goodEntity:GoodEntity?
    var foodEntity:FoodEntity?
    @IBOutlet weak var border1View: UIView!

    @IBOutlet weak var borderView: UIView!

    @IBOutlet weak var goodImg: UIImageView!

    @IBOutlet weak var lblGoodName: UILabel!

    @IBOutlet weak var lblPrice: UILabel!

    @IBOutlet weak var lblStock: UILabel!

    @IBOutlet weak var lblSold: UILabel!

    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnDetails: UIButton!

    @IBOutlet weak var btn: UIButton!

    //二维码
    @IBOutlet weak var btnCode: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.backgroundColor=UIColor.viewBackgroundColor()
        border1View.backgroundColor=UIColor.borderColor()
        goodImg.layer.borderColor=UIColor.borderColor().cgColor
        goodImg.layer.borderWidth=0.5
        lblPrice.textColor=UIColor.textColor()
        lblStock.textColor=UIColor.textColor()
        lblSold.textColor=UIColor.textColor()
        lblTitle.textColor=UIColor.applicationMainColor()
        btnDetails.backgroundColor=UIColor.applicationMainColor()
        btnDetails.layer.cornerRadius=5
        btn.backgroundColor=UIColor.applicationMainColor()
        btn.layer.cornerRadius=5
        btnCode.backgroundColor=UIColor.applicationMainColor()
        btnCode.layer.cornerRadius=5
        btnCode.addTarget(self, action:#selector(pushCode), for: UIControlEvents.touchUpInside)
        btnCode.isHidden=true
        self.selectionStyle = .none
    }
    /**
     更新cell

     - parameter entity:
     - parameter goodsbasicinfoFlag: 1，上架； 2，下架 3审核中
     */
    func updateGoodCell(_ entity:GoodEntity,goodsbasicinfoFlag:Int){
        goodEntity=entity
        if entity.goodPic != nil{
            goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "default_icon"))
        }
        lblGoodName.text=entity.goodInfoName
        if entity.goodsPrice != nil{
            if entity.goodUnit != nil{
                let priceCount="￥\(entity.goodsPrice!)".count
                let str:NSMutableAttributedString=NSMutableAttributedString(string:"￥\(entity.goodsPrice!)/\(entity.goodUnit!)");
                let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15)]
                str.addAttributes(normalAttributes, range:NSMakeRange(0,priceCount))
                lblPrice.attributedText=str
            }else{
                lblPrice.text="￥\(entity.goodsPrice!)"
            }
        }
        if entity.stock != nil{
            lblStock.text="库存:\(entity.stock!)"
        }
        if entity.salesCount != nil{
            lblSold.text="已售:\(entity.salesCount!)"
        }
        if goodsbasicinfoFlag == 1{
            lblTitle.text="上架中"
            btn.setTitle("下架", for:UIControlState())
            btnCode.isHidden=false
        }else if goodsbasicinfoFlag == 2{
            lblTitle.text="下架中"
            btn.setTitle("上架", for:UIControlState())
        }else if goodsbasicinfoFlag == 3{
            lblTitle.text="审核中"
            btn.isHidden=true
        }


    }
    /**
     更新cell

     - parameter entity:             菜品
     - parameter goodsbasicinfoFlag: 1上架 2下架
     */
    func updateFoodCell(_ entity:FoodEntity,goodsbasicinfoFlag:Int){
        foodEntity=entity
        if entity.foodPic != nil{
            goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+entity.foodPic!), placeholderImage:UIImage(named: "default_icon"))
        }
        lblGoodName.text=entity.foodName
        if entity.foodPrice != nil{
            if entity.foodUnit != nil{
                let priceCount="￥\(entity.foodPrice!)".count
                let str:NSMutableAttributedString=NSMutableAttributedString(string:"￥\(entity.foodPrice!)/\(entity.foodUnit!)");
                let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15)]
                str.addAttributes(normalAttributes, range:NSMakeRange(0,priceCount))
                lblPrice.attributedText=str
            }else{
                lblPrice.text="￥\(entity.foodPrice!)"
            }
        }
        if entity.stock != nil{
            lblStock.text="库存:\(entity.stock!)"
        }
        if entity.salesCount != nil{
            lblSold.text="已售:\(entity.salesCount!)"
        }
        if goodsbasicinfoFlag == 1{
            lblTitle.text="上架中"
            btn.setTitle("下架", for: UIControlState())
        }else if goodsbasicinfoFlag == 2{
            lblTitle.text="下架中"
            btn.setTitle("上架", for: UIControlState())
        }

    }
    @IBAction func pushGoodDetails(_ sender: UIButton) {
        if goodEntity != nil{
            delegate?.pushDetailsVC(goodEntity!)
        }else{
            delegate?.pushFoodDetailsVC(foodEntity!)
        }
    }

    @IBAction func pushUpdateGood(_ sender: AnyObject) {
        if goodEntity != nil{
            delegate?.theShelvesOperate(goodEntity!)
        }else{
            delegate?.theShelvesOperateFood(foodEntity!)
        }
    }

    @objc func pushCode(){
        delegate?.pushPrintCodeVC(goodEntity!)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


