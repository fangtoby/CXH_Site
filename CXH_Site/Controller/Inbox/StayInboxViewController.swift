//
//  StayInboxViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 待收件
class StayInboxViewController:BaseViewController {
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
        self.title="待收件"
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
        table.mj_footer.isHidden=true
        table.mj_header.beginRefreshing()
    }
}
extension StayInboxViewController:UITableViewDelegate,UITableViewDataSource,InboxTableViewCellDelegate{
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
extension StayInboxViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="还没有待收件"
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
extension StayInboxViewController{
    //站点收件信息
    func queryCollectHistory(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        let userId=userDefaults.object(forKey: "userId") as! Int
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCollectHistory(userId:userId, pageNumber: pageNumber, pageSize: pageSize,statu:3), successClosure: { (result) -> Void in
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
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCollectHistoryForDriver(userId:userId, pageNumber: pageNumber, pageSize: pageSize,statu:2), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            //print("司机待收件:\(json)")
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
// MARK: - 逻辑操作
extension StayInboxViewController{
    /**
     跳转详情页面
     
     - parameter entity:
     */
    func pushDetails(_ entity: ExpressmailStorageEntity) {
        let vc=InboxDetailsViewController()
        vc.entity=entity
        self.navigationController?.pushViewController(vc, animated:true)
    }
    //返件
    func storeReturn(_ entity: ExpressmailStorageEntity) {
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeReturn(userId:userId, expressmailStorageId:entity.expressmailStorageId!, identity: identity), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                if self.identity == 2{
                    self.showSVProgressHUD("返件成功,请等待司机接收", type: HUD.success)
                }else if self.identity == 3{
                    self.showSVProgressHUD("返件成功,请等待仓库接收", type: HUD.success)
                }
                self.table.mj_header.beginRefreshing()
            }else if success == "exist"{
                self.showSVProgressHUD("此快件已经申请返件了", type: HUD.info)
            }else if success == "haveNoRight"{
                self.showSVProgressHUD("此快件不能返件", type: HUD.info)
            }else{
                self.showSVProgressHUD("返件失败", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }

    }
    //待签收
    func replaceSignForUser(_ entity: ExpressmailStorageEntity) {
        
    }
    
}
