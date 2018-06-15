//
//  SweepCodeCourierDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/22.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
/// 扫码揽件详情
class SweepCodeCourierDetailsViewController:BaseViewController{
    var entity:ExpressmailEntity?
    var codeInfo:String?
    fileprivate var table:UITableView!
    fileprivate var scrollView:UIScrollView!
    fileprivate var txtWeight:UITextField!
    fileprivate var txtLength:UITextField!
    fileprivate var txtWidth:UITextField!
    fileprivate var txtHeight:UITextField!
    fileprivate var btnQs:UIButton!
    fileprivate var btnUpdate:UIButton!
    fileprivate var collectionView:UICollectionView!
    fileprivate var imgArr=[String]()
    fileprivate var userId=userDefaults.object(forKey: "userId") as! Int
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="揽件详情"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        if entity!.packagePic != nil{
            imgArr=entity!.packagePic!.components(separatedBy: ",")
        }
        buildView()
    }
    override func navigationShouldPopOnBackButton() -> Bool {
        self.navigationController?.popToRootViewController(animated: true)
        return true
    }
    func buildView(){
        scrollView=UIScrollView(frame:self.view.bounds)
        self.view.addSubview(scrollView)
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 27*50+220))
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        table.tableFooterView=footerView()
        scrollView.addSubview(table)
        scrollView.contentSize=CGSize(width: boundsWidth,height: table.frame.maxY+10)
    }
    func footerView() -> UIView{
        let view=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 80))
        let btnWidth=(boundsWidth-45)/2
        btnQs=ButtonControl().button(ButtonType.cornerRadiusButton, text:"揽件", textColor:UIColor.white, font:15, backgroundColor: UIColor.applicationMainColor(), cornerRadius:5)
        btnQs.frame=CGRect(x: 15,y: 20,width: btnWidth,height: 40)
        btnQs.addTarget(self, action:#selector(signOn), for: UIControlEvents.touchUpInside)
        if entity!.status == 5{
            self.btnQs.disable()
            self.btnQs.setTitle("已揽件", for: UIControlState())
        }
        view.addSubview(btnQs)
        
//        let btnTj=ButtonControl().button(ButtonType.cornerRadiusButton, text:"退回", textColor:UIColor.whiteColor(), font:15, backgroundColor: UIColor.applicationMainColor(), cornerRadius:5)
//        btnTj.frame=CGRectMake(CGRectGetMaxX(btnQs.frame)+15,20,btnWidth,30)
//        view.addSubview(btnTj)
        
        btnUpdate=ButtonControl().button(ButtonType.cornerRadiusButton, text:"修改", textColor:UIColor.white, font:15, backgroundColor: UIColor.applicationMainColor(), cornerRadius:5)
        if entity!.status == 7{//修改中
            btnUpdate.disable()
            self.btnUpdate.setTitle("修改中", for: UIControlState())
        }
        btnUpdate.frame=CGRect(x: btnQs.frame.maxX+15,y: 20,width: btnWidth,height: 40)
        btnUpdate.addTarget(self,action:#selector(update), for: UIControlEvents.touchUpInside)
        view.addSubview(btnUpdate)
        
        return view
    }
}
// MARK: - table协议
extension SweepCodeCourierDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: .value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.textLabel!.textColor=UIColor.color666()
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                cell!.textLabel!.text="寄件人信息录入 Shipper information"
                break
            case 1:
                if entity!.fromName != nil{
                    cell!.textLabel!.text="姓名:\(entity!.fromName!)"
                }
                break
            case 2:
                if entity!.fromprovince != nil{
                    cell!.textLabel!.text="始发地:\(entity!.fromprovince!+entity!.fromcity!+entity!.fromcounty!)"
                }
                break
            case 3:
                if entity!.fromphoneNumber != nil{
                    cell!.textLabel!.text="电话:\(entity!.fromphoneNumber!)"
                }
                break
            case 4:
                if entity!.idCard != nil{
                    cell!.textLabel!.text="身份证:\(entity!.idCard!)"
                }
                break
            case 5:
                if entity!.fromRemarks != nil{
                    cell!.textLabel!.text="备注:\(entity!.fromRemarks!)"
                    cell!.accessoryType = .disclosureIndicator
                }else{
                    cell!.textLabel!.text="备注:"
                }
                break
            default:break
            }
            break
        case 1:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                cell!.textLabel!.text="收件人信息录入 Consignee informationn"
                break
            case 1:
                if entity!.toName != nil{
                    cell!.textLabel!.text="姓名:\(entity!.toName!)"
                }
                break
            case 2:
                if entity!.toprovince != nil{
                    cell!.textLabel!.text="收货地区:\(entity!.toprovince!+entity!.tocity!+entity!.tocounty!)"
                }
                break
            case 3:
                if entity!.todetailAddress != nil{
                    cell!.textLabel!.text="详细地址:\(entity!.todetailAddress!)"
                    cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                }
                break
            case 4:
                if entity!.tophoneNumber != nil{
                    cell!.textLabel!.text="电话:\(entity!.tophoneNumber!)"
                }
                break
            case 5:
                if entity!.toRemarks != nil{
                    cell!.textLabel!.text="备注:\(entity!.toRemarks!)"
                    cell!.accessoryType = .disclosureIndicator
                }else{
                    cell!.textLabel!.text="备注:"
                }
                break
            default:break
            }
            break
        case 2:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                cell!.textLabel!.text="费用及付款方式 Charge and payment"
                break
            case 1:
                if entity!.weight != nil{
                    cell!.textLabel!.text="重量:"
                    txtWeight=buildTxt(15, placeholder:"\(entity!.weight!)(可修改)", tintColor:UIColor.color666(), keyboardType: UIKeyboardType.numberPad)
                    txtWeight.frame=CGRect(x: 50,y: 0,width: boundsWidth-75,height: 50)
                    txtWeight.text="\(entity!.weight!)"
                }
                cell!.contentView.addSubview(txtWeight)
                break
            case 2:
                if entity!.amount != nil{
                    cell!.textLabel!.text="数量:\(entity!.amount!)"
                }
                break
            case 3:
                cell!.textLabel!.text="长:"
                txtLength=buildTxt(15, placeholder:"", tintColor:UIColor.color666(), keyboardType: UIKeyboardType.numberPad)
                txtLength.frame=CGRect(x: 50,y: 0,width: boundsWidth-75,height: 50)
                if entity!.length == nil{
                    txtLength.placeholder="无(可修改)"
                }else{
                    txtLength.placeholder="\(entity!.length!)(可修改)"
                }
                cell!.contentView.addSubview(txtLength)
            case 4:
                cell!.textLabel!.text="宽:"
                txtWidth=buildTxt(15, placeholder:"", tintColor:UIColor.color666(), keyboardType: UIKeyboardType.numberPad)
                txtWidth.frame=CGRect(x: 50,y: 0,width: boundsWidth-75,height: 50)
                if entity!.width == nil{
                    txtWidth.placeholder="无(可修改)"
                }else{
                    txtWidth.placeholder="\(entity!.width!)(可修改)"
                }
                cell!.contentView.addSubview(txtWidth)
            case 5:
                cell!.textLabel!.text="高:"
                txtHeight=buildTxt(15, placeholder:"", tintColor:UIColor.color666(), keyboardType: UIKeyboardType.numberPad)
                txtHeight.frame=CGRect(x: 50,y: 0,width: boundsWidth-75,height: 50)
                if entity!.height == nil{
                    txtHeight.placeholder="无(可修改)"
                }else{
                    txtHeight.placeholder="\(entity!.height!)(可修改)"
                }
                cell!.contentView.addSubview(txtHeight)
                break
            case 6:
                if entity!.freight != nil{
                    cell!.textLabel!.text="总运费:\(entity!.freight!)元"
                }else{
                    cell!.textLabel!.text="总运费:0元"
                }
                break
            case 7:
                if entity!.storeToHeadquarters != nil{
                    cell!.textLabel!.text="城乡运费:\(entity!.storeToHeadquarters!)元"
                }else{
                    cell!.textLabel!.text="城乡运费:0元"
                }
                break
            case 8:
                if entity!.insuredMoney != nil{
                    cell!.textLabel!.text="保价金额:\(entity!.insuredMoney!)元"
                }else{
                    cell!.textLabel!.text="保价金额:0元"
                }
                break
            case 9:
                if entity!.payType == 2{
                    cell!.textLabel!.text="付款方式:线上支付"
                }else{
                    cell!.textLabel!.text="付款方式:现金支付"
                }
                break
            case 10:
                if entity!.expressName != nil {
                    cell!.textLabel!.text="快递公司:\(entity!.expressName!)"
                }
                break
            case 11:
                if entity!.expressNo != nil {
                    cell!.textLabel!.text="快递单号:\(entity!.expressNo!)"
                }else{
                    cell!.textLabel!.text="快递单号:无"
                }
                break
            case 12:
                if entity!.inputRemarks != nil{
                    cell!.textLabel!.text="备注:\(entity!.inputRemarks!)"
                    cell!.accessoryType = .disclosureIndicator
                }else{
                    cell!.textLabel!.text="备注:"
                }
            case 13:
                if entity!.status != nil{
                    cell!.textLabel!.textColor=UIColor.applicationMainColor()
                    switch entity!.status! {
                    case 1:
                        cell!.textLabel!.text="状态:站点待录入"
                        break
                    case 2:
                        cell!.textLabel!.text="状态:站点已录入"
                        break
                    case 3:
                        cell!.textLabel!.text="状态:已过期"
                        break
                    case 4:
                        cell!.textLabel!.text="状态:司机已签收"
                        break
                    case 5:
                        cell!.textLabel!.text="状态:总仓签收"
                        break
                    case 6:
                        cell!.textLabel!.text="状态:出库"
                        break
                    case 7:
                        cell!.textLabel!.text="状态:修改中"
                        break
                    default:break
                    }
                }else{
                    cell!.textLabel!.text="状态:无"
                }
                break
            default:break
            }
            break
        case 3:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="包裹信息"
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
                collectionView.backgroundColor=UIColor.clear
                collectionView.tag=100
                collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCellId")
                cell!.contentView.addSubview(collectionView)
                break
            default:break
            }
            
            break
        default:break
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 6
        }else if section == 1{
            return 6
        }else if section == 3{
            return 2
        }else{
            return 14
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3{
            if indexPath.row == 1{
                return 100
            }else{
                return 50
            }
        }else{
            return 50
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.section == 0{
            if indexPath.row == 5{
                if entity!.fromRemarks != nil{
                    UIAlertController.showAlertYes(self, title:"备注", message:entity!.fromRemarks!, okButtonTitle:"确定")
                }
            }
        }else if indexPath.section == 1{
            if indexPath.row  == 3{
                UIAlertController.showAlertYes(self, title:"详细地址", message:entity!.todetailAddress!, okButtonTitle:"确定")
            }else if indexPath.row == 5{
                if entity!.toRemarks != nil{
                    UIAlertController.showAlertYes(self, title:"备注", message:entity!.toRemarks!, okButtonTitle:"确定")
                }
            }
        }else if indexPath.section == 2{
            if indexPath.row == 12{
                if entity!.inputRemarks != nil{
                    UIAlertController.showAlertYes(self, title:"备注", message:entity!.inputRemarks!, okButtonTitle:"确定")
                }
            }
        }
    }
}
// MARK: - 实现协议
extension SweepCodeCourierDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellId", for: indexPath)
        let goodImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 70,height: 70))
        goodImg.layer.borderColor=UIColor.borderColor().cgColor
        goodImg.layer.borderWidth=1
        cell.contentView.addSubview(goodImg)
        if imgArr.count > 0{
            let pic=imgArr[indexPath.row]
            goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "addImg"))
        }else{
            goodImg.image=UIImage(named:"addImg")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgArr.count
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
// MARK: - 操作
extension SweepCodeCourierDetailsViewController{
    @objc func update(){
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        if txtWeight.text != nil && txtWeight.text!.count == 0{
            self.showSVProgressHUD("重量不能为空", type: HUD.info)
            return
        }
        let isNil=isStrNil([txtHeight.text,txtWidth.text,txtLength.text])
        if !isNil {
            self.showSVProgressHUD("请填写完整的长,宽,高", type: HUD.info)
            return
        }
        entity!.insuredMoney=entity!.insuredMoney ?? 0
        self.expressmailFreight(entity!.expressCode!,weight:Int(txtWeight.text!)!,insuredMoney:Int(entity!.insuredMoney!))
    }
    /**
     计算运费
     
     - parameter expressCode: 快递公司编码
     - parameter weight:      重量kg
     */
    func expressmailFreight(_ expressCode:String,weight:Int,insuredMoney:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.expressmailFreight(expressCode: expressCode, weight: weight,province:entity!.toprovince!,length:txtLength.text,width:txtWidth.text,height:txtHeight.text,insuredMoney:insuredMoney,city:entity!.tocity!, county:entity!.tocounty!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            //print("运费:\(json)")
            let success=json["success"].stringValue
            if success == "success"{
                let freightEntity=self.jsonMappingEntity(FreightEntity(), object:json.object)
                PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updateExpressmailInfoByHeadquarters(expressmailId:self.entity!.expressmailId!, expressLinkId:self.entity!.expressLinkId!, userId:self.userId, weight:weight, freight:"\(freightEntity!.sumFreight!)", moneyToMember:"\(freightEntity!.moneyToMember!)", moneyToStore: "\(freightEntity!.moneyToStore!)", moneyToCompany: "\(freightEntity!.moneyToCompany!)", length:self.txtLength.text, width:self.txtWidth.text, height:self.txtHeight.text), successClosure: { (result) -> Void in
                    let json=self.swiftJSON(result)
                    let success=json["success"].stringValue
                    if success == "success"{
                        self.dismissHUD()
                        UIAlertController.showAlertYes(self, title:"修改成功", message:"修改前重量:\(self.entity!.weight!),修改后重量:\(self.txtWeight!.text!),修改前运费:\(self.entity!.freight!),修改后运费:\(freightEntity!.sumFreight!),请等待站点确认", okButtonTitle:"确认")
                        self.btnUpdate.disable()
                        self.btnQs.disable()
                        self.btnUpdate.setTitle("修改中", for: UIControlState.normal)
                    }else if success == "exist"{
                        self.showSVProgressHUD("修改后的重量小于或等于原重量。 不能修改", type: HUD.info)
                    }else if success == "notExist"{
                        self.showSVProgressHUD("录入/或邮寄信息不存在", type: HUD.info)
                    }else if success == "notGive"{
                        self.showSVProgressHUD("司机未签收或总仓已经签收，不能修改", type: HUD.info)
                    }else{
                        self.showSVProgressHUD("保存修改记录信息出错", type: HUD.error)
                    }
                    }, failClosure: { (errorMsg) -> Void in
                        self.showSVProgressHUD(errorMsg!, type: HUD.error)
                })
            }else{
                self.showSVProgressHUD("运费计算错误,请重新选择快递公司", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.info)
        }
    }
    //签收
    @objc func signOn(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.scanCodeGetExpressmailForGivestoragByHeadquarters(codeInfo:codeInfo!, userId:userId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("签收揽件成功", type: HUD.success)
                self.btnQs.disable()
                self.btnUpdate.disable()
                self.btnQs.setTitle("已揽件", for: UIControlState())
            }else if success == "exist"{
                self.showSVProgressHUD("此揽件已经被接收过", type: HUD.error)
            }else if success == "notGive"{
                self.showSVProgressHUD("快递暂时未由司机录入，不能揽件", type: HUD.error)
            }else if success == "notExist"{
                self.showSVProgressHUD("揽件不存在", type: HUD.error)
            }else{
                self.showSVProgressHUD("揽件失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
