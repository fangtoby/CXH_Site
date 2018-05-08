//
//  UploadGoodViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import IQKeyboardManagerSwift
/// 上传商品
class UploadGoodViewController:BaseViewController{
    fileprivate var scrollView:UIScrollView!
    ///选择商品上传类型
    private var segmentedControl:UISegmentedControl!
    fileprivate var table:UITableView!
    fileprivate var txtGoodInfoName:UITextField!
    fileprivate var txtGoodUcode:UITextField!
    fileprivate var txtGoodUnit:UITextField!
    fileprivate var txtGoodsPrice:UITextField!
    fileprivate var txtStock:UITextField!
    fileprivate var txtGoodLife:UITextField!
    fileprivate var lblGoodSource:UILabel!
    fileprivate var txtGoodService:UITextField!
    fileprivate var txtGoodPic:UITextField!
    fileprivate var txtGoodsDetailsPic:UITextField!
    fileprivate var txtGoodInfoCode:UITextField!
    fileprivate var txtGoodMixed:UITextField!
    fileprivate var txtRemark:UITextField!
    fileprivate var txtProducer:UITextField!
    fileprivate var lblCategory:UILabel!
    private var txtGoodsMemberPrice:UITextField!
    private var txtMemberPriceMiniCount:UITextField!
    fileprivate var collectionView:UICollectionView!
    fileprivate var sourceCollectionView:UICollectionView!
    fileprivate var sourceImgArr=[SourceEntity()]
    fileprivate var imgArr=["addImg"]
    fileprivate var categoryArr=[GoodsCategoryEntity]()
    fileprivate var showSourceInfoView:UIView!
    fileprivate var textViews:UITextView!
    private var txtSellerAddress:UITextField!
    private var btn:UIButton!
    //是否同意用户协议
    fileprivate var isImg:UIButton!
    //用户协议文字按
    fileprivate var btnUserAgreement:UIButton!
    //用户协议view
    private var  userAgreementView:UIView!
    //保存来源信息
    fileprivate var sourceEntity=SourceEntity()
    //保存来源图片
    fileprivate var sourceGoodImg:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="上传商品"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        scrollView=UIScrollView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight))
        self.view.addSubview(scrollView)
        buildView()
        let isExplained=userDefaults.object(forKey:"isExplained") as? Int
        if isExplained != 1{//弹出说明
            showExplained()
        }
        //监听地区选择通知
        NotificationCenter.default.addObserver(self,selector:#selector(updateAddress), name:NSNotification.Name(rawValue: "postUpdateAddress"), object:nil)
        
        //监听分类选择通知
        NotificationCenter.default.addObserver(self,selector:#selector(updateCategory), name:NSNotification.Name(rawValue: "postUpdateCategory"), object:nil)
    }
    @objc func updateAddress(_ obj:Notification){
        let addressStr=obj.object as! String
        let addressArr=addressStr.components(separatedBy: "-")
        lblGoodSource.text=addressArr[0]+addressArr[1]+addressArr[2]
    }
    @objc func updateCategory(_ obj:Notification){
        categoryArr=obj.object as! [GoodsCategoryEntity]
        lblCategory.text=categoryArr[1].goodscategoryName
    }
}

extension UploadGoodViewController{
    ///弹出说明
    @objc private func showExplained(){
        UIAlertController.showAlertYes(self, title:"说明", message:"只能零售说明:当前商品只能在普通区展示,不能用于批发。\n只能批发说明:不能在普通商品展示，只能在批发区展示,不能分享。\n可零售可批发说明:可以在普通区展示也能在批发区展示,可以分享", okButtonTitle:"知道了") { (a) in
            userDefaults.set(1, forKey:"isExplained")
            userDefaults.synchronize()
        }
    }
    private func buildView(){
        self.navigationItem.rightBarButtonItem=UIBarButtonItem.init(title:"说明", style: UIBarButtonItemStyle.done, target:self, action: #selector(showExplained))
        segmentedControl=UISegmentedControl(items:["只能零售","只能批发","可零售可批发"])
        segmentedControl.frame=CGRect.init(x:15, y:15, width:boundsWidth-30, height:40)
        segmentedControl.tintColor=UIColor.applicationMainColor()
        segmentedControl.selectedSegmentIndex=0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: UIControlEvents.valueChanged)
        scrollView.addSubview(segmentedControl)
        table=UITableView(frame:CGRect(x: 0,y: segmentedControl.frame.maxY+5,width: boundsWidth,height: 19*50+280))
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        table.tableFooterView=UIView(frame:CGRect.zero)
        scrollView.addSubview(table)
        userAgreementView=UIView.init()
        userAgreementView.frame=CGRect.init(x:(boundsWidth-(25+143+115+5))/2, y:table.frame.maxY+30, width:(25+143+115+5),height:25)
        scrollView.addSubview(userAgreementView)
        isImg=UIButton(frame: CGRect.init(x:0, y:0, width:25, height: 25))
        isImg.setBackgroundImage(UIImage(named:"register_selected"), for: UIControlState.selected)
        isImg.isSelected=true
        isImg.setBackgroundImage(UIImage(named:"register_select"), for: UIControlState.normal)
        isImg.addTarget(self, action:#selector(isSelectedUserAgreement), for: UIControlEvents.touchUpInside)
        userAgreementView.addSubview(isImg)

        btnUserAgreement=UIButton(frame:CGRect.init(x:isImg.frame.maxX+5, y:0, width:143, height: 25))
        btnUserAgreement.setTitleColor(UIColor.color999(), for: UIControlState.normal)
        btnUserAgreement.setTitle("上传即代表您已经同意", for: UIControlState.normal)
        btnUserAgreement.titleLabel!.font=UIFont.systemFont(ofSize: 14)
        btnUserAgreement.addTarget(self, action:#selector(isSelectedUserAgreement), for: UIControlEvents.touchUpInside)
        userAgreementView.addSubview(btnUserAgreement)

        let btnQualityAssuranceAgreement=UIButton(frame:CGRect.init(x:btnUserAgreement.frame.maxX, y:0, width:115, height: 25))
        btnQualityAssuranceAgreement.setTitle("《质量保证协议》", for: UIControlState.normal)
        btnQualityAssuranceAgreement.titleLabel!.font=UIFont.systemFont(ofSize: 14)
        btnQualityAssuranceAgreement.setTitleColor(UIColor.applicationMainColor(), for: UIControlState.normal)
        userAgreementView.addSubview(btnQualityAssuranceAgreement)

        btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认上传", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btn.frame=CGRect(x:30,y:userAgreementView.frame.maxY+15,width: boundsWidth-60,height: 40)
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)

        scrollView.addSubview(btn)
        scrollView.contentSize=CGSize(width: boundsWidth,height: btn.frame.maxY+30)
    }
    ///选择用户协议
    @objc private func isSelectedUserAgreement(sender:UIButton){
        if isImg.isSelected{
            isImg.isSelected=false
        }else{
            isImg.isSelected=true
        }
    }
    //选择点击后的事件
    @objc func segmentedControlChanged(sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 2{
            self.table.frame=CGRect(x: 0,y: segmentedControl.frame.maxY+5,width: boundsWidth,height: 21*50+280)
        }else if sender.selectedSegmentIndex == 1{
            self.table.frame=CGRect(x: 0,y: segmentedControl.frame.maxY+5,width: boundsWidth,height: 20*50+280)
        }else{
            self.table.frame=CGRect(x: 0,y: segmentedControl.frame.maxY+5,width: boundsWidth,height: 19*50+280)
        }
        userAgreementView.frame=CGRect.init(x:(boundsWidth-(25+143+115+5))/2, y:table.frame.maxY+30, width:(25+143+115+5),height:25)
        btn.frame=CGRect(x: 30,y:userAgreementView.frame.maxY+15,width: boundsWidth-60,height: 40)
        scrollView.contentSize=CGSize(width: boundsWidth,height: btn.frame.maxY+30)
        self.table.reloadData()
    }
}
// MARK: - 提交
extension UploadGoodViewController{
    @objc func submit(){
        let goodInfoName=txtGoodInfoName.text
        let goodUcode=txtGoodUcode.text
        let goodUnit=txtGoodUnit.text
        let goodsPrice=txtGoodsPrice.text
        let stock=txtStock.text
        let goodLife=txtGoodLife.text
        let goodSource=lblGoodSource.text
        var goodService=txtGoodService.text
        var goodInfoCode=txtGoodInfoCode.text
        var goodMixed=txtGoodMixed.text
        var remark=txtRemark.text
        var producer=txtProducer.text
        let sellerAddress=txtSellerAddress.text
        let memberPriceMiniCount=txtMemberPriceMiniCount?.text
        let goodsMemberPrice=txtGoodsMemberPrice?.text
        if goodInfoName == nil || goodInfoName!.count == 0{
            self.showSVProgressHUD("商品名称不能为空", type: HUD.info)
            return
        }
        if goodUcode == nil || goodUcode!.count == 0{
            self.showSVProgressHUD("商品规格不能为空", type: HUD.info)
            return
        }
        if goodUnit == nil || goodUnit!.count == 0{
            self.showSVProgressHUD("商品单位不能为空", type: HUD.info)
            return
        }
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            if goodsPrice == nil || goodsPrice!.count == 0{
                self.showSVProgressHUD("商品价格不能为空", type: HUD.info)
                return
            }
            break
        case 1:
            if goodsMemberPrice == nil || goodsMemberPrice!.count == 0{
                self.showSVProgressHUD("商品批发价不能为空", type: HUD.info)
                return
            }
            if memberPriceMiniCount == nil || memberPriceMiniCount!.count == 0{
                self.showSVProgressHUD("商品起订量不能为空", type: HUD.info)
                return
            }
            break
        case 2:
            if goodsPrice == nil || goodsPrice!.count == 0{
                self.showSVProgressHUD("商品价格不能为空", type: HUD.info)
                return
            }
            if goodsMemberPrice == nil || goodsMemberPrice!.count == 0{
                self.showSVProgressHUD("商品批发价不能为空", type: HUD.info)
                return
            }
            if memberPriceMiniCount == nil || memberPriceMiniCount!.count == 0{
                self.showSVProgressHUD("商品起订量不能为空", type: HUD.info)
                return
            }
            break
        default:break
        }

        if stock == nil || stock!.count == 0{
            self.showSVProgressHUD("商品库存不能为空", type: HUD.info)
            return
        }
        if goodLife == nil || goodLife!.count == 0{
            self.showSVProgressHUD("商品保质期不能为空", type: HUD.info)
            return
        }
        if goodSource == "请选择商品产地"{
            self.showSVProgressHUD("请选择商品产地", type: HUD.info)
            return
        }
        if categoryArr.count == 0{
            self.showSVProgressHUD("选择商品分类", type: HUD.info)
            return
        }
        if producer == nil || producer!.count == 0{
            self.showSVProgressHUD("提供人不能空", type: HUD.info)
            return
        }
        if sellerAddress == nil || sellerAddress!.count == 0{
            self.showSVProgressHUD("提供人地址不能为空", type: HUD.info)
            return
        }
        if imgArr.count == 1{
            self.showSVProgressHUD("请上传商品图片", type: HUD.info)
            return
        }
        if sourceImgArr.count == 1{
            self.showSVProgressHUD("请上传来源信息", type: HUD.info)
            return
        }
        if isImg.isSelected == false{
            self.showSVProgressHUD("请同意质量保证协议", type: HUD.info)
            return
        }
        let fCategoryId=categoryArr[0].goodscategoryId
        let sCategoryId=categoryArr[1].goodscategoryId
        goodService=goodService ?? ""
        goodInfoCode=goodInfoCode ?? ""
        goodMixed=goodMixed ?? ""
        remark=remark ?? ""
        var goodsDetailsPic=""
        producer=producer ?? ""
        if imgArr.count > 2{
            for i in 1..<imgArr.count-1{
                goodsDetailsPic+=imgArr[i]+","
            }
            let index=goodsDetailsPic.characters.index(goodsDetailsPic.endIndex, offsetBy: -1)
            goodsDetailsPic=goodsDetailsPic.substring(to: index)
        }
        var lyPic=""
        var lyMiaoshu=""
        if sourceImgArr.count > 1{
            for i in 0..<sourceImgArr.count-1{
                let entity=sourceImgArr[i]
                entity.lyImg=entity.lyImg ?? ""
                entity.lyMX=entity.lyMX ?? ""
                lyPic+=entity.lyImg!+","
                lyMiaoshu+=entity.lyMX!+","
            }
            let lyPicIndex=lyPic.characters.index(lyPic.endIndex, offsetBy: -1)
            let lyMiaoshuIndex=lyMiaoshu.characters.index(lyMiaoshu.endIndex, offsetBy: -1)
            lyPic=lyPic.substring(to: lyPicIndex)
            lyMiaoshu=lyMiaoshu.substring(to: lyMiaoshuIndex)
        }
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        let storeId=userDefaults.object(forKey: "storeId") as! Int
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.saveGoods(goodInfoName: goodInfoName!, goodUcode: goodUcode!, goodUnit: goodUnit!, goodsPrice: goodsPrice ?? "", stock:Int(stock!)!, goodLife: goodLife!, goodSource: goodSource!, goodService: goodService!, goodPic:imgArr[0], goodsDetailsPic: goodsDetailsPic, goodInfoCode: goodInfoCode!, goodMixed: goodMixed!, remark: remark!, fCategoryId: fCategoryId!, sCategoryId:sCategoryId!,storeId:storeId,lyPic:lyPic,lyMiaoshu:lyMiaoshu,producer:producer!, goodsMemberPrice:goodsMemberPrice ?? "", memberPriceMiniCount:Int(memberPriceMiniCount ?? "0") ?? 0, goodsSaleFlag:segmentedControl.selectedSegmentIndex+1, sellerAddress:sellerAddress!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.dismissHUD()
                let qrcode=json["qrcode"].stringValue
                UIAlertController.showAlertYesNo(self, title:"城乡惠", message:"商品上传成功", cancelButtonTitle:"返回上一页", okButtonTitle:"打印来源二维码", okHandler: { (UIAlertAction) -> Void in
                        self.connectThePrinter(goodInfoName!,code:qrcode)
                    }, cancelHandler: { (UIAlertAction) -> Void in
                        self.navigationController?.popViewController(animated: true)
                })
            }else{
                self.showSVProgressHUD("上传商品失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }

    }
    /**
     连接打印机
     */
    func connectThePrinter(_ goodName:String,code:String){
        let vc=ConnectThePrinterViewController()
        vc.flag=2
        vc.goodName=goodName
        vc.code=code
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
// MARK: - table 协议
extension UploadGoodViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "goodid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"goodid")
        }
        cell!.textLabel!.textColor=UIColor.black
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
        let name=buildLabel(UIColor.textColor(), font:15, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 0,width: 55,height: 50)
        for view in cell!.contentView.subviews{
            view.removeFromSuperview()
        }
        cell!.textLabel!.text=nil
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
            cell!.textLabel!.text="商品基本信息"
            break
            case 1:
                name.attributedText=redText("*商品名")
                cell!.contentView.addSubview(name)
                txtGoodInfoName=buildTxt(14, placeholder:"请输入商品名称", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodInfoName.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodInfoName)

                break
            case 2:

                name.attributedText=redText("*分类")
                cell!.contentView.addSubview(name)
                lblCategory=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
                lblCategory.text="请选择商品分类"
                lblCategory.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(lblCategory)
                cell!.accessoryType = .disclosureIndicator

                break
            case 3:

                name.attributedText=redText("*单位")
                cell!.contentView.addSubview(name)
                txtGoodUnit=buildTxt(14, placeholder:"请输入商品单位,如包,箱等", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodUnit.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodUnit)

                break
            case 4:

                name.attributedText=redText("*规格")
                cell!.contentView.addSubview(name)
                txtGoodUcode=buildTxt(14, placeholder:"请输入商品规格", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodUcode.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodUcode)

                break
            case 5:
                name.text="  条码"
                cell!.contentView.addSubview(name)
                txtGoodInfoCode=buildTxt(14, placeholder:"请输入商品条码(可无)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodInfoCode.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodInfoCode)

                break
            case 6:

                if segmentedControl.selectedSegmentIndex == 1{
                    name.attributedText=redText("*批发价")
                    cell!.contentView.addSubview(name)
                    txtGoodsMemberPrice=buildTxt(14, placeholder:"请输入商品批发价", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.decimalPad)
                    txtGoodsMemberPrice.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    cell!.contentView.addSubview(txtGoodsMemberPrice)
                }else{
                    name.attributedText=redText("*价格")
                    cell!.contentView.addSubview(name)
                    txtGoodsPrice=buildTxt(14, placeholder:"请输入商品单价", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.decimalPad)
                    txtGoodsPrice.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    cell!.contentView.addSubview(txtGoodsPrice)
                }

                break
            case 7:

                if segmentedControl.selectedSegmentIndex == 2{
                    name.attributedText=redText("*批发价")
                    cell!.contentView.addSubview(name)
                    txtGoodsMemberPrice=buildTxt(14, placeholder:"请输入商品批发价", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.decimalPad)
                    txtGoodsMemberPrice.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    cell!.contentView.addSubview(txtGoodsMemberPrice)
                }else{
                    name.attributedText=redText("*起订量")
                    cell!.contentView.addSubview(name)
                    txtMemberPriceMiniCount=buildTxt(14, placeholder:"请输入起订量", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                    txtMemberPriceMiniCount.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    cell!.contentView.addSubview(txtMemberPriceMiniCount)
                }

                break
            case 8:

                name.attributedText=redText("*起订量")
                cell!.contentView.addSubview(name)
                txtMemberPriceMiniCount=buildTxt(14, placeholder:"请输入起订量", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                txtMemberPriceMiniCount.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtMemberPriceMiniCount)

                break
            default:break
            }
        break
        case 1:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="商品其他详细信息"
                break
            case 1:

                name.attributedText=redText("*库存")
                cell!.contentView.addSubview(name)
                txtStock=buildTxt(14, placeholder:"请输入商品库存", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                txtStock.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtStock)

                break
            case 2:

                name.text="保质期"
                cell!.contentView.addSubview(name)
                txtGoodLife=buildTxt(14, placeholder:"请输入商品保质期(天)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                txtGoodLife.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodLife)

                break
            case 3:

                name.attributedText=redText("*产地")
                cell!.contentView.addSubview(name)
                lblGoodSource=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
                lblGoodSource.text="请选择商品产地"
                lblGoodSource.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(lblGoodSource)
                cell!.accessoryType = .disclosureIndicator

                break
            case 4:

                name.text="  售后"
                cell!.contentView.addSubview(name)
                txtGoodService=buildTxt(14, placeholder:"请输入商品售后服务(可无)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodService.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodService)

                break
            case 5:

                name.text="  配料"
                cell!.contentView.addSubview(name)
                txtGoodMixed=buildTxt(14, placeholder:"请输入商品相关配料(可无)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodMixed.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodMixed)

                break
            case 6:

                name.text="  描述"
                cell!.contentView.addSubview(name)
                txtRemark=buildTxt(14, placeholder:"请输入商品描述(可无)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtRemark.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtRemark)

                break
            case 7:

                name.attributedText=redText("*提供人")
                cell!.contentView.addSubview(name)
                txtProducer=buildTxt(14, placeholder:"请输入提供人", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtProducer.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtProducer)

                break
            case 8:
                name.attributedText=redText("*提供人地址")
                name.frame=CGRect.init(x:15, y:0, width:85, height: 50)
                cell!.contentView.addSubview(name)
                txtSellerAddress=buildTxt(14, placeholder:"请输入提供人地址(不用填省市区)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtSellerAddress.frame=CGRect(x:name.frame.maxX+5,y: 0,width: boundsWidth-120,height: 50)
                cell!.contentView.addSubview(txtSellerAddress)
                break
            default:break
            }

            break
        case 2:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="商品的图片信息"
                break
            case 1:
                let layout=UICollectionViewFlowLayout()
                let cellWidth=70
                layout.itemSize=CGSize(width:cellWidth,height:cellWidth)
                layout.scrollDirection = UICollectionViewScrollDirection.horizontal
                layout.minimumLineSpacing = 0;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右

                    collectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 70), collectionViewLayout:layout)
                    collectionView.dataSource=self
                    collectionView.delegate=self
                    collectionView.tag=100
                    collectionView.isScrollEnabled=false
                    collectionView.backgroundColor=UIColor.clear
                    collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCell")
                    cell!.contentView.addSubview(collectionView)
                    let lbl=buildLabel(UIColor.applicationMainColor(), font: 13, textAlignment: NSTextAlignment.left)
                    lbl.frame=CGRect(x: 15,y: collectionView.frame.maxY+10,width: boundsWidth-30,height: 20)
                    lbl.text="第一张为商品封面图片最多4张"
                    cell!.contentView.addSubview(lbl)


                break
            default:break
            }
            break
        case 3:
            if indexPath.row == 0{
                cell!.textLabel!.text="商品的来源信息"
            }else{
                let layout=UICollectionViewFlowLayout()
                let cellWidth=70
                layout.itemSize=CGSize(width:cellWidth,height:100)
                layout.scrollDirection = UICollectionViewScrollDirection.horizontal
                layout.minimumLineSpacing = 0;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右

                    sourceCollectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 100), collectionViewLayout:layout)
                    sourceCollectionView.dataSource=self
                    sourceCollectionView.delegate=self
                    sourceCollectionView.tag=200
                    sourceCollectionView.backgroundColor=UIColor.clear
                    sourceCollectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"SourceCollectionViewCell")
                    cell!.contentView.addSubview(sourceCollectionView)
                    let lbl=buildLabel(UIColor.applicationMainColor(), font: 13, textAlignment: NSTextAlignment.left)
                    lbl.frame=CGRect(x: 15,y: sourceCollectionView.frame.maxY+10,width: boundsWidth-30,height: 20)
                    lbl.text="上传数量不做限制"
                    cell!.contentView.addSubview(lbl)

                cell!.selectionStyle = .none

            }
            break
        default:break
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 || section == 3{
            return 2
        }else if section == 1{
            return 9
        }else{
            if segmentedControl.selectedSegmentIndex == 2{
                return 9
            }else if segmentedControl.selectedSegmentIndex == 1{
                return 8
            }else{
                return 7
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            if indexPath.row == 0{
                return 50
            }else{
                return 130
            }
        }else if indexPath.section == 3{
            if indexPath.row == 0{
                return 50
            }else{
                return 160
            }
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRect.zero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.section == 0{
            if indexPath.row == 2{
                let vc=Level1CategoryViewController()
                let nav=UINavigationController(rootViewController:vc)
                self.present(nav, animated:true, completion:nil)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 3{
                let vc=ShowAddressViewController()
                let nav=UINavigationController(rootViewController:vc)
                self.present(nav, animated:true, completion:nil)
            }
        }
    }

}
// MARK: - 实现协议
extension UploadGoodViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cells=UICollectionViewCell()
        if collectionView.tag == 100{
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            let goodImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 70,height: 70))
            goodImg.layer.borderColor=UIColor.borderColor().cgColor
            goodImg.layer.borderWidth=1
            cell.contentView.addSubview(goodImg)
            if imgArr.count > 1{
                let pic=imgArr[indexPath.row]
                goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "addImg"))
            }else{
                goodImg.image=UIImage(named:"addImg")
            }
           cells=cell
        }else{
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "SourceCollectionViewCell", for: indexPath)
            let goodImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 70,height: 70))
            goodImg.layer.borderColor=UIColor.borderColor().cgColor
            goodImg.layer.borderWidth=1
            cell.contentView.addSubview(goodImg)
            let btnLyInfo=ButtonControl().button(ButtonType.cornerRadiusButton, text:"", textColor: UIColor.black, font:13, backgroundColor: UIColor.white, cornerRadius:10)
            btnLyInfo.frame=CGRect(x: 0,y: 80,width: 70,height: 20)
            btnLyInfo.layer.borderColor=UIColor.borderColor().cgColor
            btnLyInfo.layer.borderWidth=1
            cell.contentView.addSubview(btnLyInfo)
            let entity=sourceImgArr[indexPath.row]
            if entity.lyMX != nil{
                btnLyInfo.setTitle(entity.lyMX, for: UIControlState.normal)
            }else{
                btnLyInfo.setTitle("来源描述", for:UIControlState.normal)
            }
            if sourceImgArr.count > 1{
                entity.lyImg=entity.lyImg ?? ""
                goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+entity.lyImg!), placeholderImage:UIImage(named: "addImg"))
                
            }else{
                goodImg.image=UIImage(named:"addImg")
            }
            cells=cell
        }
        return cells
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100{
            if imgArr.count > 4{
                return 4
            }else{
                return imgArr.count
            }
        }else{
            return sourceImgArr.count
            
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 100{
            if indexPath.row == imgArr.count-1{
                self.choosePicture(1)
            }
        }else{
            if indexPath.row == sourceImgArr.count-1{
                showSourceView()
            }
        }
    }
}
// MARK: - 填写来源信息
extension UploadGoodViewController:UITextViewDelegate{
    //填写来源信息
    func showSourceView(){
        showSourceInfoView=UIView(frame:self.view.bounds)
        showSourceInfoView.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.3)
        self.view.addSubview(showSourceInfoView)
        let qrcodeView=UIView(frame:CGRect(x: 20,y: (boundsHeight-355)/2,width: boundsWidth-40,height: 355))
        qrcodeView.backgroundColor=UIColor.white
        qrcodeView.layer.masksToBounds=true
        qrcodeView.layer.cornerRadius=10
        self.showSourceInfoView.addSubview(qrcodeView)
        let lblTitle=UILabel(frame:CGRect(x: 0,y: 0,width: qrcodeView.frame.width,height: 40))
        lblTitle.text="上传商品来源信息"
        lblTitle.font=UIFont.boldSystemFont(ofSize: 16)
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor=UIColor.applicationMainColor()
        lblTitle.textColor=UIColor.white
        qrcodeView.addSubview(lblTitle)
        
        let lblLyImg=buildLabel(UIColor.black, font:13, textAlignment: NSTextAlignment.left)
        lblLyImg.text="商品来源图片:"
        lblLyImg.frame=CGRect(x: 15,y: lblTitle.frame.maxY+15,width: 150,height: 20)
        qrcodeView.addSubview(lblLyImg)
        
        sourceGoodImg=UIImageView(frame:CGRect(x: 15,y: lblLyImg.frame.maxY+10,width: 70,height: 70))
        sourceGoodImg.layer.borderColor=UIColor.borderColor().cgColor
        sourceGoodImg.layer.borderWidth=1
        sourceGoodImg.isUserInteractionEnabled=true
        sourceGoodImg.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(uploadSourceImg)))
        
        sourceGoodImg.image=UIImage(named:"addImg")
        
        qrcodeView.addSubview(sourceGoodImg)
        
        let lblLyMx=buildLabel(UIColor.black, font:13, textAlignment: NSTextAlignment.left)
        lblLyMx.text="商品来源描述:"
        lblLyMx.frame=CGRect(x: 15,y: sourceGoodImg.frame.maxY+15,width: 150,height: 20)
        qrcodeView.addSubview(lblLyMx)
        
        //文本容器
        textViews=UITextView(frame: CGRect(x: 15,y: lblLyMx.frame.maxY+10,width: qrcodeView.frame.width-30,height: 100));
        textViews.font=UIFont.systemFont(ofSize: 14)
        textViews.layer.borderWidth=0.5
        textViews.layer.cornerRadius=5
        textViews.layer.borderColor=UIColor.borderColor().cgColor
        textViews.placeholder="输入100字以内的商品来源描述(不能带特殊字符)"
        //textView响应弹出键盘
        textViews.resignFirstResponder();
        textViews.isHidden = false
        textViews.delegate=self
        qrcodeView.addSubview(textViews)
        
        let btnCancel=ButtonControl().button(ButtonType.button, text:"关闭", textColor:UIColor.white,font:16,backgroundColor:UIColor.applicationMainColor(),cornerRadius:nil)
        btnCancel.titleLabel!.font=UIFont.boldSystemFont(ofSize: 16)
        btnCancel.frame=CGRect(x: 0,y: textViews.frame.maxY+15,width: qrcodeView.frame.width/2-0.5,height: 40)
        btnCancel.addTarget(self, action:#selector(closeSourceInfoView), for: UIControlEvents.touchUpInside)
        qrcodeView.addSubview(btnCancel)
        let btnOK=ButtonControl().button(ButtonType.button, text:"确定", textColor:UIColor.white,font:16,backgroundColor:UIColor.applicationMainColor(), cornerRadius:nil)
        btnOK.titleLabel!.font=UIFont.boldSystemFont(ofSize: 16)
        btnOK.frame=CGRect(x: qrcodeView.frame.width/2+0.5,y: textViews.frame.maxY+15,width: qrcodeView.frame.width/2-0.5,height: 40)
        btnOK.addTarget(self, action:#selector(okSourceInfoView), for: UIControlEvents.touchUpInside)
        qrcodeView.addSubview(btnOK)
    }
    //关闭
    @objc func closeSourceInfoView(){
        sourceEntity=SourceEntity()
        showSourceInfoView.removeFromSuperview()
    }
    //文本框变化事件
    func textViewDidChange(_ textView: UITextView) {
        let textVStr = textView.text as NSString;
        if textView.text.count >= 100{
            sourceEntity.lyMX=textVStr.substring(to:100)
            textView.text=sourceEntity.lyMX
            self.showSVProgressHUD("字数不能超过100", type: HUD.info)
        }else{
            sourceEntity.lyMX=textView.text
        }
    }
    /**
     保存来源信息
     */
    @objc func okSourceInfoView(_ sender:UIButton){
        if sourceEntity.lyMX == nil || sourceEntity.lyMX!.count == 0{
            self.showSVProgressHUD("来源描述不能为空", type: HUD.info)
            return
        }
        if sourceEntity.lyImg == nil{
            self.showSVProgressHUD("来源图片不能为空", type: HUD.info)
            return
        }
        self.sourceImgArr.insert(sourceEntity,at:self.sourceImgArr.count-1)
        self.sourceCollectionView.reloadData()
        closeSourceInfoView()
    }
    /**
     上传来源图片
     */
    @objc func uploadSourceImg(){
        choosePicture(2)
    }
    //点击view隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
// MARK: - 上传
extension UploadGoodViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
//    选择图像 tag 1是商品上传 2来源图片上传
    func choosePicture(_ tag:Int){
        //图片选择控制器
        let imagePickerController=UIImagePickerController()
        imagePickerController.delegate=self
        imagePickerController.view.tag=tag
        // 设置是否可以管理已经存在的图片
        imagePickerController.allowsEditing = true
        // 判断是否支持相机
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let alert:UIAlertController=UIAlertController(title:"修改个人图像", message:"您可以自己拍照或者从相册中选择", preferredStyle: UIAlertControllerStyle.actionSheet)
            let photograph=UIAlertAction(title:"拍照", style: UIAlertActionStyle.default, handler:{
                Void in
                // 设置类型
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
                
                
            })
            let photoAlbum=UIAlertAction(title:"从相册选择", style: UIAlertActionStyle.default, handler:{
                Void in
                // 设置类型
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                //改navigationBar背景色
                imagePickerController.navigationBar.barTintColor = UIColor.applicationMainColor()
                //改navigationBar标题色
                imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                //改navigationBar的button字体色
                imagePickerController.navigationBar.tintColor = UIColor.white
                self.present(imagePickerController, animated: true, completion: nil)
            })
            let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(photograph)
            alert.addAction(photoAlbum)
            alert.addAction(cancel)
            self.present(alert, animated:true, completion:nil)
            
        }
        
        
    }
    //保存图片至沙盒
    func saveImage(_ currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: Data = UIImageJPEGRepresentation(newImage, percent)!
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent(imageName)
        // 将图片写入文件
        try? imageData.write(to: Foundation.URL(fileURLWithPath: filePath), options: [])
    }
    //实现ImagePicker delegate 事件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image: UIImage!
        // 判断，图片是否允许修改
        if(picker.allowsEditing){
            //裁剪后图片
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            //原始图片
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        // 保存图片至本地，方法见下文
        self.saveImage(image, newSize: CGSize(width:boundsWidth, height:boundsWidth), percent:1, imageName: "currentImage.png")
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("currentImage.png")
        //        let imageData = UIImagePNGRepresentation(savedImage);
        self.showSVProgressHUD("正在上传中...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.goodsUploads(goodsImg:"goodsImg", filePath: filePath), successClosure: { (value) in
            let json=self.swiftJSON(value)
            let pic=json["success"].stringValue
            if pic == "fail"{
                self.showSVProgressHUD("上传图片失败", type: HUD.error)
            }else{
                if picker.view.tag == 1{
                    self.imgArr.insert(pic, at:self.imgArr.count-1)
                    self.collectionView.reloadData()
                }else{
                    
                    self.sourceEntity.lyImg=pic
                    self.sourceGoodImg.sd_setImage(with:Foundation.URL(string:URLIMG+pic))
                }
                self.showSVProgressHUD("上传图片成功", type: HUD.success)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    // 当用户取消时，调用该方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
