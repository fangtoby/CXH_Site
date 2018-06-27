//
//  CourierEntryViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
/// 揽件录入
class CourierEntryViewController:BaseViewController {
    fileprivate var table:UITableView!
    fileprivate var txtFromName:UITextField!
    fileprivate var lblAddress:UILabel!
    fileprivate var txtFromphoneNumber:UITextField!
    fileprivate var txtFromRemarks:UITextField!
    fileprivate var txtToName:UITextField!
    fileprivate var lblToAddress:UILabel!
    fileprivate var txtTodetailAddress:UITextField!
    fileprivate var txtTophoneNumber:UITextField!
    fileprivate var txtToRemarks:UITextField!
    fileprivate var txtValuation:UITextField!
    fileprivate var txtWeight:UITextField!
    fileprivate var txtAmount:UITextField!
    fileprivate var lblFreight:UILabel!
    fileprivate var txtPayType:UITextField!
    fileprivate var txtInputRemarks:UITextField!
    fileprivate var lblExpressName:UILabel!
    fileprivate var txtExpressNo:UITextField!
    fileprivate var txtLength:UITextField!
    fileprivate var txtWidth:UITextField!
    fileprivate var txtheight:UITextField!
    fileprivate var txtSFZ:UITextField!
    fileprivate var fromprovince="湖南省"
    fileprivate var fromcity="湘潭市"
    fileprivate var fromcounty="湘潭县"
    fileprivate var toprovince=""
    fileprivate var tocity=""
    fileprivate var tocounty=""
    ///选择邮寄地址的站点id
    private var storeId:Int?
    fileprivate var lblStoreToHeadquarters:UILabel!
    fileprivate var freight=""
    fileprivate var storeToHeadquarters=""
    fileprivate var freightEntity:FreightEntity?
    fileprivate var addresEnabled=true
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
    //保存快递公司信息
    fileprivate var expressEntity:ExpressEntity?
    fileprivate var facePicImg:UIImageView!
    fileprivate var conPicImg:UIImageView!
    fileprivate var btnEnquiries:UIButton!
    fileprivate var scrollView:UIScrollView!
    fileprivate var btn:UIButton!
    fileprivate var collectionView:UICollectionView!
    fileprivate var imgArr=["addImg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="揽件录入"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        scrollView=UIScrollView(frame:self.view.bounds)
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
        //接收寄件人地区选择的通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddress), name: NSNotification.Name(rawValue: "postUpdateAddress"), object: nil)
        //接收收件人地区选择的通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddress1), name: NSNotification.Name(rawValue: "postUpdateAddress1"), object: nil)
        
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    /**
     实现地区选择协议
     
     - parameter str: 选中的省市区
     */
    @objc func updateAddress(_ obj:Notification) {
        let myAddress=obj.object as? String
        let addressArr=myAddress!.components(separatedBy: "-")
        fromprovince=addressArr[0]
        fromcity=addressArr[1]
        fromcounty=addressArr[2]
        lblAddress!.text=fromprovince+fromcity+fromcounty
    }
    /**
     实现地区选择协议

     - parameter str: 收件人 选中的省市区
     */
    @objc func updateAddress1(_ obj:Notification) {
        let myAddress=obj.object as? String
        let addressArr=myAddress!.components(separatedBy: "-")
        toprovince=addressArr[0]
        tocity=addressArr[1]
        tocounty=addressArr[2]
        if addressArr.count == 4{
            let town=addressArr[3]
            txtTodetailAddress.text=town
        }else if addressArr.count == 5{
            let town=addressArr[3]
            let villages=addressArr[4]
            let userInfo=obj.userInfo as? [String:Any]
            let storeNo=userInfo!["storeNo"] as! String
            storeId=userInfo!["storeId"] as? Int
            if storeNo.count > 0{
                txtTodetailAddress.text=storeNo
            }else{
                txtTodetailAddress.text=town+villages
            }

        }
        lblToAddress.text=toprovince+tocity+tocounty
    }
    @objc func submit(){
        let fromName=txtFromName.text
        let fromphoneNumber=txtFromphoneNumber.text
        var fromRemarks=txtFromRemarks.text
        let toName=txtToName.text
        
        
        let todetailAddress=txtTodetailAddress.text
        let tophoneNumber=txtTophoneNumber.text
        var toRemarks=txtToRemarks.text
        if fromName == nil || fromName!.count == 0{
            self.showSVProgressHUD("寄件人姓名不能为空", type: HUD.info)
            return
        }
        if fromphoneNumber == nil || fromphoneNumber!.count == 0{
            self.showSVProgressHUD("寄件人手机号码不能为空", type: HUD.info)
            return
        }
        if toName == nil || toName!.count == 0{
            self.showSVProgressHUD("收件人姓名不能为空", type:HUD.info)
            return
        }
        if todetailAddress == nil || todetailAddress!.count == 0{
            self.showSVProgressHUD("收件人详细地址不能为空", type: HUD.info)
            return
        }
        if tophoneNumber == nil || tophoneNumber!.count == 0{
            self.showSVProgressHUD("收件人手机号码不能为空", type: HUD.info)
            return
        }
        if fromprovince.count == 0{
            self.showSVProgressHUD("请选择寄件人始发地", type: HUD.info)
            return
        }
        let weight=txtWeight.text
        let amount=txtAmount.text
        var inputRemarks=txtInputRemarks.text
        var expressNo=txtExpressNo.text
        let valuation=txtValuation.text
        var insuredStatu=1
        var insuredMoney=0
        let length=txtLength.text
        let width=txtWidth.text
        let height=txtheight.text
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
            let index=packagePic.characters.index(packagePic.endIndex, offsetBy: -1)
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
        fromRemarks=fromRemarks ?? ""
        toRemarks=toRemarks ?? ""
        self.facePic=self.facePic ?? ""
        self.conPic=self.conPic ?? ""
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.saveExpress(fromName: fromName!.check(), fromprovince:fromprovince, fromcity: fromcity, fromcounty: fromcounty, fromphoneNumber: fromphoneNumber!, fromRemarks: fromRemarks!.check(), toName: toName!.check(), toprovince: toprovince, tocity: tocity, tocounty: tocounty, todetailAddress: todetailAddress!.check(), tophoneNumber: tophoneNumber!, toRemarks: toRemarks!.check(), savaType:2,toStoreId:storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                let expressmailId=json["expressmailId"].intValue
                PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.inputExpress(expressmailId:expressmailId, weight:weight!, amount:Int(amount!)!, freight:self.freight, payType:1, inputRemarks: inputRemarks!, expressName:self.expressEntity!.expressName!, expressCode:self.expressEntity!.expressCode!, expressNo:expressNo!, userId:userId,userAllSave:1,storeToHeadquarters:self.storeToHeadquarters,insuredStatu:insuredStatu,insuredMoney:insuredMoney,height:height ,width:width,length:length,moneyToMember:"\(self.freightEntity!.moneyToMember!)",moneyToStore:"\(self.freightEntity!.moneyToStore!)",moneyToCompany:"\(self.freightEntity!.moneyToCompany!)",expressCodeId:self.expressEntity!.expressCodeId!,facePic:self.facePic!,conPic:self.conPic!,idCard:self.idCard!,emIdentityId:self.emId,idCardFlag:idCardFlag,packagePic:packagePic), successClosure: { (result) -> Void in
                    let json=self.swiftJSON(result)
                    let success=json["success"].stringValue
                    if success == "success"{
                        self.showSVProgressHUD("录入成功", type: HUD.success)
                        self.navigationController?.popToRootViewController(animated:true)
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

            }else{
                self.showSVProgressHUD("邮寄失败", type: HUD.error)
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
        
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.expressmailFreight(expressCode: expressCode, weight: weight,province:toprovince,length:txtLength.text,width:txtWidth.text,height: txtheight.text,insuredMoney:insuredMoney,city:tocity,county:tocounty,storeId:storeId), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
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
                self.addresEnabled=false
            }else{
                self.lblExpressName.text="请选择快递公司"
                self.showSVProgressHUD("运费计算错误,请重新选择快递公司", type: HUD.info)
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
// MARK: - table 协议
extension CourierEntryViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 14)
        cell!.textLabel!.textColor=UIColor.textColor()
        let name=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
        cell!.selectionStyle = .none
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="寄件人信息录入 Shipper information"
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                break
            case 1:
                name.attributedText=redText("*姓名:")
                let size=name.attributedText!.string.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtFromName=buildTxt(14, placeholder:"请输入寄件人姓名", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.default)
                txtFromName.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtFromName)
                break
            case 2:
                lblAddress=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
                lblAddress.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
                lblAddress.text=fromprovince+fromcity+fromcounty
                cell!.contentView.addSubview(lblAddress)
                cell!.accessoryType = .disclosureIndicator
                break
            case 3:
                name.attributedText=redText("*手机号码:")
                let size=name.attributedText!.string.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtFromphoneNumber=buildTxt(14, placeholder:"请输入寄件人手机号码", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.numberPad)
                txtFromphoneNumber.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtFromphoneNumber)
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
                break
            case 5:
                name.text="备注:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtFromRemarks=buildTxt(14, placeholder:"请输入备注", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.default)
                txtFromRemarks.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtFromRemarks)
                break
            default:break
            }
            break
        case 1:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="收件人信息录入 Consignee informationn"
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                break
            case 1:
                name.attributedText=redText("*姓名:")
                let size=name.attributedText!.string.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtToName=buildTxt(14, placeholder:"请输入收件人姓名", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.default)
                txtToName.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtToName)
                break
            case 2:
                lblToAddress=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
                lblToAddress.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
                lblToAddress.text="收件人所属省市区"
                cell!.contentView.addSubview(lblToAddress)
                cell!.accessoryType = .disclosureIndicator
                break
            case 3:
                name.attributedText=redText("*详细地址:")
                let size=name.attributedText!.string.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtTodetailAddress=buildTxt(14, placeholder:"请输入收件人详细地址", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.default)
                txtTodetailAddress.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtTodetailAddress)
                break
            case 4:
                name.attributedText=redText("*手机号码:")
                let size=name.attributedText!.string.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtTophoneNumber=buildTxt(14, placeholder:"请输入收件人手机号码", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.numberPad)
                txtTophoneNumber.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtTophoneNumber)
                break
            case 5:
                name.text="备注:"
                let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 200,height: 20))
                name.frame=CGRect(x: 15,y: 15,width: size.width,height: 20)
                cell!.contentView.addSubview(name)
                txtToRemarks=buildTxt(14, placeholder:"请输入备注", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.default)
                txtToRemarks.frame=CGRect(x: name.frame.maxX,y: 0,width: boundsWidth-name.frame.maxX-15,height: 50)
                cell!.contentView.addSubview(txtToRemarks)
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
                txtAmount.text="1"
                txtAmount.isEnabled=false
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
            break
        default:break
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 6
        }else if section == 3{
            return 5
        }else if section == 2{
            return 9
        }else if section == 1{
            return 6
        }else{
            return 2
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
        if indexPath.section == 0{
            if indexPath.row == 2{
                if addresEnabled{
                    let vc=ShowAddressViewController()
                    let nav=UINavigationController(rootViewController:vc)
                    self.present(nav, animated:true, completion:nil)
                }else{
                    self.showSVProgressHUD("运费计算完毕不能修改地址信息", type: HUD.info)
                }
            }
        }else if indexPath.section == 1{
            if indexPath.row == 2{
                if addresEnabled{
                    let vc=ShowAddressViewController()
                    userDefaults.set(1, forKey:"flag")
                    userDefaults.synchronize()
                    let nav=UINavigationController(rootViewController:vc)
                    self.present(nav, animated:true, completion:nil)
                }else{
                    self.showSVProgressHUD("运费计算完毕不能修改地址信息", type: HUD.info)
                }
            }
        }else if indexPath.section == 3{
            if indexPath.row == 0{
                let weight=txtWeight.text
                var insuredMoney=0
                if txtValuation.text != nil && txtValuation.text!.count > 0{
                    insuredMoney=Int(txtValuation.text!)!
                }
                let isNil=isStrNil([txtheight.text,txtWidth.text,txtLength.text])
                if weight == nil||weight!.count==0{
                    self.showSVProgressHUD("请输入重量", type: HUD.info)
                }else if !isNil{
                    self.showSVProgressHUD("请填写完整的长,宽,高", type: HUD.info)
                }else if toprovince.count == 0{
                    self.showSVProgressHUD("请选择收件人省市区", type: HUD.info)
                    return
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
extension CourierEntryViewController:UICollectionViewDelegate,UICollectionViewDataSource{
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
extension CourierEntryViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.idCardUploads(idCardImg:"idCardImg", filePath: filePath), successClosure: { (res) in
            let json=self.swiftJSON(res)
            let pic=json["success"].stringValue
            if pic == "fail"{
                self.showSVProgressHUD("上传图片失败", type: HUD.error)
            }else{
                if picker.view.tag == 1{
                    self.facePic=pic
                    self.facePicImg.sd_setImage(with: Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "facePic"))
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
