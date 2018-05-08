//
//  SearchInboxViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/8.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 搜索快件
class SearchInboxViewController:BaseViewController {
    fileprivate var table:UITableView!
    fileprivate var arr=[ExpressmailStorageEntity]()
    fileprivate var pageNumber=1
    fileprivate let identity=userDefaults.object(forKey: "identity") as! Int
    fileprivate let userId=userDefaults.object(forKey: "userId") as! Int
    fileprivate var time=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="搜索快件"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
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
                self.searchCollectHistoryForStoreBystoreUserCtime(self.userId, startTime: self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:true)
            }else if self.identity == 3{
                self.searchCollectHistoryForDriverByDriverUserCtime(self.userId, startTime: self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:true)
            }
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            if self.identity == 2{
                self.searchCollectHistoryForStoreBystoreUserCtime(self.userId, startTime: self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:false)
            }else if self.identity == 3{
                self.searchCollectHistoryForDriverByDriverUserCtime(self.userId, startTime: self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:false)
            }
        })
        table.mj_footer.isHidden=true
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"选择时间", style: UIBarButtonItemStyle.done, target:self, action:#selector(selectData))
        
    }
    @objc func selectData(){
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message:nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        // 初始化 datePicker
        let datePicker = UIDatePicker( )
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        // 设置样式，当前设为同时显示日期和时间
        datePicker.datePickerMode = UIDatePickerMode.date
        // 设置默认时间
        datePicker.date = Date()
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default){
            (alertAction)->Void in
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat="yyyy-MM-dd"
            self.time=dateFormatter.string(from: datePicker.date)
            self.table.mj_header.beginRefreshing()
        })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
extension SearchInboxViewController:UITableViewDelegate,UITableViewDataSource,InboxTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "sid") as? InboxTableViewCell
        if cell == nil{
            //加载xib
            cell=InboxTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"sid")
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
extension SearchInboxViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="请按时间搜索快件"
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
extension SearchInboxViewController{
    //搜索站点收件信息
    func searchCollectHistoryForStoreBystoreUserCtime(_ userId:Int,startTime:String,endTime:String,pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.searchCollectHistoryForStoreBystoreUserCtime(userId: userId, startTime: startTime, endTime: endTime, pageNumber: pageNumber, pageSize: pageSize), successClosure: { (result) -> Void in
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
    //搜索司机收件信息
    func searchCollectHistoryForDriverByDriverUserCtime(_ userId:Int,startTime:String,endTime:String,pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.searchCollectHistoryForDriverByDriverUserCtime(userId: userId, startTime: startTime, endTime: endTime, pageNumber: pageNumber, pageSize: pageSize), successClosure: { (result) -> Void in
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
}
// MARK: - 页面逻辑
extension SearchInboxViewController{
    func pushDetails(_ entity: ExpressmailStorageEntity) {
        
    }
    func storeReturn(_ entity: ExpressmailStorageEntity) {
        
    }
    func replaceSignForUser(_ entity: ExpressmailStorageEntity) {
        
    }
    
}
