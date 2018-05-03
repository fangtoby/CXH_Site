//
//  InboxDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/21.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 收件详情
class InboxDetailsViewController:BaseViewController{
    //接收收件详情
    var entity:ExpressmailStorageEntity?
    fileprivate var table:UITableView!
    fileprivate let identity=userDefaults.object(forKey: "identity") as! Int
    fileprivate let userId=userDefaults.object(forKey: "userId") as! Int
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="收件详情"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.delegate=self
        table.dataSource=self
        if identity != 1{
            table.tableFooterView=UIView(frame:CGRect.zero)
        }else{
            table.tableFooterView=footerView()
        }
        self.view.addSubview(table)
    }
    func footerView() -> UIView{
        let view=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 90))
        let btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"代签收", textColor:UIColor.white, font:15,backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btn.frame=CGRect(x: 30,y: 25,width: boundsWidth-60,height: 40)
        btn.addTarget(self, action:#selector(replaceSignForUser), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        return view
    }
    //代签收
    @objc func replaceSignForUser(){
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.replaceSignForUser(userId:userId, expressmailStorageId: entity!.expressmailStorageId!, identity: identity), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            print(success)
            if success == "success"{
                self.showSVProgressHUD("代签收成功", type: HUD.success)
                if self.identity != 1{
                    self.table.mj_header.beginRefreshing()
                }else{
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else if success == "haveNoRight"{
                self.showSVProgressHUD("无权操作", type: HUD.info)
            }else if success == "emsNotExist"{
                self.showSVProgressHUD("快件不存在", type: HUD.info)
            }else if success == "noSign"{
                self.showSVProgressHUD("会员已经签收或者已被代签收", type: HUD.info)
            }else{
                self.showSVProgressHUD("代签收失败", type: HUD.info)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }

}
// MARK: - table协议
extension InboxDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: .value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
        
            switch indexPath.row{
            case 0:
                if entity!.expressmailStorageToCompanySN != nil{
                    cell!.textLabel!.text="单号:\(entity!.expressmailStorageToCompanySN!)"
                }else{
                   if entity!.expressmailStorageSN != nil{
                        cell!.textLabel!.text="单号:\(entity!.expressmailStorageSN!)"
                    }
                }
                break
            case 1:
                if entity!.expressmailStorageForExpressName != nil{
                    cell!.textLabel!.text="快递公司:\(entity!.expressmailStorageForExpressName!)"
                }
                break
            case 2:
                if entity!.expressmailStorageName != nil{
                    cell!.textLabel!.text="收件人姓名:\(entity!.expressmailStorageName!)"
                }
                break
            case 3:
                if entity!.expressmailStoragePhoneNumber != nil{
                    cell!.textLabel!.text="收件人电话:\(entity!.expressmailStoragePhoneNumber!)"
                    cell!.accessoryType = .disclosureIndicator
                }
                break
            case 4:
                if entity!.ctime != nil{
                    cell!.textLabel!.text="创建时间:\(entity!.ctime!)"
                }
                break
            case 5:
                if entity!.addMoneyStatu != nil{
                    if entity!.addMoneyStatu == 1{
                        cell!.textLabel!.text="是否加钱:不加钱"
                    }else if entity!.addMoneyStatu == 2{
                        cell!.textLabel!.text="是否加钱:加钱"
                    }
                }
                break
            case 6:
                if entity?.addMoney != nil{
                    cell!.textLabel!.text="加钱金额:\(entity!.addMoney!)元"

                }else{
                    cell!.textLabel!.text="加钱金额:0元"
                }
                break
            case 7:
                let identity=userDefaults.object(forKey: "identity") as! Int
                if identity == 3{
                    if entity!.driverUserCtime != nil{
                        cell!.textLabel!.text="司机接收时间:\(entity!.driverUserCtime!)"
                    }
                }else if identity == 2{
                    if entity!.storeUserCtime != nil{
                        cell!.textLabel!.text="站点接收时间:\(entity!.storeUserCtime!)"
                    }
                }
                break
            default:break
            }
        
        
           
        
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.row == 3{
            //客服电话   点击事件
            let alertController = UIAlertController(title: "城乡惠",
                message: "您确定要拨打电话吗?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
                handler: {
                    action in
                    //延时0.2秒执行  不然会有几率报错_BSMachError: (os/kern) invalid name (15)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                        //拨打电话
                        UIApplication.shared.openURL(Foundation.URL(string :"tel://\(self.entity!.expressmailStoragePhoneNumber!)")!)
                    })
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }


}
