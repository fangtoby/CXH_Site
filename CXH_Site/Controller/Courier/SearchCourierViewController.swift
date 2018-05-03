//
//  SearchCourierViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/9.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 搜索揽件
class SearchCourierViewController:BaseViewController{
    fileprivate var table:UITableView!
    fileprivate var arr=[ExpressmailEntity]()
    fileprivate var pageNumber=1
    fileprivate var time=""
    fileprivate var showQrcodeView:UIView!
    fileprivate var entity:ExpressmailEntity?
    let identity=userDefaults.object(forKey: "identity") as! Int
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="搜索揽件"
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
        let userId=userDefaults.object(forKey: "userId") as! Int
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            if self.identity == 2{
                self.searchGiveHistoryForExpressLinkTime(self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:true, userId: userId)
            }else{
                self.searchGiveHistoryForDriverUserCtime(self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:true, userId: userId)
            }
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            if self.identity == 2{
                self.searchGiveHistoryForExpressLinkTime(self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:false, userId: userId)
            }else{
                self.searchGiveHistoryForDriverUserCtime(self.time, endTime: self.time, pageNumber: self.pageNumber, pageSize:10, isRefresh:false, userId: userId)
            }
        })
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"选择时间", style: UIBarButtonItemStyle.done, target:self, action:#selector(selectData))
        
    }
    @objc func selectData(){
        closeQrcodeView()
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
// MARK: - 网络请求
extension SearchCourierViewController{
    //搜索站点揽件记录
    func searchGiveHistoryForExpressLinkTime(_ startTime:String,endTime:String,pageNumber:Int,pageSize:Int,isRefresh:Bool,userId:Int){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.searchGiveHistoryForExpressLinkTime(userId:userId, startTime: startTime, endTime: endTime, pageNumber: pageNumber, pageSize: pageSize),successClosure: { (result) -> Void in
            if isRefresh{
                self.arr.removeAll()
            }
            let json=self.swiftJSON(result)
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(ExpressmailEntity(), object:value.object)
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
    //搜索司机揽件记录
    func searchGiveHistoryForDriverUserCtime(_ startTime:String,endTime:String,pageNumber:Int,pageSize:Int,isRefresh:Bool,userId:Int){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.searchGiveHistoryForDriverUserCtime(userId: userId, startTime: startTime, endTime: endTime, pageNumber: pageNumber, pageSize: pageSize),successClosure: { (result) -> Void in
            if isRefresh{
                self.arr.removeAll()
            }
            let json=self.swiftJSON(result)
            for(_,value) in json["list"]{
                let entity=self.jsonMappingEntity(ExpressmailEntity(), object:value.object)
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
extension SearchCourierViewController{
    func pushQrcode(_ entity: ExpressmailEntity) {
        self.entity=entity
        showQrcodeView(entity.qrcode!)
    }
    func pushDetails(_ entity: ExpressmailEntity) {
        let vc=CourierDetailsViewController()
        vc.entity=entity
        self.navigationController?.pushViewController(vc, animated:true)
    }
    //展示二维码
    func showQrcodeView(_ qrcode:String){
        showQrcodeView=UIView(frame:self.view.bounds)
        showQrcodeView.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.3)
        self.view.addSubview(showQrcodeView)
        let qrcodeView=UIView(frame:CGRect(x: (boundsWidth-210)/2,y: (boundsHeight-290-104)/2,width: 210,height: 290))
        qrcodeView.backgroundColor=UIColor.white
        qrcodeView.layer.masksToBounds=true
        qrcodeView.layer.cornerRadius=10
        self.showQrcodeView.addSubview(qrcodeView)
        let lblTitle=UILabel(frame:CGRect(x: 0,y: 0,width: qrcodeView.frame.width,height: 40))
        lblTitle.text="二维码"
        lblTitle.font=UIFont.boldSystemFont(ofSize: 16)
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor=UIColor.applicationMainColor()
        lblTitle.textColor=UIColor.white
        qrcodeView.addSubview(lblTitle)
        let qrcodeImageView=UIImageView(frame:CGRect(x: 5,y: 45,width: 200,height: 200))
        qrcodeImageView.sd_setImage(with: Foundation.URL(string:URLIMG+qrcode), placeholderImage:UIImage(named: "default_icon"))
        qrcodeView.addSubview(qrcodeImageView)
        if identity != 2{
            let btn=ButtonControl().button(ButtonType.button, text:"关闭", textColor:UIColor.white,font:16,backgroundColor:UIColor.applicationMainColor(), cornerRadius:nil)
            btn.titleLabel!.font=UIFont.boldSystemFont(ofSize: 16)
            btn.frame=CGRect(x: 0,y: 250,width: qrcodeView.frame.width,height: 40)
            btn.addTarget(self, action:#selector(closeQrcodeView), for: UIControlEvents.touchUpInside)
            qrcodeView.addSubview(btn)
        }else{
            if self.entity!.status == 2{
                let btn=ButtonControl().button(ButtonType.button, text:"关闭", textColor:UIColor.white,font:16,backgroundColor:UIColor.applicationMainColor(), cornerRadius:nil)
                btn.titleLabel!.font=UIFont.boldSystemFont(ofSize: 16)
                btn.frame=CGRect(x: 0,y: 250,width: qrcodeView.frame.width/2,height: 40)
                btn.addTarget(self, action:#selector(closeQrcodeView), for: UIControlEvents.touchUpInside)
                qrcodeView.addSubview(btn)
                let btn1=ButtonControl().button(ButtonType.button, text:"打印", textColor:UIColor.white,font:16,backgroundColor:UIColor.applicationMainColor(), cornerRadius:nil)
                btn1.titleLabel!.font=UIFont.boldSystemFont(ofSize: 16)
                btn1.frame=CGRect(x: qrcodeView.frame.width/2,y: 250,width: qrcodeView.frame.width/2,height: 40)
                btn1.addTarget(self, action:#selector(connectThePrinter), for: UIControlEvents.touchUpInside)
                qrcodeView.addSubview(btn1)
            }else{
                let btn=ButtonControl().button(ButtonType.button, text:"关闭", textColor:UIColor.white,font:16,backgroundColor:UIColor.applicationMainColor(), cornerRadius:nil)
                btn.titleLabel!.font=UIFont.boldSystemFont(ofSize: 16)
                btn.frame=CGRect(x: 0,y: 250,width: qrcodeView.frame.width,height: 40)
                btn.addTarget(self, action:#selector(closeQrcodeView), for: UIControlEvents.touchUpInside)
                qrcodeView.addSubview(btn)
            }
        }
    }
    //连接打印机
    @objc func connectThePrinter(){
        closeQrcodeView()
        let vc=ConnectThePrinterViewController()
        let entity=PrinterEntity()
        entity.code=self.entity!.qrcodeContent
        entity.weight="\(self.entity!.weight!)"
        entity.time=self.entity!.ctime
        entity.freight="\(self.entity!.freight!)"
        entity.storeName=userDefaults.object(forKey: "userName") as? String
        vc.entity=entity
        self.navigationController?.pushViewController(vc, animated:true)
    }
    //关闭
    @objc func closeQrcodeView(){
        if showQrcodeView != nil{
            showQrcodeView.removeFromSuperview()
        }
    }

}
extension SearchCourierViewController:UITableViewDelegate,UITableViewDataSource,CouierTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "CouierTableViewCellId") as? CouierTableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("CouierTableViewCell", owner:self,options: nil)?.last as? CouierTableViewCell
        }
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.delegate=self
            cell!.updateCell(entity,statu:2)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - 空视图协议
extension SearchCourierViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="请按时间搜索揽件"
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
