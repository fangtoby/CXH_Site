//
//  PersonalCenterViewController.swift
//  CXHSalesman
//
//  Created by hao peng on 2017/4/11.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit

/// 个人中心
class PersonalCenterViewController:BaseViewController{
    /// 图片
    fileprivate var img:UIImageView!
    
    /// 电话
    fileprivate var lblTel:UILabel!
    
    /// 信息view
    fileprivate var informationView:UIView!
    
    /// 职位相关信息
    fileprivate var positionView:UIView!
    
    /// 职位
    fileprivate var lblPosition:UILabel!
    
    /// 职位value
    fileprivate var lblPositionValue:UILabel!
    
    /// 余额
    fileprivate var lblBalance:UILabel!
    
    /// 余额value
    fileprivate var lblBalanceValue:UILabel!
    
    /// table
    fileprivate var table:UITableView!
    
    /// 退出登录
    fileprivate var btnReturnLogin:UIButton!
    
    fileprivate var scrollView:UIScrollView!
    
    /// 数据源
    fileprivate var nameArr=[String]()
    fileprivate var imgArr=[String]()
    let identity=userDefaults.object(forKey: "identity") as! Int
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent=true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent=false
        if identity == 2{
            queryStoreCapitalSumMoney()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="我的信息"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        let imgView=UIImageView(frame:CGRect(x: 0,y: 0,width: 30,height: 30))
        imgView.image=UIImage(named:"settings")?.reSizeImage(reSize:CGSize(width:30, height:30))
        imgView.isUserInteractionEnabled=true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(pushSettings)))
        let item=UIBarButtonItem(customView:imgView)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.rightBarButtonItem=item
        if identity == 2{
            nameArr=["揽件清单","收件历史","代签收记录","返件记录","揽件修改历史","退款/售后","充值明细","扣费明细","我要提现"]
            imgArr=["classify_5","classify_6","dqs","fj","ljxg","tk","cz","classify_kfmx","tx1"]
            queryStoreCapitalSumMoney()
        }else if identity == 3{
            nameArr=["揽件清单","收件历史","代签收记录","返件记录"]
            imgArr=["classify_5","classify_6","dqs","fj"]
        }else if identity == 1{
            nameArr=["代签收记录","返件记录"]
            imgArr=["dqs","fj"]
        }
        buildView()
    }
    /**
     跳转到设置页面
     */
    @objc func pushSettings(){
       let vc=SettingsViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

// MARK: - 构建页面
extension PersonalCenterViewController{
    func buildView(){
        
        scrollView=UIScrollView(frame:CGRect.zero)
        self.view.addSubview(scrollView)
        
        let viewContainer=UIView(frame: CGRect.zero)
        scrollView.addSubview(viewContainer)
        
        informationView=UIView()
        informationView.backgroundColor=UIColor.applicationMainColor()
        viewContainer.addSubview(informationView)
        
        img=UIImageView()
        img.image=UIImage(named:"login_log")
        informationView.addSubview(img)
        
        lblTel=buildLabel(UIColor.white, font: 14, textAlignment: NSTextAlignment.center)
        lblTel.text=userDefaults.object(forKey: "userAccount") as? String
        informationView.addSubview(lblTel)
        
        positionView=UIView()
        positionView.backgroundColor=UIColor.white
        viewContainer.addSubview(positionView)
        
        let leftPositionView=UIView()
        leftPositionView.isUserInteractionEnabled=true
        leftPositionView.addGestureRecognizer(UITapGestureRecognizer(target:self,action:#selector(pushTouchBalance)))
        positionView.addSubview(leftPositionView)
        
        let rightPositionView=UIView()
        positionView.addSubview(rightPositionView)
        
        let cutOffRuleView=UIView()
        cutOffRuleView.backgroundColor=UIColor.RGBFromHexColor("#cccccc")
        positionView.addSubview(cutOffRuleView)
        
        lblBalance=UILabel()
        lblBalance.text="余额"
        lblBalance.textColor=UIColor.RGBFromHexColor("#333333")
        lblBalance.font=UIFont.boldSystemFont(ofSize: 18)
        leftPositionView.addSubview(lblBalance)
        
        lblBalanceValue=buildLabel(UIColor.RGBFromHexColor("#999999"), font:15, textAlignment: NSTextAlignment.left)
        leftPositionView.addSubview(lblBalanceValue)
        
        lblPosition=UILabel()
        lblPosition.text="职位"
        lblPosition.textColor=UIColor.RGBFromHexColor("#333333")
        lblPosition.font=UIFont.boldSystemFont(ofSize: 18)
        rightPositionView.addSubview(lblPosition)
        
        lblPositionValue=buildLabel(UIColor.RGBFromHexColor("#999999"), font: 15, textAlignment: NSTextAlignment.left)
        var name:String?
        switch  identity{
        case 1:
            name="后台管理员"
        case 2:
            name="站点管理员"
        case 3:
            name="司机"
        case 4:
            name="体验店管理员"
        default:break
        }
        lblPositionValue.text=name
        rightPositionView.addSubview(lblPositionValue)
        
        table=UITableView()
        table.dataSource=self
        table.delegate=self
        table.isScrollEnabled=false
        viewContainer.addSubview(table)
        
        btnReturnLogin=ButtonControl().button(ButtonType.button, text:"退出登录", textColor: UIColor.black, font:18, backgroundColor:UIColor.white, cornerRadius:nil)
        btnReturnLogin.addTarget(self, action:#selector(returnLogin), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(btnReturnLogin)
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(boundsWidth)
            make.top.equalTo(0)
            make.height.equalTo(boundsHeight-navHeight-bottomSafetyDistanceHeight)
            
        }
        viewContainer.snp.makeConstraints { (make) in
            make.edges.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        informationView.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth)
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(120)
        }
        img.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.left.equalTo((boundsWidth-80)/2)
            make.top.equalTo(10)
        }
        lblTel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(img.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(boundsWidth)
        }
        positionView.snp.makeConstraints { (make) in
            make.top.equalTo(informationView.snp.bottom).offset(10)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(70)
            make.left.equalTo(0)
        }
        leftPositionView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(boundsWidth/2)
            make.height.equalTo(70)
            make.left.equalTo(0)
        }
        rightPositionView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(boundsWidth/2)
            make.height.equalTo(70)
            make.left.equalTo(boundsWidth/2)
        }
        
        lblBalance.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth/2-20)
            make.left.equalTo(20)
            make.top.equalTo(12.5)
            make.height.equalTo(20)
        }
        lblBalanceValue.snp.makeConstraints { (make) in
            make.width.equalTo(lblBalance.snp.width)
            make.top.equalTo(lblBalance.snp.bottom).offset(5)
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        cutOffRuleView.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.height.equalTo(positionView.snp.height)
            make.top.equalTo(0)
            make.left.equalTo(boundsWidth/2)
        }
        lblPosition.snp.makeConstraints { (make) in
            make.width.equalTo(lblBalance.snp.width)
            make.height.equalTo(20)
            make.left.equalTo(20)
            make.top.equalTo(lblBalance.snp.top)
        }
        lblPositionValue.snp.makeConstraints { (make) in
            make.width.equalTo(lblBalance.snp.width)
            make.height.equalTo(20)
            make.left.equalTo(20)
            make.top.equalTo(lblPosition.snp.bottom).offset(5)
        }
        table.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth)
            make.left.equalTo(0)
            make.top.equalTo(positionView.snp.bottom).offset(10)
            if identity == 2{
                make.height.equalTo(450)
            }else if identity == 3{
                make.height.equalTo(200)
            }else{
                make.height.equalTo(100)
            }
        }
        btnReturnLogin.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth)
            make.height.equalTo(50)
            make.left.equalTo(0)
            make.top.equalTo(table.snp.bottom).offset(30)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-30是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(viewContainer).offset(-30)
        }
    }
    /**
     跳转到余额明细
     */
    @objc func pushTouchBalance(){
        let  vc=TouchBalanceViewController()
        vc.balance=lblBalanceValue.text
        self.navigationController?.pushViewController(vc, animated:true)
    }
    /**
     退出登录
     */
    @objc func returnLogin(){
        UIAlertController.showAlertYesNo(self, title:"城乡惠", message:"您确定要退出登录吗?", cancelButtonTitle:"取消", okButtonTitle:"确定") {  Void in
            //清除缓存中会员id
            userDefaults.removeObject(forKey: "storeId")
            userDefaults.removeObject(forKey: "userId")
            userDefaults.synchronize();
            //切换根视图
            let app=UIApplication.shared.delegate as! AppDelegate
            let vc=LoginViewController()
            app.window?.rootViewController=UINavigationController(rootViewController:vc);
        }
    }
    func queryStoreCapitalSumMoney(){
        let storeId=userDefaults.object(forKey: "storeId") as! Int
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreCapitalSumMoney(storeId:storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            self.lblBalanceValue.text=json["success"].stringValue
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}

// MARK: - 实现协议
extension PersonalCenterViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cellid")
        }
        if nameArr.count > 0{
            //图片
            let img=UIImageView(frame:CGRect(x:14,y:10,width:30,height:30))
            img.image=UIImage(named:imgArr[indexPath.row])
            cell!.contentView.addSubview(img)
            //文字描述
            let name=UILabel(frame:CGRect(x:img.frame.maxX+5,y:15,width:100,height:20))
            name.font=UIFont.systemFont(ofSize: 14)
            name.text=nameArr[indexPath.row]
            cell!.contentView.addSubview(name)
            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.row == 0{
            if identity != 1{//揽件清单
                let vc=CourierListViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            }else{//代签收记录
                let vc=ReplaceSignListViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            }
        }else if indexPath.row == 1{
            if identity == 2{//站点包
                let vc=StoreInboxViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            }else if identity == 3{//物流包
                let vc=LogisticsInboxViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            }else{//返件记录
                let vc=ReturnHistoryViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            }
        }else if indexPath.row == 2{//代签收记录
            let vc=ReplaceSignListViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 3{//返件记录
            let vc=ReturnHistoryViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 4{//揽件修改历史
            let vc=CourierUpdateListViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 5{//退款
            let vc=ReturnGoodsViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 6{//充值记录
            let vc=StorePrepaidrecordViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 7{//扣除记录
            let vc=StorecapitalrecordViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 8{//提现记录
            let vc=WithdrawaManagementViewController()
            vc.money=lblBalanceValue.text
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
    
}
