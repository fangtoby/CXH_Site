//
//  CourierUpdateListViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/24.
//  Copyright © 2017年 zltx. All rights reserved.
//
import Foundation
import UIKit
import MJRefresh
/// 揽件修改历史
class CourierUpdateListViewController:BaseViewController{
    fileprivate var arr=[ExpressmailUpdateEntity]()
    fileprivate var table:UITableView!
    fileprivate var pageNumber=0
    fileprivate let storeId=userDefaults.object(forKey: "storeId") as! Int
    fileprivate let userId=userDefaults.object(forKey: "userId") as! Int
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.mj_header.beginRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="揽件修改历史"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
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
            self.storeQueryExpressmailUpdateInfo(self.pageNumber, pageSize:10,isRefresh:true)
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            self.storeQueryExpressmailUpdateInfo(self.pageNumber, pageSize:10,isRefresh:false)
        })
        self.table.mj_header.beginRefreshing()
        
    }
}
// MARK: - table协议
extension CourierUpdateListViewController:UITableViewDelegate,UITableViewDataSource,CourierUpdateListTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "id") as? CourierUpdateListTableViewCell
        if cell == nil{
            cell=CourierUpdateListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"id")
        }
        if self.arr.count > 0{
            cell!.delegate=self
            cell!.updateCell(arr[indexPath.row])
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
}
// MARK: - 空视图协议
extension CourierUpdateListViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="还没有揽件修改"
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
extension CourierUpdateListViewController{
    func storeQueryExpressmailUpdateInfo(_ pageNumber:Int,pageSize:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeQueryExpressmailUpdateInfo(storeId: storeId, pageNumber: pageNumber, pageSize: pageSize), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            if isRefresh{
                self.arr.removeAll()
            }
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(ExpressmailUpdateEntity(), object: value.object)
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
    func pushDetails(_ entity: ExpressmailUpdateEntity) {
        let vc=CourierDetailsViewController()
        vc.expressmailId=entity.expressmailUpdateExpressmailId
        self.navigationController?.pushViewController(vc, animated:true)
    }
    func confirmUpdate(_ entity: ExpressmailUpdateEntity) {
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeConfirmUpdateExpressmailInfo(storeId:storeId,expressmailUpdateRecordId: entity.expressmailUpdateRecordId!, userId:userId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("确认成功", type: HUD.success)
                self.table.mj_header.beginRefreshing()
            }else if success == "capitalSumMoney"{
                self.showSVProgressHUD("余额不足", type: HUD.info)
            }else if success == "capitalSumMoneyFail"{
                self.showSVProgressHUD("资金扣除失败", type: HUD.info)
            }else if success == "notExist"{
                self.showSVProgressHUD("修改记录不存在", type: HUD.info)
            }else{
                self.showSVProgressHUD("确认失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
            self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
