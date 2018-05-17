//
//  OrderDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 订单详情
class OrderDetailsViewController:BaseViewController{
    //接收订单id
    var orderInfoId:Int?
    //接收订单状态
    var orderStatu:Int?
    fileprivate var table:UITableView!
    //保存订单详情数据
    fileprivate var orderDetailsEntity:OrderDetailsEntity?
    fileprivate var lblTotalPrice:UILabel!
    fileprivate var btnOrdering:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="订单详情"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
//        if orderStatu == 3{
//            self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"查看物流", style: UIBarButtonItemStyle.done, target:self, action:#selector(pushRecruitment))
//        }
        queryOrderDetailsInfoAndGoods()
    }
//    /**
//     跳转查看物流
//     */
//    @objc func pushRecruitment(){
//        let vc=PublicRecruitmentViewController()
//        vc.orderInfoId=orderInfoId
//        self.navigationController?.pushViewController(vc, animated:true)
//    }
}
// MARK: - 网络请求
extension OrderDetailsViewController{
    func queryOrderDetailsInfoAndGoods(){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryOrderDetailsInfoAndGoods(orderInfoId:orderInfoId!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            self.orderDetailsEntity=self.jsonMappingEntity(OrderDetailsEntity(), object:json.object)
            var goodArr=[GoodEntity]()
            for(_,value) in json["orderAndGoods"]{
                let entity=self.jsonMappingEntity(GoodEntity(), object:value.object)
                
                goodArr.append(entity!)
            }
            self.orderDetailsEntity!.orderAndGoods=goodArr
            self.dismissHUD()
            self.buildView()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
// MARK: - 构建页面
extension OrderDetailsViewController{
    func buildView(){
        table=UITableView(frame:CGRect(x: 0,y: navHeight,width: boundsWidth,height: boundsHeight-50-navHeight))
        table.delegate=self
        table.dataSource=self
        table.backgroundColor=UIColor.clear
        table.separatorColor = UIColor.borderColor()
        //移除空单元格
        table.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        /// 订单视图
        let orderingView=UIView(frame:CGRect(x: 0,y: boundsHeight-50,width: boundsWidth,height: 50))
        orderingView.backgroundColor=UIColor.white
        lblTotalPrice=UILabel(frame:CGRect(x: 15,y: 15,width: boundsWidth/3*2-30,height: 20))
        lblTotalPrice!.text="实付款 : ￥\(self.orderDetailsEntity!.orderPrice!)"
        lblTotalPrice!.font=UIFont.systemFont(ofSize: 14)
        orderingView.addSubview(lblTotalPrice!)
        
        //        //下单按钮
        //        btnOrdering=UIButton(frame:CGRectMake(orderingView.frame.width/3*2,0,orderingView.frame.width/3,50))
        //        btnOrdering!.backgroundColor=UIColor.applicationMainColor()
        //        btnOrdering!.setTitle("去下单", forState: UIControlState.Normal)
        //        btnOrdering!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //        btnOrdering!.titleLabel!.font=UIFont.systemFontOfSize(15)
        //        btnOrdering!.addTarget(self, action:"submitOrder", forControlEvents: UIControlEvents.TouchUpInside);
        //        orderingView.addSubview(btnOrdering!)
        
        
        self.view.addSubview(orderingView)
    }
}
// MARK: - table协议
extension OrderDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="cell id"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellId)
        }else{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellId)
        }
        cell!.layoutMargins=UIEdgeInsets.zero
        cell!.separatorInset=UIEdgeInsets.zero;
        switch indexPath.section{
        case 0:
            let orderSN=UILabel(frame:CGRect(x: 15,y: 15,width: 270,height: 20))
            orderSN.font=UIFont.systemFont(ofSize: 15)
            orderSN.text="订单号:\(self.orderDetailsEntity!.orderSN!)"
            cell!.contentView.addSubview(orderSN)
            break
        case 1:
            let shippName=UILabel(frame:CGRect(x: 15,y: 15,width: boundsWidth/2-15,height: 20))
            shippName.font=UIFont.systemFont(ofSize: 14)
            if self.orderDetailsEntity!.shippName != nil{
                shippName.text="收货人:"+self.orderDetailsEntity!.shippName!
            }
            cell!.contentView.addSubview(shippName)
            let tel=UILabel(frame:CGRect(x: boundsWidth/2,y: 15,width: boundsWidth/2-15,height: 20))
            tel.text=self.orderDetailsEntity!.tel
            tel.font=UIFont.systemFont(ofSize: 14)
            tel.textAlignment = .right
            cell!.contentView.addSubview(tel)
            let size=self.orderDetailsEntity!.shipaddress!.textSizeWithFont(UIFont.systemFont(ofSize: 13), constrainedToSize:CGSize(width:boundsWidth-30,height:60))
            let address=UILabel(frame:CGRect(x: 15,y: shippName.frame.maxY+5,width: boundsWidth-30,height: size.height))
            address.text="收货地址:"+self.orderDetailsEntity!.shipaddress!
            address.font=UIFont.systemFont(ofSize: 13)
            address.numberOfLines=0
            address.lineBreakMode = .byWordWrapping
            address.textColor=UIColor.color999()
            cell!.contentView.addSubview(address)
            
            break
        case 2:
            let entity=self.orderDetailsEntity!.orderAndGoods![indexPath.row]
            let goodImg=UIImageView(frame:CGRect(x: 15,y: 15,width: 90,height: 90))
            goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "default_icon"))
            cell!.contentView.addSubview(goodImg)
            let lblGoodName=UILabel(frame:CGRect(x: goodImg.frame.maxX+5,y: 5,width: boundsWidth-(goodImg.frame.maxX+5)-15,height: 40))
            lblGoodName.textColor=UIColor.RGBFromHexColor("#333333")
            if entity.retailOrWholesaleFlag == 2{
                let goodName="[批发商品]"+(entity.goodInfoName ?? "")
                let str:NSMutableAttributedString=NSMutableAttributedString(string:goodName);
                let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font:UIFont.systemFont(ofSize:14)]
                str.addAttributes(normalAttributes, range:NSMakeRange(0,6))
                lblGoodName.attributedText=str
            }else{
                lblGoodName.text=entity.goodInfoName
            }
            lblGoodName.font=UIFont.systemFont(ofSize: 14)
            lblGoodName.lineBreakMode=NSLineBreakMode.byWordWrapping
            lblGoodName.numberOfLines=2

            cell!.contentView.addSubview(lblGoodName)
            
            let lblPriceOfWeight=UILabel(frame:CGRect(x: goodImg.frame.maxX+5,y: 85,width: 200,height: 20))
            lblPriceOfWeight.font=UIFont.systemFont(ofSize: 15)
            lblPriceOfWeight.textColor=UIColor.RGBFromHexColor("#666666")
            let priceCount="\(entity.goodsPrice!)".count
            let str:NSMutableAttributedString=NSMutableAttributedString(string:"￥\(entity.goodsPrice!)/\(entity.goodUnit!)");
            let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 20)]
            str.addAttributes(normalAttributes, range:NSMakeRange(0,priceCount+1))
            lblPriceOfWeight.attributedText=str
            cell!.contentView.addSubview(lblPriceOfWeight)
            
            let lblGoodCount=UILabel(frame:CGRect(x: lblPriceOfWeight.frame.maxX,y: lblPriceOfWeight.frame.origin.y,width: boundsWidth-lblPriceOfWeight.frame.maxX-15,height: 20))
            lblGoodCount.text="x\(entity.goodsCount!)"
            lblGoodCount.textAlignment = .right
            lblGoodCount.textColor=UIColor.color333()
            lblGoodCount.font=UIFont.systemFont(ofSize: 16)
            cell!.contentView.addSubview(lblGoodCount)
            break
        case 3:
            let name=UILabel(frame:CGRect(x: 15,y: 15,width: 70,height: 20))
            name.textColor=UIColor.color333()
            name.font=UIFont.systemFont(ofSize: 14)
            cell!.contentView.addSubview(name)
            let nameValue=UILabel(frame:CGRect(x: 100,y: 15,width: boundsWidth-100-15,height: 20))
            nameValue.font=UIFont.systemFont(ofSize: 14)
            nameValue.textColor=UIColor.textColor()
            nameValue.textAlignment = .right
            cell!.contentView.addSubview(nameValue)
            switch indexPath.row{
            case 0:
                name.text="支付方式"
                nameValue.text="在线支付"
                break
            case 1:
                name.text="运送方式"
                nameValue.text="城乡快递"
                break
            case 2:
                name.text="发票信息"
                if self.orderDetailsEntity!.invoiceName != nil{
                    nameValue.text=self.orderDetailsEntity!.invoiceName
                }else{
                    nameValue.text="不开发票"
                }
                break
            case 3:
                name.text="买家留言"
                if self.orderDetailsEntity!.payMessage != nil{
                    nameValue.frame=CGRect(x: 100,y: 15,width: boundsWidth-100-25,height: 20)
                    nameValue.text=self.orderDetailsEntity!.payMessage
                    cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                }else{
                    nameValue.text="无"
                }
                break
            case 4:
                if orderStatu! > 3{
                    name.text="收货时间"
                    nameValue.text=self.orderDetailsEntity!.receiptTime
                }else{
                    name.text="下单时间"
                    nameValue.text=self.orderDetailsEntity!.addTime
                }
            default:break
            }
            break
        default:break
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 50
        case 1:
            let size=self.orderDetailsEntity!.shipaddress!.textSizeWithFont(UIFont.systemFont(ofSize: 13), constrainedToSize:CGSize(width:boundsWidth-30,height:60))
            return 55+size.height
        case 2:
            return 120
        case 3:
            return 50
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.orderDetailsEntity!.orderAndGoods!.count
        case 3:
            return 5
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 50
        }else if section != 1{
            return 5
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2{
            let view=UIView(frame:CGRect.zero)
            view.backgroundColor=UIColor.white
            let name=UILabel(frame:CGRect(x: 15,y: 15,width: 200,height: 20))
            name.text="商品列表"
            name.font=UIFont.systemFont(ofSize: 16)
            view.addSubview(name)
            let borderView=UIView(frame:CGRect(x: 0,y: 49.5,width: boundsWidth,height: 0.5))
            borderView.backgroundColor=UIColor.borderColor()
            view.addSubview(borderView)
            return view
        }else{
            let view=UIView(frame:CGRect.zero)
            view.backgroundColor=UIColor.viewBackgroundColor()
            return view
        }
    }
    //给每个组的尾部添加视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2{
            let view=UIView(frame:CGRect.zero)
            view.backgroundColor=UIColor.white
            let lblYf=UILabel(frame:CGRect(x: 15,y:5,width: (boundsWidth-30)/2,height:20))
            lblYf.text="运费:￥0"
            lblYf.font=UIFont.systemFont(ofSize: 13)
            lblYf.textColor=UIColor.color666()
            view.addSubview(lblYf)
            //订单总佣金
            let lblOrderComment=buildLabel(UIColor.color666(), font:13, textAlignment: NSTextAlignment.right)
            lblOrderComment.frame=CGRect.init(x:lblYf.frame.maxX, y:5, width:(boundsWidth-30)/2, height:20)
            lblOrderComment.text="佣金:￥\(self.orderDetailsEntity!.orderComment ?? "0")"
            view.addSubview(lblOrderComment)
            //订单总分享费用
            let lblOrderShareSumPrice=buildLabel(UIColor.color666(),font:13, textAlignment: NSTextAlignment.left)
            lblOrderShareSumPrice.frame=CGRect(x: 15,y:lblYf.frame.maxY+5,width: (boundsWidth-30)/2,height:20)
            lblOrderShareSumPrice.text="分享费:￥\(self.orderDetailsEntity!.orderShareSumPrice ?? "0")"
            view.addSubview(lblOrderShareSumPrice)
            ///订单总价
            let lblMoblieSumPrice=UILabel(frame:CGRect(x: lblYf.frame.maxX,y: lblYf.frame.maxY+5,width:(boundsWidth-30)/2,height: 20))
            lblMoblieSumPrice.textAlignment = .right
            lblMoblieSumPrice.font=UIFont.systemFont(ofSize: 14)
            lblMoblieSumPrice.textColor=UIColor.color333()
            let priceCount="\(self.orderDetailsEntity!.orderPrice!)".count
            let str:NSMutableAttributedString=NSMutableAttributedString(string:"合计:\(self.orderDetailsEntity!.orderPrice!)");
            let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15)]
            str.addAttributes(normalAttributes, range:NSMakeRange(3,priceCount))
            lblMoblieSumPrice.attributedText=str
            view.addSubview(lblMoblieSumPrice)
            let borderView=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 0.5))
            borderView.backgroundColor=UIColor.borderColor()
            view.addSubview(borderView)
            return view
        }else{
            let view=UIView(frame:CGRect.zero)
            view.backgroundColor=UIColor.viewBackgroundColor()
            return view
        }
    }
    //给每个分组的尾部设置5高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 55
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        switch indexPath.section{
        case 3:
            if indexPath.row == 3{
                if self.orderDetailsEntity!.payMessage != nil{
                    UIAlertController.showAlertYes(self, title:"买家留言", message:self.orderDetailsEntity!.payMessage, okButtonTitle:"确定")
                }
            }
            break
        default:break
            
        }
    }
}
