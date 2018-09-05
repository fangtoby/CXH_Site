//
//  WholesaleAuthViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/9.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import MJRefresh
///批发授权
class WholesaleAuthViewController:BaseViewController{
    private var table:UITableView!
    private var arr=[WholesaleAuthEntity]()
    private let storeId=userDefaults.object(forKey:"storeId") as! Int
    private var pageNumber=1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="批发授权"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        self.navigationItem.rightBarButtonItem=UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target:self, action: #selector(addMember))
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-navHeight-bottomSafetyDistanceHeight))
        table.delegate=self
        table.dataSource=self
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.backgroundColor=UIColor.clear
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ () -> Void in
            self.pageNumber=1
            self.queryBindWholesale(pageNumber:self.pageNumber, pageSize:10, isRefresh:true)
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.pageNumber+=1
            self.queryBindWholesale(pageNumber:self.pageNumber, pageSize:10, isRefresh:false)
        })
        table.mj_footer.isHidden=true
        table.mj_header.beginRefreshing()
    }
}
///网络请求
extension WholesaleAuthViewController{
    @objc private func addMember(){
        let alert=UIAlertController(title:"添加授权会员", message:nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (txt) in
            txt.keyboardType=UIKeyboardType.numberPad
            txt.placeholder="请输入授权会员账号"

        }
        let ok=UIAlertAction.init(title:"确定", style: UIAlertActionStyle.default) { (action) in
            let text=(alert.textFields?.first)! as UITextField
            if text.text != nil{
                self.bindWholesale(memberAccount:text.text!)
            }
        }
        let cancel=UIAlertAction.init(title:"取消", style: UIAlertActionStyle.cancel,handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert,animated:true,completion: nil)
    }
    private func queryBindWholesale(pageNumber:Int,pageSize:Int,isRefresh:Bool){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryBindWholesale(storeId:storeId, pageNumber: pageNumber, pageSize: pageSize), successClosure: { (any) in
            
            if isRefresh{
                self.arr.removeAll()
            }
            let json=self.swiftJSON(any)
            self.arr=self.jsonMappingArrEntity(WholesaleAuthEntity(), object:json["list"].object) ?? [WholesaleAuthEntity]()
            if self.arr.count >= json["totalRow"].intValue{
                self.table.mj_footer.isHidden=true
            }else{
                self.table.mj_footer.isHidden=false
            }
            self.table.reloadData()
            self.table.mj_footer.endRefreshing()
            self.table.mj_header.endRefreshing()
        }) { (error) in
            self.table.mj_footer.endRefreshing()
            self.table.mj_header.endRefreshing()
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///绑定会员
    private func bindWholesale(memberAccount:String){
        self.showSVProgressHUD("正在验证...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.bindWholesale(storeId:storeId, memberAccount:memberAccount), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("绑定成功", type: HUD.success)
                self.table.mj_header.beginRefreshing()
            }else if success == "exist"{
                self.showSVProgressHUD("绑定关系已存在", type: HUD.error)
            }else if success == "notExist"{
                self.showSVProgressHUD("账号不存在", type: HUD.error)
            }else{
                self.showSVProgressHUD("添加授权失败", type: HUD.error)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    //修改站点和批发商的绑定关系
    private func updateBindWholesale(storeAndMemberBindWholesaleId:Int,flag:Int,index:IndexPath){
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.updateBindWholesale(storeId:storeId, storeAndMemberBindWholesaleId: storeAndMemberBindWholesaleId, flag:flag), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("操作成功", type: HUD.success)
                self.arr[index.row].flag=flag
                self.table.reloadRows(at: [index], with: UITableViewRowAnimation.fade)
            }else{
                self.showSVProgressHUD("操作失败", type: HUD.error)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
}
extension WholesaleAuthViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "WholesaleAuthTableViewCellId") as? WholesaleAuthTableViewCell
        if cell == nil{
            cell=Bundle.main.loadNibNamed("WholesaleAuthTableViewCell", owner:self,options: nil)?.last as? WholesaleAuthTableViewCell
        }
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.updateCell(entity:arr[indexPath.row])
            cell!.operationMemberAuthStateClosure={
                self.updateBindWholesale(storeAndMemberBindWholesaleId:entity.storeAndMemberBindWholesaleId!, flag:entity.flag==1 ? 2:1, index: indexPath)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
// MARK: - 空视图协议
extension WholesaleAuthViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let text="还没有相关数据"
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
