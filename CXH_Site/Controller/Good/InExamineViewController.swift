//
//  InExamineViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/3.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 审核中
class InExamineViewController:BaseViewController {
    fileprivate var arr=[GoodEntity]()
    fileprivate var table:UITableView!
    fileprivate var pageNumber=0
    fileprivate var storeId=userDefaults.object(forKey: "storeId") as! Int
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.mj_header.beginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="审核中"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-40-navHeight))
        table.delegate=self
        table.dataSource=self
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        table.backgroundColor=UIColor.clear
        table.separatorStyle = .none
        self.view.addSubview(table)
        pageNumber=1
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            self.getAllGoods(self.pageNumber, pageSize:10, isRefresh:true)
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            self.getAllGoods(self.pageNumber, pageSize:10, isRefresh:false)
        })
        table.mj_footer.isHidden=true
        table.mj_header.beginRefreshing()
    }
}
// MARK: - table协议
extension InExamineViewController:UITableViewDelegate,UITableViewDataSource,GoodTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "GoodTableViewCellId") as? GoodTableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("GoodTableViewCell", owner:self,options: nil)?.last as? GoodTableViewCell
        }
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.delegate=self
            cell!.updateGoodCell(entity, goodsbasicinfoFlag:3)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - 空视图协议
extension InExamineViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="还没有审核商品"
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
extension InExamineViewController{
    func getAllGoods(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.getAllGoods(flagHidden: 3, pageNumber: pageNumber, pageSize: pageSize,storeId:storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            if isRefresh{
                self.arr.removeAll()
            }
            print(json)
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(GoodEntity(), object:value.object)
                self.arr.append(entity!)
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
    func pushFoodDetailsVC(_ entity: FoodEntity) {
        let vc=FoodDetailsViewController()
        vc.foodId=entity.foodId
        self.navigationController?.pushViewController(vc, animated:true)
    }

    func pushDetailsVC(_ entity: GoodEntity) {
        let vc=GoodDetailsViewController()
        vc.goodsbasicInfoId=entity.goodsbasicInfoId
        vc.goodName=entity.goodInfoName
        vc.flag=2
        self.navigationController?.pushViewController(vc, animated:true)
    }
    func theShelvesOperate(_ entity: GoodEntity) {}
    func theShelvesOperateFood(_ entity: FoodEntity) {
    }
    func pushPrintCodeVC(_ entity: GoodEntity) {
        
        
    }
}
