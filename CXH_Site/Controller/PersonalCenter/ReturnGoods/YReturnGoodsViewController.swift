//
//  YReturnGoodsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 已确认退货
class YReturnGoodsViewController:BaseViewController{
    fileprivate var table:UITableView!
    fileprivate var arr=[ReturnGoodsEntity]()
    fileprivate var pageNumber=0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.mj_header.beginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="已退款"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-40-navHeight))
        table.delegate=self
        table.dataSource=self
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.backgroundColor=UIColor.clear
        table.separatorStyle = .none
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            self.storeQueryReturngoodsapply(self.pageNumber, pageSize:10, isRefresh:true)
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            self.storeQueryReturngoodsapply(self.pageNumber, pageSize:10, isRefresh:false)
        })
        table.mj_footer.isHidden=true
        self.table.mj_header.beginRefreshing()
        
    }
}
// MARK: - table协议
extension YReturnGoodsViewController:UITableViewDelegate,UITableViewDataSource,ReturnGoodsTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "id") as? ReturnGoodsTableViewCell
        if cell == nil{
            cell=ReturnGoodsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"id")
        }
        if self.arr.count > 0{
            cell!.delegate=self
            cell!.updateCell(arr[indexPath.row],flag:1)
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
}
// MARK: - 空视图协议
extension YReturnGoodsViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="还没有已退款信息"
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
extension YReturnGoodsViewController{
    func storeQueryReturngoodsapply(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        let storeId=userDefaults.object(forKey: "storeId") as! Int
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeQueryReturngoodsapply(storeId:storeId, statu:4, pageNumber:pageNumber, pageSize: pageSize), successClosure: { (result) -> Void in
            if isRefresh{
                self.arr.removeAll()
            }
            let json=self.swiftJSON(result)
            print(json)
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(ReturnGoodsEntity(), object:value.object)
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
    func confirmedReturn(_ entity: ReturnGoodsEntity) {
        
    }
    func pushDetails(_ entity: ReturnGoodsEntity) {
        let vc=OrderDetailsViewController()
        vc.orderInfoId=entity.orderInfoId
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

