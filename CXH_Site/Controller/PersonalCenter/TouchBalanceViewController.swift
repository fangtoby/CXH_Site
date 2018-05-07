//
//  TouchBalanceViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/8/18.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
///余额明细
class TouchBalanceViewController:BaseViewController{
    //接收传入的余额
    var balance:String?
    fileprivate var scrollView:UIScrollView!
    //余额
    fileprivate var lblBalance:UILabel!
    //收入
    fileprivate var lblRevenue:UILabel!
    //月份/日期
    fileprivate var lblDate:UILabel!
    //支出
    fileprivate var lblExpenditure:UILabel!
    fileprivate var touchBalanceEntity:TouchBalanceEntity?
    fileprivate let revenueTextArr=["充值","商品销售","快递费返还","物流费返还","退件返还"]
    fileprivate let expenditureTextArr=["揽件扣除","订单发货","加钱扣除","保价扣除","运费扣除","提现扣除"]
    fileprivate var expenditureTitleView:UIView!
    fileprivate var revenueTitleView:UIView!
    fileprivate var lblC1:UILabel!
    fileprivate var lblC2:UILabel!
    fileprivate var lblC3:UILabel!
    fileprivate var lblC4:UILabel!
    fileprivate var lblC5:UILabel!
    fileprivate var lblK1:UILabel!
    fileprivate var lblK2:UILabel!
    fileprivate var lblK3:UILabel!
    fileprivate var lblK4:UILabel!
    fileprivate var lblK5:UILabel!
    fileprivate var lblK6:UILabel!
    fileprivate let storeId=userDefaults.object(forKey: "storeId") as! Int
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent=false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="账单明细"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        scrollView=UIScrollView(frame:self.view.bounds)
        self.view.addSubview(scrollView)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"筛选", style: UIBarButtonItemStyle.done, target:self, action:#selector(selectedDate))
        buildView()
        storeTongji(storeId,time:nil)
    }
    /**
     选择时间
     */
    @objc func selectedDate(){
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
            dateFormatter.dateFormat="yyyy-MM"
            self.lblDate.text=dateFormatter.string(from: datePicker.date)
            self.storeTongji(self.storeId,time:dateFormatter.string(from: datePicker.date))
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
// MARK: - 构建页面
extension TouchBalanceViewController{
    func buildView(){
        let topView=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 150))
        topView.backgroundColor=UIColor.applicationMainColor()
        scrollView.addSubview(topView)
        lblBalance=buildLabel(UIColor.white, font:18, textAlignment: NSTextAlignment.center)
        lblBalance.frame=CGRect(x: 0,y: 30,width: boundsWidth,height: 20)
        lblBalance.text=balance
        topView.addSubview(lblBalance)
        let lblBalanceText=buildLabel(UIColor.white, font:14, textAlignment: NSTextAlignment.center)
        lblBalanceText.frame=CGRect(x: 0,y: lblBalance.frame.maxY+5,width: boundsWidth,height: 20)
        lblBalanceText.text="余额(元)"
        topView.addSubview(lblBalanceText)
        
        let leftView=UIView(frame:CGRect(x: 0,y: lblBalanceText.frame.maxY+10,width: boundsWidth/3,height: 40))
        topView.addSubview(leftView)
        let lblRevenueText=buildLabel(UIColor.white, font:13, textAlignment: NSTextAlignment.center)
        lblRevenueText.frame=CGRect(x: 0,y: 0,width: leftView.frame.width,height: 20)
        lblRevenueText.text="收入"
        leftView.addSubview(lblRevenueText)
        
        lblRevenue=buildLabel(UIColor.white, font:13, textAlignment: NSTextAlignment.center)
        lblRevenue.frame=CGRect(x: 0,y: lblRevenueText.frame.maxY,width: leftView.frame.width,height: 20)
        leftView.addSubview(lblRevenue)
        
        let contentView=UIView(frame:CGRect(x: boundsWidth/3,y: lblBalanceText.frame.maxY+10,width: boundsWidth/3,height: 40))
        topView.addSubview(contentView)
        
        let lblDateText=buildLabel(UIColor.white, font:13, textAlignment: NSTextAlignment.center)
        lblDateText.text="月份"
        lblDateText.frame=CGRect(x: 0,y: 0,width: contentView.frame.width,height: 20)
        contentView.addSubview(lblDateText)
        
        lblDate=buildLabel(UIColor.white, font:13, textAlignment: NSTextAlignment.center)
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM"
        lblDate.text=dateFormatter.string(from: Date())
        lblDate.frame=CGRect(x: 0,y: lblDateText.frame.maxY,width: contentView.frame.width,height: 20)
        contentView.addSubview(lblDate)
        
        let rightView=UIView(frame:CGRect(x: boundsWidth/3*2,y: lblBalanceText.frame.maxY+10,width: boundsWidth/3,height: 40))
        topView.addSubview(rightView)
        
        let lblExpenditureText=buildLabel(UIColor.white, font:13, textAlignment: NSTextAlignment.center)
        lblExpenditureText.text="支出"
        lblExpenditureText.frame=CGRect(x: 0,y: 0, width: rightView.frame.width,height: 20)
        rightView.addSubview(lblExpenditureText)
        
        lblExpenditure=buildLabel(UIColor.white, font:13, textAlignment: NSTextAlignment.center)
        lblExpenditure.frame=CGRect(x: 0,y: lblExpenditureText.frame.maxY,width: rightView.frame.width,height: 20)
        rightView.addSubview(lblExpenditure)
        
        let leftBorderView=UIView(frame:CGRect(x: boundsWidth/3,y: lblBalanceText.frame.maxY+15,width: 1,height: 30))
        leftBorderView.backgroundColor=UIColor.white
        topView.addSubview(leftBorderView)
        
        let rightBorderView=UIView(frame:CGRect(x: boundsWidth/3*2,y: lblBalanceText.frame.maxY+15,width: 1,height: 30))
        rightBorderView.backgroundColor=UIColor.white
        topView.addSubview(rightBorderView)
        
        //支出明细view
        expenditureTitleView=UIView(frame:CGRect(x: 0,y: topView.frame.maxY,width: boundsWidth,height: 44))
        expenditureTitleView.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView.addSubview(expenditureTitleView)
        
        let expenditureTitle=buildLabel(UIColor.color666(), font:14, textAlignment: NSTextAlignment.left)
        expenditureTitle.text="支出明细"
        expenditureTitle.frame=CGRect(x: 13,y: 20,width: 200,height: 20)
        expenditureTitleView.addSubview(expenditureTitle)
        
        //第1行
        let expenditureViewRow1=UIView(frame:CGRect(x: 0,y: expenditureTitleView.frame.maxY,width: boundsWidth,height: 60))
        expenditureViewRow1.backgroundColor=UIColor.white
        self.scrollView.addSubview(expenditureViewRow1)
        
        let expenditureViewRow1LeftBorderView=UIView(frame:CGRect(x: boundsWidth/2,y: 0,width: 0.5,height: 60))
        expenditureViewRow1LeftBorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        expenditureViewRow1.addSubview(expenditureViewRow1LeftBorderView)
        
        let lblK1Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblK1Title.text="揽件扣除"
        lblK1Title.frame=CGRect(x: 15,y: 10,width: boundsWidth/2-15,height: 20)
        expenditureViewRow1.addSubview(lblK1Title)
        
        lblK1=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        lblK1.frame=CGRect(x: 15,y: lblK1Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        expenditureViewRow1.addSubview(lblK1)
        
        let lblK2Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblK2Title.text="订单发货"
        lblK2Title.frame=CGRect(x: boundsWidth/2+15,y: 10,width: boundsWidth/2-15,height: 20)
        expenditureViewRow1.addSubview(lblK2Title)
        
        lblK2=buildLabel(UIColor.textColor(), font:13, textAlignment: NSTextAlignment.left)
        lblK2.frame=CGRect(x: boundsWidth/2+15,y: lblK2Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        expenditureViewRow1.addSubview(lblK2)
        
        let expenditureViewRow1BorderView=UIView(frame:CGRect(x: 0,y: expenditureViewRow1.frame.maxY,width: boundsWidth,height: 0.5))
        expenditureViewRow1BorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        self.scrollView.addSubview(expenditureViewRow1BorderView)
        
        
        //第2行
        let expenditureViewRow2=UIView(frame:CGRect(x: 0,y: expenditureViewRow1BorderView.frame.maxY,width: boundsWidth,height: 60))
        expenditureViewRow2.backgroundColor=UIColor.white
        self.scrollView.addSubview(expenditureViewRow2)
        
        let lblK3Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblK3Title.text="加钱扣除"
        lblK3Title.frame=CGRect(x: 15,y: 10,width: boundsWidth/2-15,height: 20)
        expenditureViewRow2.addSubview(lblK3Title)
        
        lblK3=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        lblK3.frame=CGRect(x: 15,y: lblK3Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        expenditureViewRow2.addSubview(lblK3)
        
        let lblK4Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblK4Title.text="保价扣除"
        lblK4Title.frame=CGRect(x: boundsWidth/2+15,y: 10,width: boundsWidth/2-15,height: 20)
        expenditureViewRow2.addSubview(lblK4Title)
        
        lblK4=buildLabel(UIColor.textColor(), font:13, textAlignment: NSTextAlignment.left)
        lblK4.frame=CGRect(x: boundsWidth/2+15,y: lblK4Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        expenditureViewRow2.addSubview(lblK4)
        
        let expenditureViewRow2LeftBorderView=UIView(frame:CGRect(x: boundsWidth/2,y: 0,width: 0.5,height: 60))
        expenditureViewRow2LeftBorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        expenditureViewRow2.addSubview(expenditureViewRow2LeftBorderView)
        
        let expenditureViewRow2BorderView=UIView(frame:CGRect(x: 0,y: expenditureViewRow2.frame.maxY,width: boundsWidth,height: 0.5))
        expenditureViewRow2BorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        self.scrollView.addSubview(expenditureViewRow2BorderView)
        
        
        //第3行
        let expenditureViewRow3=UIView(frame:CGRect(x: 0,y: expenditureViewRow2BorderView.frame.maxY,width: boundsWidth,height: 60))
        expenditureViewRow3.backgroundColor=UIColor.white
        self.scrollView.addSubview(expenditureViewRow3)
        
        let lblK5Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblK5Title.text="运费扣除"
        lblK5Title.frame=CGRect(x: 15,y: 10,width: boundsWidth/2-15,height: 20)
        expenditureViewRow3.addSubview(lblK5Title)
        
        lblK5=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        lblK5.frame=CGRect(x: 15,y: lblK5Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        expenditureViewRow3.addSubview(lblK5)
        
        let lblK6Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblK6Title.text="提现扣除"
        lblK6Title.frame=CGRect(x: boundsWidth/2+15,y: 10,width: boundsWidth/2-15,height: 20)
        expenditureViewRow3.addSubview(lblK6Title)
        
        lblK6=buildLabel(UIColor.textColor(), font:13, textAlignment: NSTextAlignment.left)
        lblK6.frame=CGRect(x: boundsWidth/2+15,y: lblK6Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        expenditureViewRow3.addSubview(lblK6)
        
        let expenditureViewRow3LeftBorderView=UIView(frame:CGRect(x: boundsWidth/2,y: 0,width: 0.5,height: 60))
        expenditureViewRow3LeftBorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        expenditureViewRow3.addSubview(expenditureViewRow3LeftBorderView)
        
        let expenditureViewRow3BorderView=UIView(frame:CGRect(x: 0,y: expenditureViewRow3.frame.maxY,width: boundsWidth,height: 0.5))
        expenditureViewRow1BorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        self.scrollView.addSubview(expenditureViewRow3BorderView)
        
        
        //收入明细view
        revenueTitleView=UIView(frame:CGRect(x: 0,y: expenditureViewRow3BorderView.frame.maxY,width: boundsWidth,height: 44))
        revenueTitleView.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView.addSubview(revenueTitleView)
        
        let revenueTitle=buildLabel(UIColor.color666(), font:14, textAlignment: NSTextAlignment.left)
        revenueTitle.text="收入明细"
        revenueTitle.frame=CGRect(x: 13,y: 20,width: 200,height: 20)
        revenueTitleView.addSubview(revenueTitle)
        
        //第1行
        let revenueViewRow1=UIView(frame:CGRect(x: 0,y: revenueTitleView.frame.maxY,width: boundsWidth,height: 60))
        revenueViewRow1.backgroundColor=UIColor.white
        self.scrollView.addSubview(revenueViewRow1)
        
        let revenueViewRow1LeftBorderView=UIView(frame:CGRect(x: boundsWidth/2,y: 0,width: 0.5,height: 60))
        revenueViewRow1LeftBorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        revenueViewRow1.addSubview(revenueViewRow1LeftBorderView)
        
        let lblC1Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblC1Title.text="充值"
        lblC1Title.frame=CGRect(x: 15,y: 10,width: boundsWidth/2-15,height: 20)
        revenueViewRow1.addSubview(lblC1Title)
        
        lblC1=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        lblC1.frame=CGRect(x: 15,y: lblC1Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        revenueViewRow1.addSubview(lblC1)
        
        let lblC2Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblC2Title.text="商品销售"
        lblC2Title.frame=CGRect(x: boundsWidth/2+15,y: 10,width: boundsWidth/2-15,height: 20)
        revenueViewRow1.addSubview(lblC2Title)
        
        lblC2=buildLabel(UIColor.textColor(), font:13, textAlignment: NSTextAlignment.left)
        lblC2.frame=CGRect(x: boundsWidth/2+15,y: lblC2Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        revenueViewRow1.addSubview(lblC2)
        
        let revenueViewRow1BorderView=UIView(frame:CGRect(x: 0,y: revenueViewRow1.frame.maxY,width: boundsWidth,height: 0.5))
        revenueViewRow1BorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        self.scrollView.addSubview(revenueViewRow1BorderView)
        
        
        //第2行
        let revenueViewRow2=UIView(frame:CGRect(x: 0,y: revenueViewRow1BorderView.frame.maxY,width: boundsWidth,height: 60))
        revenueViewRow2.backgroundColor=UIColor.white
        self.scrollView.addSubview(revenueViewRow2)
        
        let lblC3Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblC3Title.text="快递费返还"
        lblC3Title.frame=CGRect(x: 15,y: 10,width: boundsWidth/2-15,height: 20)
        revenueViewRow2.addSubview(lblC3Title)
        
        lblC3=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        lblC3.frame=CGRect(x: 15,y: lblC3Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        revenueViewRow2.addSubview(lblC3)
        
        let lblC4Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblC4Title.text="物流费返还"
        lblC4Title.frame=CGRect(x: boundsWidth/2+15,y: 10,width: boundsWidth/2-15,height: 20)
        revenueViewRow2.addSubview(lblC4Title)
        
        lblC4=buildLabel(UIColor.textColor(), font:13, textAlignment: NSTextAlignment.left)
        lblC4.frame=CGRect(x: boundsWidth/2+15,y: lblC4Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        revenueViewRow2.addSubview(lblC4)
        
        let revenueViewRow2LeftBorderView=UIView(frame:CGRect(x: boundsWidth/2,y: 0,width: 0.5,height: 60))
        revenueViewRow2LeftBorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        revenueViewRow2.addSubview(revenueViewRow2LeftBorderView)
        
        let revenueViewRow2BorderView=UIView(frame:CGRect(x: 0,y: revenueViewRow2.frame.maxY,width: boundsWidth,height: 0.5))
        revenueViewRow2BorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        self.scrollView.addSubview(revenueViewRow2BorderView)
        
        
        //第3行
        let revenueViewRow3=UIView(frame:CGRect(x: 0,y: revenueViewRow2BorderView.frame.maxY,width: boundsWidth,height: 60))
        revenueViewRow3.backgroundColor=UIColor.white
        self.scrollView.addSubview(revenueViewRow3)
        
        let lblC5Title=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
        lblC5Title.text="退件返还"
        lblC5Title.frame=CGRect(x: 15,y: 10,width: boundsWidth/2-15,height: 20)
        revenueViewRow3.addSubview(lblC5Title)
        
        lblC5=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        lblC5.frame=CGRect(x: 15,y: lblC5Title.frame.maxY+3,width: boundsWidth/2-15,height: 20)
        revenueViewRow3.addSubview(lblC5)
        
        
        let revenueViewRow3BorderView=UIView(frame:CGRect(x: 0,y: revenueViewRow3.frame.maxY,width: boundsWidth,height: 0.5))
        revenueViewRow3BorderView.backgroundColor=UIColor.RGBFromHexColor("#dddedf")
        self.scrollView.addSubview(revenueViewRow3BorderView)
        self.scrollView.contentSize=CGSize(width: boundsWidth,height: revenueViewRow3BorderView.frame.maxY+10)
        
    }
}
// MARK: - 网络请求
extension TouchBalanceViewController{
    func storeTongji(_ storeId:Int,time:String?){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeTongji(storeId:storeId,time:time), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            self.touchBalanceEntity=self.jsonMappingEntity(TouchBalanceEntity(), object: json.object)
            self.lblRevenue.text="\(self.touchBalanceEntity!.c1!+self.touchBalanceEntity!.c2!+self.touchBalanceEntity!.c3!+self.touchBalanceEntity!.c4!+self.touchBalanceEntity!.c5!)"
            self.lblExpenditure.text="\(self.touchBalanceEntity!.k1!+self.touchBalanceEntity!.k2!+self.touchBalanceEntity!.k3!+self.touchBalanceEntity!.k4!+self.touchBalanceEntity!.k5!+self.touchBalanceEntity!.k6!)"
            self.lblK1.text="\(self.touchBalanceEntity!.k1!)"
            self.lblK2.text="\(self.touchBalanceEntity!.k2!)"
            self.lblK3.text="\(self.touchBalanceEntity!.k3!)"
            self.lblK4.text="\(self.touchBalanceEntity!.k4!)"
            self.lblK5.text="\(self.touchBalanceEntity!.k5!)"
            self.lblK6.text="\(self.touchBalanceEntity!.k6!)"
            self.lblC1.text="\(self.touchBalanceEntity!.c1!)"
            self.lblC2.text="\(self.touchBalanceEntity!.c2!)"
            self.lblC3.text="\(self.touchBalanceEntity!.c3!)"
            self.lblC4.text="\(self.touchBalanceEntity!.c4!)"
            self.lblC5.text="\(self.touchBalanceEntity!.c5!)"
            }) { (errorMsg) -> Void in
               self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
