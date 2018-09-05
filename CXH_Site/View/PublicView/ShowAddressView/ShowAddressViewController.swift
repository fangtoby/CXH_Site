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
    var titleStr:String?
    var table:UITableView?
    var displayType=0
    var provinces=[RegionEntity]()
    var citys=[RegionEntity]()
    var areas=[RegionEntity]()
    ///镇
    var towns=[RegionEntity]()
    ///村
    var villages=[RegionEntity]()
    ///站点集合
    var storeArr=[StoreEntity]()
    var selectedProvince:String?
    var selectedCity:String?
    var selectedArea:String?
    var selectedTowns:String?
    var selectedVillages:String?
    var selectedIndexPath:IndexPath?
    var selectedStr:UILabel?
    var pid=9999
    ///是否是收件人地址 有值是
    private let flag=userDefaults.object(forKey: "flag") as? Int
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=titleStr ?? "地区选择"
        self.view.backgroundColor=UIColor.white
        self.table = UITableView(frame:CGRect.init(x:0, y:0, width: boundsWidth, height:boundsHeight-bottomSafetyDistanceHeight))
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
        }else if self.displayType == 4{
            return self.villages.count
        }else{
            return self.storeArr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellid)
            cell!.textLabel?.font=UIFont.systemFont(ofSize:14)
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
        }else if self.displayType == 4{
            let entity=self.villages[indexPath.row]
            cell!.textLabel!.text=entity.regionName
            isSubordinate=entity.isSubordinate ?? 1
        }else{
            let entity=self.storeArr[indexPath.row]
            cell!.textLabel!.text=entity.storeNo
            isSubordinate=2
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
            cityVC.titleStr=entity.regionName
            cityVC.displayType=1//显示模式为城市
            cityVC.pid=entity.regionId!
            cityVC.selectedProvince=self.selectedProvince
            self.navigationController!.pushViewController(cityVC, animated:true)
        }else if self.displayType == 1{
            let entity=self.citys[indexPath.row]
            self.selectedCity=entity.regionName
            //构建下一级视图控制器
            let areaVC=ShowAddressViewController()
            areaVC.titleStr=entity.regionName
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
            townsVC.titleStr=entity.regionName
            townsVC.displayType=3
            townsVC.pid=entity.regionId!
            townsVC.selectedProvince=self.selectedProvince
            townsVC.selectedCity=self.selectedCity
            townsVC.selectedArea=self.selectedArea
            if entity.isSubordinate == 1 && flag != nil{
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
            villagesVC.titleStr=entity.regionName
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
        }else if self.displayType == 4{
            //保存
            self.selectedVillages=self.villages[indexPath.row].regionName
            self.selectedIndexPath=indexPath
            let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!+"-"+self.selectedTowns!+"-"+self.selectedVillages!
            self.queryStoreandvillage(villageRegionId:self.villages[indexPath.row].regionId!,msg:msg)

        }else{
            let storeEntity=self.storeArr[indexPath.row]
            let storeNo=storeEntity.storeNo ?? ""
            let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!+"-"+self.selectedTowns!+"-"+self.selectedVillages!+"-"+storeNo
            self.showAddressStr(msg:msg,storeNo:storeNo,storeId:storeEntity.storeId)
        }
        self.table?.deselectRow(at: self.table!.indexPathForSelectedRow!, animated:true)
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion:nil)
    }
    private func showAddressStr(msg:String,storeNo:String?=nil,storeId:Int?=nil){
        let alert=UIAlertController(title:"地区选择", message:msg, preferredStyle: UIAlertControllerStyle.alert)
        let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.default, handler:{ Void in
            if self.flag == nil{
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
            self.dismissHUD()
            self.storeArr=self.jsonMappingArrEntity(StoreEntity(), object:json.object) ?? [StoreEntity]()
            if self.storeArr.count == 0{
                self.showSVProgressHUD("没有找到对应的快递站点", type: HUD.info)
                self.showAddressStr(msg:msg,storeNo:nil,storeId:nil)
            }else if self.storeArr.count == 1{
                let entity=self.storeArr[0]
                self.showAddressStr(msg:msg,storeNo:entity.storeNo,storeId:entity.storeId)
            }else if self.storeArr.count > 1{
                //构建下一级视图控制器 显示站点信息
                let storeVC=ShowAddressViewController()
                storeVC.titleStr=self.selectedVillages
                storeVC.displayType=5
                storeVC.selectedProvince=self.selectedProvince
                storeVC.selectedCity=self.selectedCity
                storeVC.selectedArea=self.selectedArea
                storeVC.selectedTowns=self.selectedTowns
                storeVC.selectedVillages=self.selectedVillages
                storeVC.storeArr=self.storeArr
                self.navigationController?.pushViewController(storeVC, animated:true)
            }

        }) { (error) in
            self.showSVProgressHUD(error ?? "",type: HUD.error)
        }
    }
}

