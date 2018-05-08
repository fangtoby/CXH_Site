//
//  StoreInboxViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/21.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 站点包list
class StoreInboxViewController:BaseViewController{
    //接收物流包id
    var logisticsPackId:Int?
    fileprivate var table:UITableView!
    fileprivate var arr=[ExpressmailStorageEntity]()
    fileprivate var pageNumber=0
    fileprivate let userId=userDefaults.object(forKey: "userId") as! Int
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.mj_header.beginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="收件站点包"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.emptyDataSetDelegate=self
        table.emptyDataSetSource=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        table.backgroundColor=UIColor.clear
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            if self.logisticsPackId != nil{
                self.http(self.pageNumber, pageSize:10,isRefresh:true)
            }else{
                self.queryCollectHistoryForStorepackByStoreUserId(self.pageNumber, pageSize:10,isRefresh:true)
            }
            
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            if self.logisticsPackId != nil{
                self.http(self.pageNumber, pageSize:10,isRefresh:false)
            }else{
                self.queryCollectHistoryForStorepackByStoreUserId(self.pageNumber, pageSize:10,isRefresh:false)
            }
            
        })
        table.mj_footer.isHidden=true
        table.mj_header.beginRefreshing()
    }
}
// MARK: - table协议
extension StoreInboxViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "sid") as? StoreListTableViewCell
        if cell == nil{
            //加载xib
            cell=StoreListTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"sid")
        }
        cell!.accessoryType = .disclosureIndicator
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.updateCell(entity)
            
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity=arr[indexPath.row]
        let vc=InboxListViewController()
        vc.storePackId=entity.storePackId
        self.navigationController?.pushViewController(vc, animated:true)
        
    }
}
// MARK: - 空视图协议
extension StoreInboxViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="还没有站点包"
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
extension StoreInboxViewController{
    func http(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCollectHistoryForDriverForStorepackByLogisticsPackId(logisticsPackId:logisticsPackId!,pageNumber:pageNumber,pageSize:pageSize), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print("司机站点包:\(json)")
            if isRefresh{
                self.arr.removeAll()
            }
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(ExpressmailStorageEntity(), object:value.object)
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
    //收件历史（站点）--查询站点包
    func queryCollectHistoryForStorepackByStoreUserId(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCollectHistoryForStorepackByStoreUserId(userId:userId, pageNumber: pageNumber, pageSize: pageSize), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print("站点包:\(json)")
            if isRefresh{
                self.arr.removeAll()
            }
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(ExpressmailStorageEntity(), object:value.object)
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
}
