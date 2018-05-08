//
//  StorePrepaidrecordViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 充值记录
class StorePrepaidrecordViewController:BaseViewController{
    fileprivate var table:UITableView!
    fileprivate var arr=[StorePrepaidrecordEntity]()
    fileprivate var pageNumber=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="充值记录"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        let storeId=userDefaults.object(forKey: "storeId") as! Int
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            self.queryStorePrepaidrecord(storeId,pageNumber: self.pageNumber, pageSize:10, isRefresh:true)
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            self.queryStorePrepaidrecord(storeId,pageNumber: self.pageNumber, pageSize:10, isRefresh:false)
        })
        table.mj_footer.isHidden=true
        self.table.mj_header.beginRefreshing()
        
    }
}
// MARK: - table协议
extension StorePrepaidrecordViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "ssid") as? StorePrepaidrecordTableViewCell
        if cell == nil{
            cell=StorePrepaidrecordTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"ssid")
        }
        if self.arr.count > 0{
            cell!.updateCell(arr[indexPath.row])
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
}

// MARK: - 空视图协议
extension StorePrepaidrecordViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="还没有充值记录"
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
extension StorePrepaidrecordViewController{
    func queryStorePrepaidrecord(_ storeId:Int,pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStorePrepaidrecord(storeId:storeId, pageNumber: pageNumber, pageSize: pageSize), successClosure: { (result) -> Void in
            if isRefresh{
                self.arr.removeAll()
            }
            let json=self.swiftJSON(result)
            print("充值记录\(json)")
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(StorePrepaidrecordEntity(), object:value.object)
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
