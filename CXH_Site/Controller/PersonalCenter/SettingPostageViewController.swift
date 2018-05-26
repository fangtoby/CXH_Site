//
//  SettingPostageViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/22.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
///设置邮费
class SettingPostageViewController:BaseViewController {
    private var table:UITableView!
    private var txt:UITextField?
    private var sw:UISwitch?
    private var segmentedControl:UISegmentedControl!
    private var entity:StorePostageEntity?
    private var storeId=userDefaults.object(forKey:"storeId") as! Int
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="订单包邮设置"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.dataSource=self
        table.delegate=self
        table.tableHeaderView=headerView()
        table.tableFooterView=footerView()
        self.view.addSubview(table)
        self.showSVProgressHUD("正在查询...",type: HUD.textClear)
        queryStorePostage()
    }
    private func headerView() -> UIView{
        let view=UIView.init(frame: CGRect.init(x:0, y:0, width:boundsWidth, height:70))
        view.backgroundColor=UIColor.viewBackgroundColor()
        segmentedControl=UISegmentedControl(items:["包邮","满多少元包邮","不包邮"])
        segmentedControl.frame=CGRect.init(x:15, y:15, width:boundsWidth-30, height:40)
        segmentedControl.tintColor=UIColor.applicationMainColor()
        segmentedControl.selectedSegmentIndex=0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: UIControlEvents.valueChanged)
        view.addSubview(segmentedControl)
        return view
        
    }
    private func footerView() -> UIView{
        let view=UIView(frame: CGRect.init(x:0, y:0, width:boundsWidth, height:80))
        let btn=UIButton.init(frame: CGRect.init(x:30, y:20, width:boundsWidth-60, height:40))
        btn.backgroundColor=UIColor.applicationMainColor()
        btn.layer.cornerRadius=5
        btn.titleLabel?.font=UIFont.systemFont(ofSize:15)
        btn.setTitle("提交", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        return view
    }

    @objc private func segmentedControlChanged(){
        entity?.whetherExemptionFromPostage=segmentedControl.selectedSegmentIndex+1
        self.table.reloadData()
    }
    ///提交
    @objc private func submit(){
        self.showSVProgressHUD("正在加载...",type:HUD.textClear)
        let specifiedAmountExemptionFromPostage=txt?.text
        if entity!.whetherExemptionFromPostage == 2{
            if specifiedAmountExemptionFromPostage == nil || specifiedAmountExemptionFromPostage!.count == 0{
                self.showSVProgressHUD("包邮金额金额不能为空", type: HUD.info)
                return
            }
        }
        if entity!.expressCodeId == nil{
            self.showSVProgressHUD("请选择快递公司", type: HUD.info)
            return
        }

        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.updateStorePostage(storeId:storeId, specifiedAmountExemptionFromPostage:entity!.whetherExemptionFromPostage!==2 ? (Double(specifiedAmountExemptionFromPostage!)!):0, expressCodeId:entity!.expressCodeId, storePostageId:entity!.storePostageId,whetherExemptionFromPostage:entity!.whetherExemptionFromPostage!), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let success=json["success"].stringValue
            print(json)
            if success == "success"{
                self.showSVProgressHUD("修改成功", type: HUD.success)
            }else{
                self.showSVProgressHUD("修改失败", type: HUD.error)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///选择是否包邮
    @objc private func isOn(){
        entity?.whetherExemptionFromPostage=sw!.isOn==true ? 1:2
        self.table.reloadData()
    }
    ///查询包邮信息
    private func queryStorePostage(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStorePostage(storeId:storeId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            self.entity=StorePostageEntity(JSONString:json.description)
            if self.entity == nil{
                self.entity=StorePostageEntity()
                self.entity?.whetherExemptionFromPostage=1//默认包邮
            }
            self.segmentedControl.selectedSegmentIndex=self.entity!.whetherExemptionFromPostage!-1
            self.table.reloadData()
            self.dismissHUD()
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
}
extension SettingPostageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel?.font=UIFont.systemFont(ofSize:15)
        cell!.contentView.viewWithTag(11)?.removeFromSuperview()
        if indexPath.row == 0{
            if entity?.whetherExemptionFromPostage == 2{//如果包邮
                cell!.textLabel!.text="商品包邮金额"
                txt=buildTxt(14, placeholder:"请输入包邮金额(默认0元包邮)", tintColor: UIColor.color666(), keyboardType: UIKeyboardType.numberPad)
                txt!.frame=CGRect.init(x:110, y:10, width:boundsWidth-125, height: 30)
                txt!.text=entity?.specifiedAmountExemptionFromPostage?.description
                txt!.textAlignment = .right
                txt!.tag=11
                cell!.contentView.addSubview(txt!)
                cell!.accessoryType = .none
            }else{
                cell!.textLabel!.text="快递公司"
                cell!.detailTextLabel?.text=entity?.expressName
                cell!.accessoryType = .disclosureIndicator
            }
        }else if indexPath.row == 1{
            cell!.textLabel!.text="快递公司"
            cell!.detailTextLabel?.text=entity?.expressName
            cell!.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if entity?.whetherExemptionFromPostage == 2{
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.row == 0{
            if entity?.whetherExemptionFromPostage != 2{
                pushSelectwlQueryExpresscodeVC()
            }
        }else{
            pushSelectwlQueryExpresscodeVC()
        }
    }
    private func pushSelectwlQueryExpresscodeVC(){
        let vc=SelectwlQueryExpresscodeViewController()
        vc.expressEntity={ (entity) in
            self.entity?.expressName=entity.expressName
            self.entity?.expressCodeId=entity.expressCodeId
            self.table.reloadData()
        }
        let nav=UINavigationController(rootViewController:vc)
        self.present(nav, animated:true, completion:nil)
    }
}