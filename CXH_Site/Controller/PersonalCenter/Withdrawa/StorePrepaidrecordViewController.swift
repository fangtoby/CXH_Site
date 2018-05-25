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
    private var screeningView:UIView!
    private var screeningTable:UITableView!
    private var screeningArr=["后台管理人员充值","系统返回销售金额","系统返回快递费","系统返回物流费","退件退回快递费","全部"]
    ///充值类型；默认1为后台管理人员充值；2为系统返回销售金额；3为系统返回快递费
    private var statu:Int?
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
        self.navigationItem.rightBarButtonItem=UIBarButtonItem.init(image:UIImage.init(named:"filter")?.reSizeImage(reSize: CGSize.init(width:30, height:30)), style: UIBarButtonItemStyle.done, target:self, action: #selector(showScreeningTable))
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
        
        setUpScreeningTableView()

    }
    ///设置筛选table
    private func setUpScreeningTableView(){
        screeningView=UIView(frame:CGRect.init(x:0,y:64,width:boundsWidth, height:boundsHeight-64))
        screeningView.backgroundColor = UIColor.init(white:0, alpha:0.5)
        screeningView.isUserInteractionEnabled=true
        let gesture=UITapGestureRecognizer(target:self, action:#selector(hideScreeningTableView))
        gesture.delegate=self
        screeningView.addGestureRecognizer(gesture)
        self.view.addSubview(screeningView)
        screeningTable=UITableView(frame:CGRect.init(x:0,y:-(self.screeningArr.count*50),width:Int(boundsWidth), height:self.screeningArr.count*50),style:UITableViewStyle.plain)
        screeningTable.delegate=self
        screeningTable.dataSource=self
        screeningTable.tag=100
        screeningTable.isScrollEnabled=false
        screeningView.addSubview(screeningTable)
        screeningView.isHidden=true
    }
    @objc private func showScreeningTable(){
        if self.screeningView.isHidden == true{
            showScreeningTableView()
        }else{
            hideScreeningTableView()
        }
    }
    ///显示筛选view
    private func showScreeningTableView(){
        self.screeningView.isHidden=false
        UIView.animate(withDuration:0.3, delay:0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.screeningTable.frame=CGRect.init(x:0,y:0, width:Int(boundsWidth),height:self.screeningArr.count*50)
        })
    }
    ///隐藏筛选view
    @objc private func hideScreeningTableView(){
        UIView.animate(withDuration:0.3, delay:0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.screeningTable.frame=CGRect.init(x:0, y:-self.screeningArr.count*50,width:Int(boundsWidth),height:self.screeningArr.count*50)

        }, completion:{ (b) in
            self.screeningView.isHidden=true
        })
    }
}
///监听view点击事件
extension StorePrepaidrecordViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView"{
            return false
        }
        if touch.view != screeningView{
            return false
        }
        return true
    }
}
// MARK: - table协议
extension StorePrepaidrecordViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100{
            var cell=tableView.dequeueReusableCell(withIdentifier:"id")
            if cell == nil{
                cell=UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier:"id")
            }
            cell!.accessoryType = .disclosureIndicator
            cell!.textLabel!.font=UIFont.systemFont(ofSize:14)
            cell!.textLabel!.text=screeningArr[indexPath.row]
            return cell!
        }
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
        if tableView.tag == 100{
            return 50
        }
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100{
            return screeningArr.count
        }
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中效果颜色
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.tag == 100{
            if indexPath.row == 5{//全部
                self.statu=nil
            }else{
                self.statu=indexPath.row+1
            }
            self.table.mj_header.beginRefreshing()
            self.hideScreeningTableView()
        }else{
            let entity=arr[indexPath.row]
            if entity.prepaidType == 2{//只查看订单类型记录
                let vc=StorePrepaidrecordDetailViewController()
                vc.prepaidrecordId=entity.prepaidrecordId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStorePrepaidrecord(storeId:storeId, pageNumber: pageNumber, pageSize: pageSize,statu:statu), successClosure: { (result) -> Void in
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
