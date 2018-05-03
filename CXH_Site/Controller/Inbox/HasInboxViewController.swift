//
//  HasInboxViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 已收件
class HasInboxViewController:BaseViewController{
    fileprivate var table:UITableView!
    fileprivate var arr=[ExpressmailStorageEntity]()
    fileprivate var pageNumber=0
    fileprivate let identity=userDefaults.object(forKey: "identity") as! Int
    fileprivate let userId=userDefaults.object(forKey: "userId") as! Int
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.mj_header.beginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="已收件"
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
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            if self.identity == 2{
                self.queryCollectHistory(self.pageNumber, pageSize:10,isRefresh:true)
            }else if self.identity == 3{
                self.queryCollectHistoryForDriver(self.pageNumber, pageSize:10,isRefresh:true)
            }
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            if self.identity == 2{
                self.queryCollectHistory(self.pageNumber, pageSize:10,isRefresh:false)
            }else if self.identity == 3{
                self.queryCollectHistoryForDriver(self.pageNumber, pageSize:10,isRefresh:false)
            }
        })
        table.mj_header.beginRefreshing()
    }
}
extension HasInboxViewController:UITableViewDelegate,UITableViewDataSource,InboxTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "id") as? InboxTableViewCell
        if cell == nil{
            //加载xib
            cell=InboxTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"id")
        }
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.delegate=self
            cell!.updateCell(entity,identity:identity)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - 空视图协议
extension HasInboxViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="还没有已收件"
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
extension HasInboxViewController{
    //站点收件
    func queryCollectHistory(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        let userId=userDefaults.object(forKey: "userId") as! Int
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCollectHistory(userId:userId, pageNumber: pageNumber, pageSize: pageSize,statu:5), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
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
    //司机收件信息
    func queryCollectHistoryForDriver(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        let userId=userDefaults.object(forKey: "userId") as! Int
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCollectHistoryForDriver(userId:userId, pageNumber: pageNumber, pageSize: pageSize,statu:3), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print("司机已收件:\(json)")
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
// MARK: - 逻辑
extension HasInboxViewController{
    func pushDetails(_ entity: ExpressmailStorageEntity) {
        let vc=InboxDetailsViewController()
        vc.entity=entity
        self.navigationController?.pushViewController(vc, animated:true)
    }
    func storeReturn(_ entity: ExpressmailStorageEntity) {
    }
    func replaceSignForUser(_ entity: ExpressmailStorageEntity) {
        
    }
}
