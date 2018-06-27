//
//  ShowAddressViewController.swift
//  unclePhone1
//
//  Created by hefeiyue on 15/11/9.
//  Copyright © 2015年 penghao. All rights reserved.
//

import Foundation
import UIKit
///弹出地区选择
class ShowAddressViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var table:UITableView?
    var displayType=0
    var provinces=[RegionEntity]()
    var citys=[RegionEntity]()
    var areas=[RegionEntity]()
    ///镇
    var towns=[RegionEntity]()
    ///村
    var villages=[RegionEntity]()
    var selectedProvince:String?
    var selectedCity:String?
    var selectedArea:String?
    var selectedTowns:String?
    var selectedVillages:String?
    var selectedIndexPath:IndexPath?
    var selectedStr:UILabel?
    var pid=9999
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="地区选择"
        self.view.backgroundColor=UIColor.white
        self.table = UITableView(frame:self.view.bounds)
        self.table!.delegate = self;
        self.table!.dataSource = self;
        self.table!.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(self.table!)
        configureViews()
        configureData()
    }
    func configureData(){
        requestAddressInfo(pid)
    }
    func configureViews(){
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target:self, action:#selector(cancel))

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.displayType == 0{
            return self.provinces.count
        }else if self.displayType == 1{
            return self.citys.count
        }else if self.displayType == 2{
            return self.areas.count
        }else if self.displayType == 3{
            return self.towns.count
        }else{
            return self.villages.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellid)
        }
        var isSubordinate=1
        if self.displayType == 0{
            let entity=self.provinces[indexPath.row]
            cell!.textLabel!.text=entity.regionName
            isSubordinate=entity.isSubordinate ?? 1

        }else if self.displayType == 1{
            let entity=self.citys[indexPath.row]
            cell!.textLabel!.text=entity.regionName
            isSubordinate=entity.isSubordinate ?? 1
        }else if self.displayType == 2{
            let entity=self.areas[indexPath.row]
            cell!.textLabel!.text=entity.regionName
            isSubordinate=entity.isSubordinate ?? 1
        }else if self.displayType == 3{
            let entity=self.towns[indexPath.row]
            cell!.textLabel!.text=entity.regionName
            isSubordinate=entity.isSubordinate ?? 1
        }else{
            let entity=self.villages[indexPath.row]
            cell!.textLabel!.text=entity.regionName
            isSubordinate=entity.isSubordinate ?? 1
        }
        if isSubordinate == 2{
            cell!.accessoryType=UITableViewCellAccessoryType.none
        }else{
            cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.displayType == 0{
            let entity=self.provinces[indexPath.row]
            self.selectedProvince=entity.regionName
            //构建下一级视图控制器
            let cityVC=ShowAddressViewController()
            cityVC.displayType=1//显示模式为城市
            cityVC.pid=entity.regionId!
            cityVC.selectedProvince=self.selectedProvince
            self.navigationController!.pushViewController(cityVC, animated:true)
        }else if self.displayType == 1{
            let entity=self.citys[indexPath.row]
            self.selectedCity=entity.regionName
            //构建下一级视图控制器
            let areaVC=ShowAddressViewController()
            areaVC.displayType=2
            areaVC.pid=entity.regionId!
            areaVC.selectedProvince=self.selectedProvince
            areaVC.selectedCity=self.selectedCity
            self.navigationController!.pushViewController(areaVC, animated:true)
        }else if self.displayType == 2{
            let entity=self.areas[indexPath.row]
            self.selectedArea=entity.regionName
            //构建下一级视图控制器
            //构建下一级视图控制器
            let townsVC=ShowAddressViewController()
            townsVC.displayType=3
            townsVC.pid=entity.regionId!
            townsVC.selectedProvince=self.selectedProvince
            townsVC.selectedCity=self.selectedCity
            townsVC.selectedArea=self.selectedArea
            if entity.isSubordinate == 1{
                self.navigationController!.pushViewController(townsVC, animated:true)
            }else{
                //保存
                self.selectedArea=self.areas[indexPath.row].regionName
                self.selectedIndexPath=indexPath
                let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!
                self.showAddressStr(msg:msg)
            }
        }else if self.displayType == 3{
            let entity=self.towns[indexPath.row]
            self.selectedTowns=entity.regionName
            //构建下一级视图控制器
            let villagesVC=ShowAddressViewController()
            villagesVC.displayType=4
            villagesVC.pid=entity.regionId!
            villagesVC.selectedProvince=self.selectedProvince
            villagesVC.selectedCity=self.selectedCity
            villagesVC.selectedArea=self.selectedArea
            villagesVC.selectedTowns=self.selectedTowns
            if entity.isSubordinate == 1{
                self.navigationController!.pushViewController(villagesVC, animated:true)
            }else{
                //保存
                self.selectedTowns=self.towns[indexPath.row].regionName
                self.selectedIndexPath=indexPath
                let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!+"-"+self.selectedTowns!
                self.showAddressStr(msg:msg)
            }
        }else{
            //保存
            self.selectedVillages=self.villages[indexPath.row].regionName
            self.selectedIndexPath=indexPath
            let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!+"-"+self.selectedTowns!+"-"+self.selectedVillages!
            self.queryStoreandvillage(villageRegionId:self.villages[indexPath.row].regionId!,msg:msg)

        }
        self.table?.deselectRow(at: self.table!.indexPathForSelectedRow!, animated:true)
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion:nil)
    }
    private func showAddressStr(msg:String,storeNo:String?=nil,storeId:Int?=nil){
        let alert=UIAlertController(title:"地区选择", message:msg, preferredStyle: UIAlertControllerStyle.alert)
        let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.default, handler:{ Void in
            let flag=userDefaults.object(forKey: "flag") as? Int

            if flag == nil{
                //通知上一页面刷新数据
                NotificationCenter.default.post(name:Notification.Name(rawValue:"postUpdateAddress"), object:msg,userInfo:["storeNo":storeNo ?? "","storeId":storeId ?? ""])
            }else{
                NotificationCenter.default.post(name:Notification.Name(rawValue:"postUpdateAddress1"), object:msg,userInfo:["storeNo":storeNo ?? "","storeId":storeId ?? ""])
                userDefaults.removeObject(forKey: "flag")
                userDefaults.synchronize()
            }
            self.dismiss(animated: true, completion:nil)

        })
        let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated:true, completion:nil)
    }

}
// MARK: - 网络请求
extension ShowAddressViewController{
    /**
     请求地址信息
     - parameter pid: 父Id
     */
    func requestAddressInfo(_ pid:Int){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.selectAddressInfo(pid: pid), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            var arr=[RegionEntity]()
            for(_,value) in json{
                let entity=self.jsonMappingEntity(RegionEntity(), object:value.object)
                arr.append(entity!)
            }
            if (self.displayType == 0) {
                self.provinces=arr
            }else if self.displayType == 1{
                self.citys=arr
            }else if self.displayType == 2{
                self.areas=arr
            }else if self.displayType == 3{
                self.towns=arr
            }else{
                self.villages=arr
            }
            self.dismissHUD()
            self.table?.reloadData()
        }) { (errorMsg) -> Void in
            self.dismissHUD()
            self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
    ///根据村查询对应的站点
    private func queryStoreandvillage(villageRegionId:Int,msg:String){
        self.showSVProgressHUD("正在根据村查询对应的站点",type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStoreandvillage(villageRegionId:villageRegionId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let storeNo=json["storeNo"].string
            let storeId=json["storeId"].int
            if storeNo == nil{
                self.showSVProgressHUD("没有找到对应的快递站点", type: HUD.info)
                self.showAddressStr(msg:msg,storeNo:storeNo,storeId:storeId)
            }else{
                self.showAddressStr(msg:msg,storeNo:storeNo,storeId:storeId)
            }
        }) { (error) in
            self.showSVProgressHUD(error!,type: HUD.error)
        }
    }
}
