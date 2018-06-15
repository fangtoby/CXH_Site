//
//  UpdateMyNumberDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
/// 修改揽件信息
class UpdateMyNumberDetailsViewController:BaseViewController{
    var entity:ExpressmailEntity?
    fileprivate var table:UITableView!
    fileprivate var scrollView:UIScrollView!
    fileprivate var txtValuation:UITextField!
    fileprivate var txtWeight:UITextField!
    fileprivate var txtAmount:UITextField!
    fileprivate var lblFreight:UILabel!
    fileprivate var txtPayType:UITextField!
    fileprivate var txtInputRemarks:UITextField!
    fileprivate var lblExpressName:UILabel!
    fileprivate var txtExpressNo:UITextField!
    fileprivate var lblStoreToHeadquarters:UILabel!
    fileprivate var txtLength:UITextField!
    fileprivate var txtWidth:UITextField!
    fileprivate var txtheight:UITextField!
    fileprivate var freight=""
    fileprivate var storeToHeadquarters=""
    fileprivate var freightEntity:FreightEntity?
    //保存快递公司信息
    fileprivate var expressEntity:ExpressEntity?
    //身份证id  1默认 2表示有身份证信息 3没有身份证信息
    fileprivate var emIdentityId:Int=1
    //保存身份证id
    fileprivate var emId:Int?
    //保存身份证信息
    fileprivate var idCard:String?
    //身份证正面图片
    fileprivate var facePic:String?
    //身份证反面图片
    fileprivate var conPic:String?
    fileprivate var txtSFZ:UITextField!
    fileprivate var facePicImg:UIImageView!
    fileprivate var conPicImg:UIImageView!
    fileprivate var btnEnquiries:UIButton!
    fileprivate var collectionView:UICollectionView!
    fileprivate var imgArr=["addImg"]
    fileprivate var btn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="揽件录入"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        buildView()
    }
    override func navigationShouldPopOnBackButton() -> Bool {
        self.navigationController?.popToRootViewController(animated: true)
        return true
    }
    func buildView(){
        scrollView=UIScrollView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight))
        self.view.addSubview(scrollView)
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 27*50+180))
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        scrollView.addSubview(table)
        btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"录入", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btn.frame=CGRect(x: 30,y: table.frame.maxY+30,width: boundsWidth-60,height: 40)
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(btn)
        scrollView.contentSize=CGSize(width: boundsWidth,height: btn.frame.maxY+30)
        
    }
    @objc func submit(){
        let weight=txtWeight.text
        let amount=txtAmount.text
        var inputRemarks=txtInputRemarks.text
        var expressNo=txtExpressNo.text
        let valuation=txtValuation.text
        let length=txtLength.text
        let width=txtWidth.text
        let height=txtheight.text
        var insuredStatu=1
        var insuredMoney=0
        let userId=userDefaults.object(forKey: "userId") as! Int
        if weight == nil || weight!.count == 0{
            self.showSVProgressHUD("请输入重量", type: HUD.info)
            return
        }
        if amount == nil || amount!.count == 0{
            self.showSVProgressHUD("请输入数量", type: HUD.info)
            return
        }
        if expressEntity == nil{
            self.showSVProgressHUD("请选择物流公司", type: HUD.info)
            return
        }
        if txtSFZ.text == nil || txtSFZ.text!.count == 0{
            self.showSVProgressHUD("身份号码不能为空", type: HUD.info)
            return
        }
        if txtSFZ.text!.count != 15 && txtSFZ.text!.count != 18{
            self.showSVProgressHUD("请输入正确的身份号码", type: HUD.info)
            return
        }
        if emIdentityId == 1{
            self.showSVProgressHUD("请查询身份证有效性", type: HUD.info)
            return
        }
        idCard=txtSFZ.text!
        if emIdentityId == 3{
            if (conPic == nil || conPic!.count == 0) || (facePic == nil || facePic!.count == 0){
                self.showSVProgressHUD("请上传身份证信息", type: HUD.info)
                return
            }
        }
        var packagePic=""
        if imgArr.count > 1{
            for i in 0..<imgArr.count-1{
                packagePic+=imgArr[i]+","
            }
            let index=packagePic.characters.index(packagePic.endIndex, offsetBy:-1)
            packagePic=packagePic.substring(to: index)
            
        }else{
            self.showSVProgressHUD("请上传包裹图片", type: HUD.info)
            return
        }
        if valuation == nil || valuation!.count == 0{
            insuredStatu=1
            insuredMoney=0
        }else{
            insuredStatu=2
            insuredMoney=Int(valuation!)!
        }
        let idCardFlag=emIdentityId == 3 ? 2:1
        inputRemarks=inputRemarks ?? ""
        expressNo=expressNo ?? ""
        self.facePic=self.facePic ?? ""
        self.conPic=self.conPic ?? ""
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.inputExpress(expressmailId: entity!.expressmailId!, weight:weight!, amount:Int(amount!)!, freight:freight, payType:1, inputRemarks: inputRemarks!, expressName:expressEntity!.expressName!, expressCode: expressEntity!.expressCode!, expressNo:expressNo!,userId:userId, userAllSave:nil,storeToHeadquarters:storeToHeadquarters,insuredStatu:insuredStatu,insuredMoney:insuredMoney,height:height,width:width,length:length,moneyToMember:"\(self.freightEntity!.moneyToMember!)",moneyToStore:"\(self.freightEntity!.moneyToStore!)",moneyToCompany:"\(self.freightEntity!.moneyToCompany!)",expressCodeId:self.expressEntity!.expressCodeId!,facePic:self.facePic!,conPic:self.conPic!,idCard:self.idCard!,emIdentityId:self.emId,idCardFlag:idCardFlag,packagePic:packagePic), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.showSVProgressHUD("录入成功", type: HUD.success)
                self.navigationController?.popToRootViewController(animated: true)
            }else if success == "capitalSumMoney"{
                self.showSVProgressHUD("余额不足，不能录入", type: HUD.info)
            }else if success == "expressmailNotExist"{
                self.showSVProgressHUD("邮寄信息不存在", type: HUD.info)
            }else if success == "expressmailStatuError"{
                self.showSVProgressHUD("邮寄状态错误", type: HUD.info)
            }else if success == "expressmailStatuUpdateError"{
                self.showSVProgressHUD("邮寄状态修改错误", type: HUD.info)
            }else if success == "capitalSumMoneyFail"{
                self.showSVProgressHUD("资金扣除失败", type: HUD.info)
            }else if success == "haveNoRight"{
                self.showSVProgressHUD("无权操作", type: HUD.info)
            }else{
                self.showSVProgressHUD("录入失败", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    /**
     计算运费
     
     - parameter expressCode: 快递公司编码
     - parameter weight:      重量kg
     */
    func expressmailFreight(_ expressCode:String,weight:Int,insuredMoney:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.expressmailFreight(expressCode: expressCode, weight: weight,province:entity!.toprovince!,length: txtLength.text,width: txtWidth.text,height: txtheight.text,insuredMoney:insuredMoney,city:entity!.tocity!, county:entity!.tocounty!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            //print(json)
            if success == "success"{
                self.freightEntity=self.jsonMappingEntity(FreightEntity(), object:json.object)
                self.freight=json["sumFreight"].stringValue
                self.storeToHeadquarters=json["storeToHeadquarters"].stringValue
                self.lblFreight.text="总运费:"+self.freight+"元"
                self.lblStoreToHeadquarters.text="城乡运费:"+self.storeToHeadquarters+"元"
                self.txtWeight.isEnabled=false
                self.txtLength.isEnabled=false
                self.txtWidth.isEnabled=false
                self.txtheight.isEnabled=false
                self.txtValuation.isEnabled=false
            }else{
                self.showSVProgressHUD("运费计算错误,请重新选择快递公司", type: HUD.info)
                self.lblExpressName.text="请选择快递公司"
                self.expressEntity=nil
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.info)
        }
    }
    /**
     通过身份证号码查询 是否以前有录入过
     */
    @objc func queryIdentityByEmIdentityId(){
        if txtSFZ.text == nil || txtSFZ.text!.count == 0{
            self.showSVProgressHUD("身份号码不能为空", type: HUD.info)
            return
        }
        if txtSFZ.text!.count != 15 && txtSFZ.text!.count != 18{
            self.showSVProgressHUD("请输入正确的身份号码", type: HUD.info)
            return
        }
        idCard=txtSFZ.text!
        self.showSVProgressHUD("系统正在查询...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryIdentityByEmIdentityId(idCard:idCard!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            //print(json)
            if json.count > 0{
                for(_,value) in json{
                    self.emId=value["emIdentityId"].int
                    if self.emId != nil{
                        self.facePic=value["facePic"].string
                        self.conPic=value["conPic"].string
                        self.emIdentityId=2
                        self.table.reloadRows(at: [IndexPath(row: 4, section: 0)], with: UITableViewRowAnimation.none)
                        //禁用身份证输入
                        self.txtSFZ.isEnabled=false
                    }else{
                        self.updateTable()
                    }
                }
            }else{
                self.updateTable()
            }
            self.dismissHUD()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    func updateTable(){
        self.emIdentityId=3
        self.table.frame=CGRect(x: 0,y: 0,width: boundsWidth,height: 27*50+180+99)
        self.btn.frame=CGRect(x: 30,y: self.table.frame.maxY+30,width: boundsWidth-60,height: 40)
        self.scrollView.contentSize=CGSize(width: boundsWidth,height: self.btn.frame.maxY+30)
        self.table.reloadRows(at: [IndexPath(row:4,section: 0)], with: UITableViewRowAnimation.none)
        //禁用身份证输入
        self.txtSFZ.isEnabled=false
    }
    //上传身份证正面
    @objc func facePicImgUpload(){
        choosePicture(1)
    }
    //上传身份证反面
    @objc func conPicImgUpload(){
        choosePicture(2)
    }

}
// MARK: - table协议
extension UpdateMyNumberDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: .value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 14)
        cell!.textLabel!.textColor=UIColor.color999()
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
        let name=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
        cell!.selectionStyle = .none
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
                name.attributedText=redText("*身份证号码:")
                let size=name.attributedText!.string.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtSFZ=buildTxt(14, placeholder:"请输入寄件人身份证号码", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.default)
                txtSFZ.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-60,height: 50)
                txtSFZ.text=idCard
                cell!.contentView.addSubview(txtSFZ)
                btnEnquiries=ButtonControl().button(ButtonType.button, text:"查询", textColor:UIColor.applicationMainColor(), font:13, backgroundColor:UIColor.clear, cornerRadius:nil)
                btnEnquiries.frame=CGRect(x: boundsWidth-55,y: 15,width: 40,height: 20)
                btnEnquiries.addTarget(self, action:#selector(queryIdentityByEmIdentityId), for: UIControlEvents.touchUpInside)
                cell!.contentView.addSubview(btnEnquiries)
                if emIdentityId == 3{
                    facePicImg=UIImageView(frame:CGRect(x: 20,y: btnEnquiries.frame.maxY+15,width: 128,height: 84))
                    facePicImg.isUserInteractionEnabled=true
                    facePicImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(facePicImgUpload)))
                    cell!.contentView.addSubview(facePicImg)
                    conPicImg=UIImageView(frame:CGRect(x: facePicImg.frame.maxX+20,y: btnEnquiries.frame.maxY+15,width: 128,height: 84))
                    conPicImg.isUserInteractionEnabled=true
                    conPicImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(conPicImgUpload)))
                    cell!.contentView.addSubview(conPicImg)
                    if conPic != nil{
                        conPicImg.sd_setImage(with: Foundation.URL(string:URLIMG+conPic!), placeholderImage:UIImage(named: "conPic"))
                    }else{
                        conPicImg.image=UIImage(named:"conPic")
                    }
                    if facePic != nil{
                        facePicImg.sd_setImage(with: Foundation.URL(string:URLIMG+facePic!), placeholderImage:UIImage(named:"facePic"))
                    }else{
                        facePicImg.image=UIImage(named:"facePic")
                    }
                    btnEnquiries.isHidden=true
                    let ok=UIImageView(frame:CGRect(x: boundsWidth-35,y: 15,width: 20,height: 20))
                    ok.image=UIImage(named: "ok")
                    cell!.contentView.addSubview(ok)
                }else if emIdentityId == 2{
                    btnEnquiries.isHidden=true
                    let ok=UIImageView(frame:CGRect(x: boundsWidth-35,y: 15,width: 20,height: 20))
                    ok.image=UIImage(named: "ok")
                    cell!.contentView.addSubview(ok)
                }
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
                name.attributedText=redText("*重量:")
                let size=name.attributedText!.string.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtWeight=buildTxt(14, placeholder:"请输入重量(kg)填完后不能更改", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.numberPad)
                txtWeight.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtWeight)
                break
            case 2:
                name.attributedText=redText("*数量:")
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtAmount=buildTxt(14, placeholder:"请输入数量", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.numberPad)
                txtAmount.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtAmount)
                break
            case 3:
                name.text="保价金额:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtValuation=buildTxt(14, placeholder:"请输入保价金额(可无)", tintColor:UIColor.color999(), keyboardType:UIKeyboardType.numberPad)
                txtValuation.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtValuation)
                break
            case 4:
                name.text="长:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtLength=buildTxt(14, placeholder:"请输入长度CM(可无)", tintColor:UIColor.color999(), keyboardType:UIKeyboardType.numberPad)
                txtLength.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtLength)
                
                break
            case 5:
                name.text="宽:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtWidth=buildTxt(14, placeholder:"请输入宽度CM(可无)", tintColor:UIColor.color999(), keyboardType:UIKeyboardType.numberPad)
                txtWidth.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtWidth)
            case 6:
                name.text="高:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtheight=buildTxt(14, placeholder:"请输入高度CM(可无)", tintColor:UIColor.color999(), keyboardType:UIKeyboardType.numberPad)
                txtheight.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtheight)
                break
            case 7:
                cell!.textLabel!.text="付款方式:现金支付"
                break
            case 8:
                name.text="备注:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtInputRemarks=buildTxt(14, placeholder:"请输入备注", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.default)
                txtInputRemarks.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtInputRemarks)
                break
            default:break
            }
            break
        case 3:
            switch indexPath.row{
            case 0:
                lblExpressName=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
                lblExpressName.frame=CGRect(x: 15,y: 0,width: boundsWidth-40,height: 50)
                lblExpressName.text="请选择快递公司"
                cell!.contentView.addSubview(lblExpressName)
                cell!.accessoryType = .disclosureIndicator
                break
            case 1:
                lblFreight=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
                lblFreight.text="总运费:(不可输入)"
                lblFreight.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
                cell!.contentView.addSubview(lblFreight)
                break
            case 2:
                lblStoreToHeadquarters=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
                lblStoreToHeadquarters.text="城乡运费:(不可输入)"
                lblStoreToHeadquarters.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
                cell!.contentView.addSubview(lblStoreToHeadquarters)
                break
            case 3:
                name.text="快递号:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtExpressNo=buildTxt(14, placeholder:"快递号(可无)", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.numberPad)
                txtExpressNo.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                txtExpressNo.isEnabled=false
                cell!.contentView.addSubview(txtExpressNo)
                break
            case 4:
                cell!.textLabel!.text="扫条形码获取快递号"
                cell!.accessoryType = .disclosureIndicator
                break
            default:break
            }
            break
        case 4:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                cell!.textLabel!.text="包裹信息"
                break
            case 1:
                let layout=UICollectionViewFlowLayout()
                let cellWidth=70
                layout.itemSize=CGSize(width:cellWidth,height:cellWidth)
                layout.scrollDirection = UICollectionViewScrollDirection.vertical
                layout.minimumLineSpacing = 0;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右
                collectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 70), collectionViewLayout:layout)
                collectionView.dataSource=self
                collectionView.delegate=self
                collectionView.isScrollEnabled=false
                collectionView.backgroundColor=UIColor.clear
                collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCell")
                cell!.contentView.addSubview(collectionView)
                let lbl=buildLabel(UIColor.applicationMainColor(), font: 13, textAlignment: NSTextAlignment.left)
                lbl.frame=CGRect(x: 15,y: collectionView.frame.maxY+10,width: boundsWidth-30,height: 20)
                lbl.text="最多上传4张"
                cell!.contentView.addSubview(lbl)
                break
            default:break
            }
        default:break
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 6
        }else if section == 3{
            return 5
        }else if section == 2{
            return 9
        }else if section == 4{
            return 2
        }else{
            return 6
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if emIdentityId == 3{
            if indexPath.section == 0{
                if indexPath.row == 4{
                    return 149
                }
            }else if indexPath.section == 4{
                if indexPath.row == 1{
                    return 130
                }else{
                    return 50
                }
            }
        }else{
            if indexPath.section == 4{
                if indexPath.row == 1{
                    return 130
                }else{
                    return 50
                }
            }else{
                return 50
            }
        }
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
            if indexPath.row == 4{
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
            if indexPath.row == 8{
                UIAlertController.showAlertYes(self, title:"备注", message:"", okButtonTitle:"确定")
            }
        }else if indexPath.section == 3{
            if indexPath.row == 0{
                let weight=txtWeight.text
                let isNil=isStrNil([txtheight.text,txtWidth.text,txtLength.text])
                var insuredMoney=0
                if txtValuation.text != nil && txtValuation.text!.count > 0{
                    insuredMoney=Int(txtValuation.text!)!
                }
                if weight == nil||weight!.count==0{
                    self.showSVProgressHUD("请输入重量", type: HUD.info)
                }else if !isNil{
                    self.showSVProgressHUD("请填写完整的长,宽,高", type: HUD.info)
                }else{
                    let vc=SelectwlQueryExpresscodeViewController()
                    vc.expressEntity={ (entity) in
                        self.expressEntity=entity
                        self.lblExpressName.text=self.expressEntity!.expressName
                        
                        self.expressmailFreight(self.expressEntity!.expressCode!, weight:Int(weight!)!,insuredMoney:insuredMoney)
                        
                    }
                    let nav=UINavigationController(rootViewController:vc)
                    self.present(nav, animated:true, completion:nil)
                }
            }else if indexPath.row == 4{
                let vc=BarCodeScanningViewController()
                vc.strClosure={ str in
                    self.txtExpressNo.text=str
                }
                self.navigationController?.pushViewController(vc, animated:true)
            }
            
        }
    }
}
// MARK: - 实现协议
extension UpdateMyNumberDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgArr.count > 4{
            return 4
        }else{
            return imgArr.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.choosePicture(3)
    }
}
// MARK: - 上传
extension UpdateMyNumberDetailsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //    选择图像 tag 1正面 2反面 3商品包裹图片
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
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.idCardUploads(idCardImg:"idCardImg", filePath:filePath), successClosure: { (res) in
            let json=self.swiftJSON(res)
            let pic=json["success"].stringValue
            if pic == "fail"{
                self.showSVProgressHUD("上传图片失败", type: HUD.error)
            }else{
                if picker.view.tag == 1{
                    self.facePic=pic
                    self.facePicImg.sd_setImage(with:Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "facePic"))
                }else if picker.view.tag == 2{
                    self.conPic=pic
                    self.conPicImg.sd_setImage(with: Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "conPic"))
                }else{
                    self.imgArr.insert(pic, at:self.imgArr.count-1)
                    self.collectionView.reloadData()
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
