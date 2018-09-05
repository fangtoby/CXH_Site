//
//  CourierEntryHistoryListViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/9/5.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import MJRefresh
///揽件录入历史记录
class CourierEntryHistoryListViewController:BaseViewController{

    ///1查询寄件人信息  2收件人信息
    var flag:Int=0

    private var txtSearch:UITextField!

    private var table:UITableView!

    private var arr=[ExpressmailEntity]()

    private let userId=userDefaults.object(forKey: "userId") as! Int

    ///搜索内容
    private var searchInfo:String?

    private var pageNumber=1

    private var pageSize=10

    ///选择的历史寄件信息
    var selectedInfoClosure:((_ entity:ExpressmailEntity) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == 1{
            self.title="寄件人管理"
        }else{
            self.title="收件人管理"
        }
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        setUI()
        self.table.mj_header=MJRefreshNormalHeader(refreshingBlock:{ [unowned self] () -> Void in
            self.pageNumber=1
            self.queryGiveHistoryForFastMail(isRefresh:true, pageNumber:self.pageNumber, pageSize:self.pageSize)

        })
        self.table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] () -> Void in
            self.pageNumber+=1
            self.queryGiveHistoryForFastMail(isRefresh:false, pageNumber:self.pageNumber, pageSize:self.pageSize)
        })
        self.table.mj_footer.isHidden=true
        self.table.mj_header.beginRefreshing()
    }
}
///页面布局
extension CourierEntryHistoryListViewController:UITextFieldDelegate{
    private func setUI(){
        //搜索框背景
        let searchView=UIView(frame:CGRect(x:20,y:10+navHeight,width: boundsWidth-80,height:35))
        searchView.backgroundColor=UIColor.RGBFromHexColor("#cccccc")
        searchView.layer.cornerRadius=7
        self.view.addSubview(searchView)
        //搜索框
        txtSearch=UITextField(frame:CGRect(x: 15,y: 0,width: searchView.frame.width-30,height: 35))
        txtSearch.font=UIFont.systemFont(ofSize: 14)
        txtSearch.placeholder="请输入搜索内容"
        txtSearch.delegate=self
        txtSearch.returnKeyType = .search
        txtSearch.tintColor=UIColor.color999()
        searchView.addSubview(txtSearch)

        let btn=UIButton(frame: CGRect(x:searchView.frame.maxX, y:10+navHeight,width:60, height:35))
        btn.setTitle("搜索", for: UIControlState.normal)
        btn.backgroundColor=UIColor.clear
        btn.titleLabel?.font=UIFont.systemFont(ofSize:15)
        btn.setTitleColor(UIColor.applicationMainColor(), for: UIControlState.normal)
        btn.addTarget(self, action:#selector(search), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)

        let borderView=UIView(frame:CGRect(x: 0,y:searchView.frame.maxY+10,width: boundsWidth,height: 0.5))
        borderView.backgroundColor=UIColor.borderColor()
        self.view.addSubview(borderView)

        table=UITableView(frame:CGRect(x:0,y:borderView.frame.maxY,width: boundsWidth,height:boundsHeight-borderView.frame.maxY))
        table.delegate=self
        table.dataSource=self
        table.backgroundColor=UIColor.clear
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.estimatedRowHeight=80
        table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.estimatedSectionFooterHeight=0
        table.estimatedSectionHeaderHeight=0
        table.rowHeight = UITableViewAutomaticDimension
        table.tableFooterView=UIView(frame:CGRect.zero)
        table.register(UINib(nibName:"CourierEntryHistoryListTableViewCell", bundle:nil), forCellReuseIdentifier:"cehListId")
        self.view.addSubview(table)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
    @objc private func search(){
        let txt=txtSearch.text
        if txt == nil || txt!.count == 0{
            self.searchInfo=nil
        }else{
            if txt!.containsEmoji{
                self.showSVProgressHUD("搜索内容不能包含特殊字符", type: HUD.info)
                return
            }else{
                self.searchInfo=txt!
            }
        }
        self.view.endEditing(true)
        table.mj_header.beginRefreshing()
    }
}
// MARK: - table为空提示视图
extension CourierEntryHistoryListViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    //图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "nil_img")
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text="暂无信息记录"
        let attributes=[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.darkGray]
        return NSAttributedString(string:text, attributes:attributes)
    }
    //设置文字和图片间距
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 10
    }
    //设置垂直偏移量
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -40
    }
    //设置是否滑动
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

}
extension CourierEntryHistoryListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"cehListId", for: indexPath) as! CourierEntryHistoryListTableViewCell
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell.updateCell(entity:entity,flag:flag)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity=arr[indexPath.row]
        self.selectedInfoClosure?(entity)
        self.navigationController?.popViewController(animated:true)
    }
}
extension CourierEntryHistoryListViewController{
    private func queryGiveHistoryForFastMail(isRefresh:Bool,pageNumber:Int,pageSize:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryGiveHistoryForFastMail(pageNumber: pageNumber, pageSize: pageSize,userId:userId, searchInfo: searchInfo), successClosure: { (any) in
            if isRefresh{
                self.arr.removeAll()
            }
            let json=self.swiftJSON(any)
            self.arr+=self.jsonMappingArrEntity(ExpressmailEntity(), object:json["list"].object) ?? [ExpressmailEntity]()
            if self.arr.count >= json["totalRow"].intValue{
                self.table.mj_footer.isHidden=true
            }else{
                self.table.mj_footer.isHidden=false
            }
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
            self.table.reloadData()
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
            self.table.mj_header.endRefreshing()
            self.table.mj_footer.endRefreshing()
        }
    }
}

