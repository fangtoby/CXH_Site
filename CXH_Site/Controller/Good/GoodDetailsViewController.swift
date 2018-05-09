//
//  GoodDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/4.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 商品详细信息
class GoodDetailsViewController:BaseViewController{
    var goodName:String?
    var goodsbasicInfoId:Int?
    var flag:Int? // 1修改 2不可修改
    fileprivate var entity:GoodDetailsEntity?
    fileprivate var scrollView:UIScrollView!
    private var segmentedControl:UISegmentedControl!
    fileprivate var table:UITableView!
    fileprivate var collectionView:UICollectionView!
    fileprivate var sourceCollectionView:UICollectionView!
    fileprivate var imgArr=[String]()
    fileprivate var sourceArr=[SourceEntity]()
    private var btn:UIButton!
    private var txtGoodsMemberPrice:UITextField!
    private var txtMemberPriceMiniCount:UITextField!
    fileprivate var txtGoodUcode:UITextField!
    fileprivate var txtGoodUnit:UITextField!
    fileprivate var txtGoodsPrice:UITextField!
    fileprivate var txtStock:UITextField!
    fileprivate var txtGoodLife:UITextField!
    //是否同意用户协议
    fileprivate var isImg:UIButton!
    //用户协议文字按
    fileprivate var btnUserAgreement:UIButton!
    //用户协议view
    private var  userAgreementView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == 1{
            self.title=goodName==nil ? "(可修改)":(goodName!+"(可修改)")
        }else{
            self.title=goodName==nil ? "(不可修改)":(goodName!+"(不可修改)")
        }
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        httpGoodDetailsInfo()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissHUD()
    }
    func buildView(){
        scrollView=UIScrollView(frame:self.view.bounds)
        self.view.addSubview(scrollView)
        segmentedControl=UISegmentedControl(items:["只能零售","只能批发","可零售可批发"])
        segmentedControl.frame=CGRect.init(x:15, y:15, width:boundsWidth-30, height:40)
        segmentedControl.tintColor=UIColor.applicationMainColor()
        segmentedControl.selectedSegmentIndex=(entity!.goodsSaleFlag ?? 1)-1
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: UIControlEvents.valueChanged)
        scrollView.addSubview(segmentedControl)
        table=UITableView()
        updateTableHeight()
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        scrollView.addSubview(table)
        if flag != 1{
            segmentedControl.isEnabled=false
            scrollView.contentSize=CGSize(width: boundsWidth,height: table.frame.maxY+30)
            return
        }
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
        btnUserAgreement.setTitle("修改即代表您已经同意", for: UIControlState.normal)
        btnUserAgreement.titleLabel!.font=UIFont.systemFont(ofSize: 14)
        btnUserAgreement.addTarget(self, action:#selector(isSelectedUserAgreement), for: UIControlEvents.touchUpInside)
        userAgreementView.addSubview(btnUserAgreement)

        let btnQualityAssuranceAgreement=UIButton(frame:CGRect.init(x:btnUserAgreement.frame.maxX, y:0, width:115, height: 25))
        btnQualityAssuranceAgreement.setTitle("《质量保证协议》", for: UIControlState.normal)
        btnQualityAssuranceAgreement.titleLabel!.font=UIFont.systemFont(ofSize: 14)
        btnQualityAssuranceAgreement.setTitleColor(UIColor.applicationMainColor(), for: UIControlState.normal)
        userAgreementView.addSubview(btnQualityAssuranceAgreement)

        btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"提交修改", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btn.frame=CGRect(x:30,y:userAgreementView.frame.maxY+15,width: boundsWidth-60,height: 40)
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)

        scrollView.addSubview(btn)
        scrollView.contentSize=CGSize(width: boundsWidth,height: btn.frame.maxY+30)
    }
}
extension GoodDetailsViewController{
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
        updateTableHeight()
        txtMemberPriceMiniCount?.removeFromSuperview()
        txtGoodsMemberPrice?.removeFromSuperview()
        txtGoodsPrice?.removeFromSuperview()
        userAgreementView.frame=CGRect.init(x:(boundsWidth-(25+143+115+5))/2, y:table.frame.maxY+30, width:(25+143+115+5),height:25)
        btn.frame=CGRect(x: 30,y:userAgreementView.frame.maxY+15,width: boundsWidth-60,height: 40)
        scrollView.contentSize=CGSize(width: boundsWidth,height: btn.frame.maxY+30)
        self.table.reloadData()
    }
    ///更新table高度
    private func updateTableHeight(){
        if segmentedControl.selectedSegmentIndex == 2{
            self.table.frame=CGRect(x: 0,y: segmentedControl.frame.maxY+5,width: boundsWidth,height: 21*50+210)
        }else if segmentedControl.selectedSegmentIndex == 1{
            self.table.frame=CGRect(x: 0,y: segmentedControl.frame.maxY+5,width: boundsWidth,height: 20*50+210)
        }else{
            self.table.frame=CGRect(x: 0,y: segmentedControl.frame.maxY+5,width: boundsWidth,height: 19*50+210)
        }
    }
}
// MARK: - table协议
extension GoodDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "goodDetailId")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"goodDetailId")
        }
        cell!.textLabel!.textColor=UIColor.black
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
        let name=buildLabel(UIColor.textColor(), font:15, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 0,width: 55,height: 50)
        let nameValue=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
        nameValue.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
        cell!.textLabel!.text=nil
        for view in cell!.contentView.subviews{
            view.removeFromSuperview()
        }
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="商品基本信息"
                break
            case 1:
                name.text="商品名"
                nameValue.text=entity!.goodInfoName
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 2:
                name.text="  分类"
                nameValue.text=entity!.sCategoryName
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 3:

                name.attributedText=redText(" 单位")
                cell!.contentView.addSubview(name)
                txtGoodUnit=buildTxt(14, placeholder:"请输入商品单位,如包,箱等", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodUnit.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                txtGoodUnit.text=entity!.goodUnit
                cell!.contentView.addSubview(txtGoodUnit)
                if flag != 1{
                    txtGoodUnit.isEnabled=false
                }

                break
            case 4:

                name.attributedText=redText(" 规格")
                cell!.contentView.addSubview(name)
                txtGoodUcode=buildTxt(14, placeholder:"请输入商品规格", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodUcode.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                txtGoodUcode.text=entity!.goodUcode
                cell!.contentView.addSubview(txtGoodUcode)
                if flag != 1{
                    txtGoodUcode.isEnabled=false
                }

                break
            case 5:
                name.text="保质期"
                cell!.contentView.addSubview(name)
                txtGoodLife=buildTxt(14, placeholder:"请输入保质期", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodLife.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                txtGoodLife.text=entity!.goodLife
                cell!.contentView.addSubview(txtGoodLife)
                if flag != 1{
                    txtGoodLife.isEnabled=false
                }

                break
            case 6:

                if segmentedControl.selectedSegmentIndex == 1{
                    name.text="批发价"
                    cell!.contentView.addSubview(name)
                    txtGoodsMemberPrice=buildTxt(14, placeholder:"请输入商品批发价", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.decimalPad)
                    txtGoodsMemberPrice.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    txtGoodsMemberPrice.text=entity!.goodsMemberPrice?.description
                    cell!.contentView.addSubview(txtGoodsMemberPrice)
                    if flag != 1{
                        txtGoodsMemberPrice.isEnabled=false
                    }
                }else{

                    name.text="价格"
                    cell!.contentView.addSubview(name)
                    txtGoodsPrice=buildTxt(14, placeholder:"请输入商品单价", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.decimalPad)
                    txtGoodsPrice.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    txtGoodsPrice.text=entity!.goodsPrice?.description
                    cell!.contentView.addSubview(txtGoodsPrice)
                    if flag != 1{
                        txtGoodsPrice.isEnabled=false
                    }
                }

                break
            case 7:

                if segmentedControl.selectedSegmentIndex == 2{
                    name.text="批发价"
                    cell!.contentView.addSubview(name)
                    txtGoodsMemberPrice=buildTxt(14, placeholder:"请输入商品批发价", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.decimalPad)
                    txtGoodsMemberPrice.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    txtGoodsMemberPrice.text=entity!.goodsMemberPrice?.description
                    cell!.contentView.addSubview(txtGoodsMemberPrice)
                    if flag != 1{
                        txtGoodsMemberPrice.isEnabled=false
                    }
                }else{
                    name.text="起订量"
                    cell!.contentView.addSubview(name)
                    txtMemberPriceMiniCount=buildTxt(14, placeholder:"请输入起订量", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                    txtMemberPriceMiniCount.text=entity!.memberPriceMiniCount?.description
                    txtMemberPriceMiniCount.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                    cell!.contentView.addSubview(txtMemberPriceMiniCount)
                    if flag != 1{
                        txtMemberPriceMiniCount.isEnabled=false
                    }
                }

                break
            case 8:
                name.text="起订量"
                cell!.contentView.addSubview(name)
                txtMemberPriceMiniCount=buildTxt(14, placeholder:"请输入起订量", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                txtMemberPriceMiniCount.text=entity!.memberPriceMiniCount?.description
                txtMemberPriceMiniCount.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtMemberPriceMiniCount)
                if flag != 1{
                    txtMemberPriceMiniCount.isEnabled=false
                }

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
                name.text="  库存"
                cell!.contentView.addSubview(name)
                txtStock=buildTxt(14, placeholder:"请输入库存", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                txtStock.text=entity!.stock?.description
                txtStock.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtStock)
                if flag != 1{
                    txtStock.isEnabled=false
                }
                break
            case 2:
                name.text="  条码"
                nameValue.text=entity!.goodInfoCode
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 3:
                name.text="  产地"
                
                nameValue.text=entity!.goodSource
                
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 4:
                name.text="  售后"
                nameValue.text=entity!.goodService
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 5:
                name.text="  配料"
                nameValue.text=entity!.goodMixed
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 6:
                name.text="  描述"
                nameValue.text=entity!.remark
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 7:
                name.text=" 提供人"
                nameValue.text=entity!.producer
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 8:
                name.text="提供人地址"
                name.frame=CGRect(x: 15,y: 0,width:85,height: 50)
                nameValue.frame=CGRect(x:name.frame.maxX+5,y: 0,width:boundsWidth-120,height: 50)
                nameValue.text=entity!.sellerAddress
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
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
                layout.minimumLineSpacing = 7.5;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右
                collectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 70), collectionViewLayout:layout)
                collectionView.dataSource=self
                collectionView.delegate=self
                collectionView.isScrollEnabled=false
                collectionView.backgroundColor=UIColor.clear
                collectionView.tag=100
                collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCellId")
                cell!.contentView.addSubview(collectionView)
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
                layout.minimumLineSpacing = 7.5;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右
                sourceCollectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 100), collectionViewLayout:layout)
                sourceCollectionView.dataSource=self
                sourceCollectionView.delegate=self
                sourceCollectionView.tag=200
                sourceCollectionView.backgroundColor=UIColor.clear
                sourceCollectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"SourceCollectionViewCell")
                cell!.contentView.addSubview(sourceCollectionView)
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
        if section == 2{
            return 2
        }else if section == 3{
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
            if indexPath.row == 1{
                return 100
            }else{
                return 50
            }
        }else if indexPath.section == 3{
            if indexPath.row == 1{
                return 130
            }else{
                return 50
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
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
// MARK: - 实现协议
extension GoodDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cells=UICollectionViewCell()
        if collectionView.tag == 100{
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellId", for: indexPath)
            let goodImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 70,height: 70))
            goodImg.layer.borderColor=UIColor.borderColor().cgColor
            goodImg.layer.borderWidth=1
            cell.contentView.addSubview(goodImg)
            if imgArr.count > 0{
                let pic=imgArr[indexPath.row]
                goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "default_icon"))
            }else{
                goodImg.image=UIImage(named:"default_icon")
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
            let entity=sourceArr[indexPath.row]
            if entity.miaoshu != nil{
                btnLyInfo.setTitle(entity.miaoshu, for: UIControlState())
            }else{
                btnLyInfo.setTitle("来源描述", for: UIControlState())
            }
            if sourceArr.count > 0{
                entity.testgoodsdetailspic=entity.testgoodsdetailspic ?? ""
                goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+entity.testgoodsdetailspic!), placeholderImage:UIImage(named: "default_icon"))
                
            }else{
                goodImg.image=UIImage(named:"default_icon")
            }
            cells=cell
        }
        return cells
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100{
            return imgArr.count
        }else{
            return sourceArr.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - 网络请求
extension GoodDetailsViewController{
    ///修改商品信息
    @objc private func submit(){
        let goodUnit=txtGoodUnit.text
        let goodUcode=txtGoodUcode.text
        let goodsPrice=txtGoodsPrice.text
        let goodLife=txtGoodLife.text
        let stock=txtStock.text
        let goodsMemberPrice=txtGoodsMemberPrice?.text
        let memberPriceMiniCount=txtMemberPriceMiniCount?.text
        if stock == nil || stock!.count == 0{
            self.showSVProgressHUD("商品库存不能为空", type: HUD.info)
            return
        }
        if goodLife == nil || goodLife!.count == 0{
            self.showSVProgressHUD("商品保质期不能为空", type: HUD.info)
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
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)


        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.updateGoods(goodsbasicInfoId:goodsbasicInfoId!, goodUnit: goodUnit!, goodUcode: goodUcode!, goodsPrice: goodsPrice, goodLife: goodLife!, stock:Int(stock!)!, storeId:entity!.storeId!, goodsSaleFlag: segmentedControl.selectedSegmentIndex+1, goodsMemberPrice:goodsMemberPrice, memberPriceMiniCount: memberPriceMiniCount==nil ? nil : Int(memberPriceMiniCount!)), successClosure: { (any) in
            let success=self.swiftJSON(any)["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("修改成功", type: HUD.success)
                self.navigationController?.popViewController(animated:true)
            }else{
                self.showSVProgressHUD("修改失败", type: HUD.success)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    func httpGoodDetailsInfo(){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.getGoodsById(goodsbasicInfoId: goodsbasicInfoId!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            self.entity=self.jsonMappingEntity(GoodDetailsEntity(), object:json["ga"].object)
            self.entity!.sCategoryName=json["sCategoryName"].string
            self.imgArr.append(self.entity!.goodPic!)
            for(_,value) in json["goodsdetailspic"]{
                let imgPic=value["goodsDetailsPic"].stringValue
                self.imgArr.append(imgPic)
            }
            for(_,value) in json["tg"]{
                let entity=self.jsonMappingEntity(SourceEntity(), object: value.object)
                self.sourceArr.append(entity!)
            }
            self.buildView()
            self.dismissHUD()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
