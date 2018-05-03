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
    var selectedProvince:String?
    var selectedCity:String?
    var selectedArea:String?
    var selectedIndexPath:IndexPath?
    var selectedStr:UILabel?
    var pid=9999
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="地区选择"
        self.view.backgroundColor=UIColor.white
        configureData()
        configureViews()

    }
    func configureData(){
        if (self.displayType == 0) {
            requestAddressInfo(pid)
        }else if self.displayType == 1{
            requestAddressInfo(pid)
        }else{
            requestAddressInfo(pid)
        }
    }
    func configureViews(){
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target:self, action:#selector(cancel))
        self.table = UITableView(frame:self.view.bounds)
        self.table!.delegate = self;
        self.table!.dataSource = self;
        self.table!.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(self.table!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.displayType == 0{
            return self.provinces.count
        }else if self.displayType == 1{
            return self.citys.count
        }else{
            return self.areas.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellid)
            if self.displayType == 2{
                cell!.accessoryType=UITableViewCellAccessoryType.none
            }else{
                cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        if self.displayType == 0{
            let entity=self.provinces[indexPath.row]
            cell!.textLabel!.text=entity.regionName
            
        }else if self.displayType == 1{
            let entity=self.citys[indexPath.row]
            cell!.textLabel!.text=entity.regionName
        }else{
           cell!.textLabel!.text=self.areas[indexPath.row].regionName
           cell!.imageView!.image=UIImage(named:"unchecked")
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
        }else{
            if self.selectedIndexPath != nil{
                //取消上一次选定状态
                let oldCell=table?.cellForRow(at: self.selectedIndexPath!)
                oldCell?.imageView?.image=UIImage(named:"unchecked")
            }
            //勾选当前选定状态
            let newCell=table?.cellForRow(at: indexPath)
            newCell!.imageView!.image=UIImage(named:"checked")
            //保存
            self.selectedArea=self.areas[indexPath.row].regionName
            self.selectedIndexPath=indexPath
            let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!
            let alert=UIAlertController(title:"地区选择", message:msg, preferredStyle: UIAlertControllerStyle.alert)
            let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.default, handler:{ Void in
                let flag=userDefaults.object(forKey: "flag") as? Int
                
                if flag == nil{
                    //通知上一页面刷新数据
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "postUpdateAddress"), object:msg)
                }else{
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "postUpdateAddress1"), object:msg)
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
        self.table?.deselectRow(at: self.table!.indexPathForSelectedRow!, animated:true)
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion:nil)
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
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.selectAddressInfo(pid:pid), successClosure: { (result) -> Void in
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
            }else{
                self.areas=arr
            }
            self.dismissHUD()
            self.table?.reloadData()
            }) { (errorMsg) -> Void in
                self.dismissHUD()
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
