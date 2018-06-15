//
//  TheDeliveryViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 发货
class TheDeliveryViewController:BaseViewController {
    let storeId=userDefaults.object(forKey: "storeId") as! Int
    var orderEntity:OrderEntity?
    var province:String?
    var city:String?
    var county:String?
    fileprivate var table:UITableView!
    fileprivate var expressCode:String?
    fileprivate var lblExpressName:UILabel!
    fileprivate var txtExpressNo:UITextField!
    fileprivate var lblFreight:UILabel!
    fileprivate var lblStoreToHeadquarters:UILabel!
    fileprivate var freight=""
    fileprivate var storeToHeadquarters=""
    fileprivate var txtLength:UITextField!
    fileprivate var txtWidth:UITextField!
    fileprivate var txtheight:UITextField!
    fileprivate var freightEntity:FreightEntity?
    fileprivate var expressCodeId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="确认发货"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.tableFooterView=footerView()
        self.view.addSubview(table)
        self.queryOrderFreightByOrderId()
    }
    func footerView()->UIView{
        let view=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 70))
        let btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认发货", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btn.frame=CGRect(x: 30,y: 30,width: boundsWidth-60,height: 40)
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        return view
    }
    @objc func submit(){
        let userId=userDefaults.object(forKey: "userId") as! Int
        if expressCode == nil{
            self.showSVProgressHUD("请选择物流公司", type: HUD.info)
            return
        }
        if self.txtExpressNo.text == nil || self.txtExpressNo.text!.count == 0{
            self.showSVProgressHUD("物流单号不能为空", type: HUD.info)
            return
        }
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeTodeliver(orderInfoId:orderEntity!.orderInfoId!, storeId: storeId, expressCode: expressCode!, logisticsSN:self.txtExpressNo.text!,freight:freight,storeToHeadquarters:storeToHeadquarters,expressName:self.lblExpressName.text!,userId:userId,moneyToMember:"\(self.freightEntity!.moneyToMember!)",moneyToStore:"\(self.freightEntity!.moneyToStore!)",moneyToCompany:"\(self.freightEntity!.moneyToCompany!)",length:txtLength.text,width:txtWidth.text,height:txtheight.text,expressCodeId:expressCodeId!, whetherExemptionFromPostage:orderEntity!.orderWhetherExemptionFromPostage!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            //print(success)
            if success == "success"{
                self.showSVProgressHUD("发货成功", type: HUD.success)
                //通知订单刷新页面
                NotificationCenter.default.post(name: Notification.Name(rawValue: "NotificationUpdateVC"), object:nil)
                self.navigationController?.popViewController(animated: true)
            }else if success == "error"{
                self.showSVProgressHUD("订单状态不匹配，不能发货", type: HUD.error)
            }else if success == "exist"{
                self.showSVProgressHUD("已经存在发货信息，不能发货", type: HUD.error)
            }else if success == "haveNoRight"{
                self.showSVProgressHUD("无权操作", type: HUD.info)
            }else if success == "notExist"{
                self.showSVProgressHUD("订单不存在", type: HUD.info)
            }else if success == "capitalSumMoney"{
                self.showSVProgressHUD("余额不足,不能发货", type: HUD.info)
            }else if success == "expressExist"{
                self.showSVProgressHUD("第三方快递单号 或者是 MK开头的平台编码已经存在", type: HUD.info)
            }else{
                self.showSVProgressHUD("发货失败", type: HUD.error)
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
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.expressmailFreight(expressCode: expressCode, weight: weight,province:province!,length:txtLength.text,width:txtWidth.text,height:txtheight.text,insuredMoney:insuredMoney,city:city!, county:county!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.freightEntity=self.jsonMappingEntity(FreightEntity(), object:json.object)
                self.freight=json["sumFreight"].stringValue
                self.storeToHeadquarters=json["storeToHeadquarters"].stringValue
                self.lblStoreToHeadquarters.text="城乡运费:"+self.storeToHeadquarters+"元"
                self.lblFreight.text="总运费:"+self.freight+"元"
                self.txtLength.isEnabled=false
                self.txtWidth.isEnabled=false
                self.txtheight.isEnabled=false
            }else{
                self.lblExpressName.text="请选择快递公司"
                self.showSVProgressHUD("运费计算错误,请重新选择快递公司", type: HUD.info)
                self.expressCode=nil
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.info)
        }
    }
    ///查询运费
    private func queryOrderFreightByOrderId(){
        self.showSVProgressHUD("正在加载...", type:HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryOrderFreightByOrderId(orderId:orderEntity!.orderInfoId!), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let success=json["success"].string
            if success == nil{
                self.freightEntity=self.jsonMappingEntity(FreightEntity(), object: json.object)
                if self.freightEntity != nil{
                    self.freight=json["sumFreight"].stringValue
                    self.expressCode=self.freightEntity!.expressCode
                    self.expressCodeId=self.freightEntity!.expressCodeId
                    self.lblExpressName.text=self.freightEntity!.expressName
                    self.storeToHeadquarters=json["storeToHeadquarters"].stringValue
                    self.lblStoreToHeadquarters.text="城乡运费:"+self.storeToHeadquarters+"元"
                    self.lblFreight.text="总运费:"+self.freight+"元"
                    self.txtLength.isEnabled=false
                    self.txtWidth.isEnabled=false
                    self.txtheight.isEnabled=false
                }
            }
            self.dismissHUD()
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
}
// MARK: - table协议
extension TheDeliveryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "id")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"id")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
        switch indexPath.row{
        case 0:
            cell!.textLabel!.text="订单是否包邮"
            if orderEntity!.orderWhetherExemptionFromPostage == 1{
                cell!.detailTextLabel!.text="包邮"
            }else{
                cell!.detailTextLabel!.text="不包邮"
            }
            break
        case 1:
            txtLength=buildTxt(14, placeholder:"请输入长度CM(可无)", tintColor:UIColor.color999(), keyboardType:UIKeyboardType.numberPad)
            txtLength.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
            cell!.contentView.addSubview(txtLength)
            
            break
        case 2:
            txtWidth=buildTxt(14, placeholder:"请输入宽度CM(可无)", tintColor:UIColor.color999(), keyboardType:UIKeyboardType.numberPad)
            txtWidth.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
            cell!.contentView.addSubview(txtWidth)
        case 3:
            txtheight=buildTxt(14, placeholder:"请输入高度CM(可无)", tintColor:UIColor.color999(), keyboardType:UIKeyboardType.numberPad)
            txtheight.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
            cell!.contentView.addSubview(txtheight)
            break
        case 4:
            
            lblExpressName=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
            lblExpressName.frame=CGRect(x: 15,y: 0,width: boundsWidth-40,height: 50)
            lblExpressName.text="请选择快递公司"
            cell!.contentView.addSubview(lblExpressName)
            cell!.accessoryType = .disclosureIndicator
            break
        case 5:
            txtExpressNo=buildTxt(14, placeholder:"物流单号(不可输入)", tintColor:UIColor.color999(), keyboardType: UIKeyboardType.numberPad)
            txtExpressNo.frame=CGRect(x: 15,y: 0,width: boundsWidth-30,height: 50)
            txtExpressNo.isEnabled=false
            cell!.contentView.addSubview(txtExpressNo)
            break
        case 6:
            cell!.textLabel!.text="扫条形码获取快递号"
            cell!.accessoryType = .disclosureIndicator
            break
        case 7:
            lblFreight=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
            lblFreight.frame=CGRect(x: 15,y: 0,width: boundsWidth-40,height: 50)
            lblFreight.text="总运费:(不可输入)"
            cell!.contentView.addSubview(lblFreight)
        case 8:
            lblStoreToHeadquarters=buildLabel(UIColor.black, font:14, textAlignment: NSTextAlignment.left)
            lblStoreToHeadquarters.frame=CGRect(x: 15,y: 0,width: boundsWidth-40,height: 50)
            lblStoreToHeadquarters.text="城乡运费:(不可输入)"
            cell!.contentView.addSubview(lblStoreToHeadquarters)
        default:break
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        if orderEntity!.orderWhetherExemptionFromPostage == 1{//如果包邮
            if indexPath.row == 4{
                let isNil=isStrNil([txtheight.text,txtWidth.text,txtLength.text])
                if !isNil{
                    self.showSVProgressHUD("请填写完整的长,宽,高", type: HUD.info)
                }else{
                    let vc=SelectwlQueryExpresscodeViewController()
                    vc.expressEntity={ (entity) in
                        self.expressCode=entity.expressCode
                        self.lblExpressName.text=entity.expressName
                        self.expressCodeId=entity.expressCodeId
                        self.expressmailFreight(self.expressCode!,weight:self.orderEntity!.orderSumGoodsWeight!,insuredMoney:0)
                    }
                    let nav=UINavigationController(rootViewController:vc)
                    self.present(nav, animated:true, completion:nil)
                }
            }
        }
        if indexPath.row == 6{
            let vc=BarCodeScanningViewController()
            vc.strClosure={ str in
                self.txtExpressNo.text=str
            }
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
}
