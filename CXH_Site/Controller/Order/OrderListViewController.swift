//
//  OrderListViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 订单
class OrderListViewController:BaseViewController{
    fileprivate var arr=[OrderEntity]()
    fileprivate var table:UITableView!
    fileprivate var menuView:UIView!
    fileprivate var pageNumber=0
    fileprivate var orderStatu=1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="我的订单"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        NotificationCenter.default.addObserver(self, selector:#selector(updateVC), name:NSNotification.Name(rawValue: "NotificationUpdateVC"), object:nil)
        buildView()
    }
    @objc func updateVC(){
        table.mj_header.beginRefreshing()
    }
    func buildView(){
        //菜单栏
        menuView=UIView(frame:CGRect(x: 0,y: navHeight,width: boundsWidth,height: 40))
        menuView.backgroundColor=UIColor.white
        self.view.addSubview(menuView)
        var btnX:CGFloat=0
        for i in  0..<5{
            let btn=UIButton(frame:CGRect(x: btnX,y: 0,width: boundsWidth/5,height: 40))
            btn.tag=i
            var title=""
            switch i{
            case 0:
                title="待付款"
                btn.isSelected=true //默认选中
                break
            case 1:
                title="待发货"
                break
            case 2:
                title="待收货"
                break
            case 3:
                title="待评价"
                break
            case 4:
                title="已完成"
                break
            default:break
            }
            btn.setTitle(title, for: UIControlState())
            btn.titleLabel!.font=UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.applicationMainColor(), for: UIControlState.selected)
            btn.setTitleColor(UIColor.black, for: UIControlState())
            btn.addTarget(self, action:#selector(selectedBtn), for: UIControlEvents.touchUpInside)
            btnX+=boundsWidth/5
            menuView.addSubview(btn)
            
        }
        table=UITableView(frame:CGRect(x: 0,y:menuView.frame.maxY,width: boundsWidth,height: boundsHeight-40-navHeight),style:.grouped)
        table.delegate=self
        table.dataSource=self
        table.emptyDataSetDelegate=self
        table.emptyDataSetSource=self
        table.backgroundColor=UIColor.clear
        table.tableFooterView=UIView(frame:CGRect.zero)
        table.separatorColor=UIColor.borderColor()
        self.view.addSubview(table)
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            self.queryOrderInfoAndGoods(self.pageNumber, pageSize:10,orderStatu:self.orderStatu, isRefresh:true)
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            self.queryOrderInfoAndGoods(self.pageNumber, pageSize:10,orderStatu:self.orderStatu,isRefresh:false)
        })
        table.mj_footer.isHidden=true
        table.mj_header.beginRefreshing()
    }
}
// MARK: - table协议
extension OrderListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "ordercell") as? OrderListTableViewCell
        if cell == nil{
            cell=OrderListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"ordercell")
        }
        cell!.layoutMargins=UIEdgeInsets.zero
        cell!.separatorInset=UIEdgeInsets.zero
        if arr.count > 0{
            if arr[indexPath.section].orderandgoods != nil{
                let entity=arr[indexPath.section].orderandgoods![indexPath.row]
                cell!.updateCell(entity)
            }
        }
        return cell!
        
    }
    //返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr.count > 0{
            if arr[section].orderandgoods != nil{
                return arr[section].orderandgoods!.count
            }
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arr.count > 0{
            return 50
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if arr.count > 0{
            return 75
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if arr.count > 0{
            let view=UIView(frame:CGRect.zero)
            view.backgroundColor=UIColor.white
            let orderSN=UILabel(frame:CGRect(x: 15,y: 15,width: 280,height: 20))
            orderSN.font=UIFont.systemFont(ofSize: 15)
            
            let entity=arr[section]
            orderSN.text="订单号:\(entity.orderSN!)"
            
            view.addSubview(orderSN)
            let border=UIView(frame:CGRect(x: 0,y: 49.5,width: boundsWidth,height: 0.5))
            border.backgroundColor=UIColor.borderColor()
            view.addSubview(border)
            let border1=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 0.5))
            border1.backgroundColor=UIColor.borderColor()
            view.addSubview(border1)
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if arr.count > 0{
            let view=UIView(frame:CGRect.zero)
            view.backgroundColor=UIColor.white
            let lblOrderPrice=UILabel(frame:CGRect(x: 0,y: 10,width: boundsWidth-15,height: 20))
            lblOrderPrice.font=UIFont.systemFont(ofSize: 15)
            lblOrderPrice.textAlignment = .right
            
            let entity=arr[section]
            let name="合计:￥\(entity.orderPrice!) (运费￥0.0)"
            let str:NSMutableAttributedString=NSMutableAttributedString(string:name);
            let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.color999(),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)]
            str.addAttributes(normalAttributes, range:NSMakeRange(name.count-8,8))
            lblOrderPrice.attributedText=str
            
            view.addSubview(lblOrderPrice)
            let border=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 0.5))
            border.backgroundColor=UIColor.borderColor()
            view.addSubview(border)
            //订单详情按钮
            let btnOrderDetails=UIButton(frame:CGRect(x: boundsWidth-95,y: lblOrderPrice.frame.maxY+5,width: 80,height: 30))
            btnOrderDetails.addTarget(self, action:#selector(pushOrderDetails), for: UIControlEvents.touchUpInside)
            btnOrderDetails.backgroundColor=UIColor.applicationMainColor()
            btnOrderDetails.setTitle("订单详情", for: UIControlState())
            btnOrderDetails.tag=section
            btnOrderDetails.setTitleColor(UIColor.white, for: UIControlState())
            btnOrderDetails.titleLabel!.font=UIFont.systemFont(ofSize: 14)
            btnOrderDetails.layer.cornerRadius=5
            view.addSubview(btnOrderDetails)
            if orderStatu == 2{
                let btnFH=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认发货", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:5)
                btnFH.frame=CGRect(x: boundsWidth-190,y: btnOrderDetails.frame.origin.y,width: 80,height: 30)
                btnFH.tag=section
                btnFH.addTarget(self, action:#selector(storeTodeliver), for: UIControlEvents.touchUpInside)
                view.addSubview(btnFH)

            }
            return view
        }
        return nil
    }
}

// MARK: - 空视图协议
extension OrderListViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="没有相关订单"
        let attributes=[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.darkGray]
        return NSAttributedString(string:text, attributes:attributes)
    }
    //设置文字和图片间距
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 10
    }
    //    //设置垂直偏移量
    //    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView) -> CGFloat {
    //        return -30
    //    }
    //设置是否滑动
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint.zero
    }
}
// MARK: - 页面逻辑
extension OrderListViewController{
    //切换数据源
    @objc func selectedBtn(_ sender:UIButton){
        for(view) in menuView.subviews{//拿到所有按钮 设置按钮状态为未选中
            if view.isKind(of: UIButton.self){
                let btn=view as! UIButton
                btn.isSelected=false
            }
        }
        sender.isSelected=true //设置当前按钮状态为选中
        switch sender.tag{
        case 0:
            orderStatu=1
            break
        case 1:
            orderStatu=2
            break
        case 2:
            orderStatu=3
            break
        case 3:
            orderStatu=4
            break
        case 4:
            orderStatu=5
            break
        default:break
        }
        self.table.mj_header.beginRefreshing()
    }
    /**
     跳转订单详情页面
     
     - parameter sender: 
     */
    @objc func pushOrderDetails(_ sender:UIButton){
        let entity=arr[sender.tag]
        let vc=OrderDetailsViewController()
        vc.orderInfoId=entity.orderInfoId
        self.navigationController?.pushViewController(vc, animated:true)
    }
    /**
     确认发货
     
     - parameter sender:
     */
    @objc func storeTodeliver(_ sender:UIButton){
        let entity=arr[sender.tag]
        let vc=TheDeliveryViewController()
        vc.orderInfoId=entity.orderInfoId
        vc.province=entity.province
        vc.city=entity.city
        self.navigationController?.pushViewController(vc,animated:true)
    }

}
// MARK: - 网络请求
extension OrderListViewController{
    func queryOrderInfoAndGoods(_ pageNumber:Int,pageSize:Int,orderStatu:Int,isRefresh:Bool){
        let storeId=userDefaults.object(forKey: "storeId") as! Int
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryOrderInfoAndGoods(storeId:storeId, pageNumber: pageNumber, pageSize: pageSize, orderStatu:orderStatu), successClosure: { (result) -> Void in
            if isRefresh{
                self.arr.removeAll()
            }
            let json=self.swiftJSON(result)
            for(_,value) in json["list"]{
                let orderEntity=self.jsonMappingEntity(OrderEntity(), object: value.object)
                var goodArr=[GoodEntity]()
                for(_,goodValue) in value["orderandgoods"]{
                    let goodEntity=self.jsonMappingEntity(GoodEntity(), object:goodValue.object)
                    goodArr.append(goodEntity!)
                }
                orderEntity!.orderandgoods=goodArr
                self.arr.append(orderEntity!)
                count+=1
            }
            if count < pageSize{
                self.table.mj_footer.isHidden=true
            }else{
                self.table.mj_footer.isHidden=false
            }
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
        }
    }
}
