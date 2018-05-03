//
//  ShelvesViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/3.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
///上架商品
class ShelvesViewController:BaseViewController{
    //1商品 2菜品
    var flag:Int?
    fileprivate var goodArr=[GoodEntity]()
    fileprivate var foodArr=[FoodEntity]()
    fileprivate var testStoreId=userDefaults.object(forKey: "storeId") as! Int
    fileprivate var table:UITableView!
    fileprivate var pageNumber=0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.mj_header.beginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="已上架"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-40-navHeight))
        table.delegate=self
        table.dataSource=self
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.backgroundColor=UIColor.clear
        table.tableFooterView=UIView(frame:CGRect.zero)
        table.separatorStyle = .none
        self.view.addSubview(table)
        pageNumber=1
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            if self.flag == 1{
                self.getAllGoods(self.pageNumber, pageSize:10, isRefresh:true)
            }else{
                self.getArrFoods(self.pageNumber, pageSize:10, isRefresh:true)
            }
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            if self.flag == 1{
                self.getAllGoods(self.pageNumber, pageSize:10, isRefresh:false)
            }else{
                self.getArrFoods(self.pageNumber, pageSize:10, isRefresh:false)
            }
        })
        table.mj_header.beginRefreshing()
    }
}
// MARK: - table协议
extension ShelvesViewController:UITableViewDelegate,UITableViewDataSource,GoodTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "GoodTableViewCellId") as? GoodTableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("GoodTableViewCell", owner:self,options: nil)?.last as? GoodTableViewCell
        }
        if flag == 1{
            if goodArr.count > 0{
                let entity=goodArr[indexPath.row]
                cell!.delegate=self
                cell!.updateGoodCell(entity, goodsbasicinfoFlag:1)
            }
        }else if flag == 2{
            if foodArr.count > 0{
                let entity=foodArr[indexPath.row]
                cell!.delegate=self
                cell!.updateFoodCell(entity, goodsbasicinfoFlag:1)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == 2{
            return foodArr.count
        }
        return goodArr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - 空视图协议
extension ShelvesViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        var text="还没有上架商品"
        if flag == 2{
            text="还没有上架菜品"
        }
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

// MARK: - 网络请求
extension ShelvesViewController{
    //查商品
    func getAllGoods(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.getAllGoods(flagHidden: 1, pageNumber: pageNumber, pageSize: pageSize,storeId:testStoreId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            if isRefresh{
                self.goodArr.removeAll()
            }
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(GoodEntity(), object:value.object)
                self.goodArr.append(entity!)
                count+=1
            }
            if count < 10{
                self.table.mj_footer.isHidden=true
            }else{
                self.table.mj_footer.isHidden=false
            }
            self.table.reloadData()
            self.table.mj_footer.endRefreshing()
            self.table.mj_header.endRefreshing()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
                self.table.mj_footer.endRefreshing()
                self.table.mj_header.endRefreshing()
        }
    }
    //查菜品
    func getArrFoods(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.getFoodByTestStoreId(pageNumber:pageNumber, pageSize:pageSize, testStoreId:testStoreId,flagHidden:1), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            if isRefresh{
                self.foodArr.removeAll()
            }
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(FoodEntity(), object:value.object)
                entity?.foodPrice=value["foodPrice"].stringValue
                self.foodArr.append(entity!)
                count+=1
            }
            if count < pageSize{
                self.table.mj_footer.isHidden=true
            }else{
                self.table.mj_footer.isHidden=false
            }
            self.table.reloadData()
            self.table.mj_footer.endRefreshing()
            self.table.mj_header.endRefreshing()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
                self.table.mj_footer.endRefreshing()
                self.table.mj_header.endRefreshing()

        }
    }
}
// MARK: - 逻辑操作
extension ShelvesViewController{

    func pushDetailsVC(_ entity: GoodEntity) {
        let vc=GoodDetailsViewController()
        vc.goodsbasicInfoId=entity.goodsbasicInfoId
        vc.goodName=entity.goodInfoName
        self.navigationController?.pushViewController(vc, animated:true)
    }
    func pushFoodDetailsVC(_ entity: FoodEntity) {
        let vc=FoodDetailsViewController()
        vc.foodId=entity.foodId
        self.navigationController?.pushViewController(vc, animated:true)
    }
    func theShelvesOperate(_ entity: GoodEntity) {
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.changeGoodsFlag(goodsbasicInfoId:entity.goodsbasicInfoId!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("下架成功", type: HUD.success)
                self.table.mj_header.beginRefreshing()
            }else{
                self.showSVProgressHUD("下架失败", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    func theShelvesOperateFood(_ entity: FoodEntity) {
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.foodUpDown(foodId: entity.foodId!,stock:nil), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("下架成功", type: HUD.success)
                self.table.mj_header.beginRefreshing()
            }else{
                self.showSVProgressHUD("下架失败", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    //打印
    func pushPrintCodeVC(_ entity: GoodEntity) {
        let vc=ConnectThePrinterViewController()
        vc.flag=2
        vc.goodName=entity.goodInfoName
        vc.code=entity.qrcode
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
