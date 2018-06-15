//
//  ShowProvinceAddresViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/6/15.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
import UIKit

///弹出地区选择
class ShowProvinceAddresViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var table:UITableView?
    ///接收已经选中的省份
    var provinces=[String]()
    ///选中省份闭包
    var selectedProvinceClosure:((_ strs:String) -> Void)?
    ///保存网络请求的地址信息
    private var provinceArr=[RegionEntity]()
    private var pid=9999

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="不包邮省份选择"
        self.view.backgroundColor=UIColor.white
        configureData()
        configureViews()

    }
    func configureData(){
        requestAddressInfo(pid)
    }
    func configureViews(){
        self.table = UITableView(frame:CGRect.init(x:0, y:64, width:boundsWidth, height:boundsHeight-navHeight-50-bottomSafetyDistanceHeight))
        self.table!.delegate = self;
        self.table!.dataSource = self;
        self.table!.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(self.table!)
        let btn=UIButton.init(frame:CGRect.init(x:0, y:boundsHeight-50-bottomSafetyDistanceHeight, width:boundsWidth, height:50))
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor=UIColor.applicationMainColor()
        btn.titleLabel!.font=UIFont.systemFont(ofSize:15)
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
    }
    ///保存
    @objc private func submit(){
        ///获取选中的省份
        let arr=provinceArr.filter{ $0.isSelected! == 1 }.map{ return $0.regionName ?? "" }
        var strs=""
        for i in 0..<arr.count {
            if i < arr.count-1{
                strs+=arr[i]+","
            }else{
                strs+=arr[i]
            }
        }
        selectedProvinceClosure?(strs)
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinceArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellid)
        }
            let entity=self.provinceArr[indexPath.row]
            cell!.textLabel!.text=entity.regionName
        if entity.isSelected == 1{
            //勾选当前选定状态
            cell!.imageView!.image=UIImage(named:"checked")
        }else{
            //取消勾选当前选定状态
            cell!.imageView!.image=UIImage(named:"unchecked")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newCell=table?.cellForRow(at: indexPath)
        let entity=self.provinceArr[indexPath.row]
        if entity.isSelected == 2{
            entity.isSelected=1
            //勾选当前选定状态
            newCell!.imageView!.image=UIImage(named:"checked")
        }else{
            entity.isSelected=2
            //取消勾选当前选定状态
            newCell!.imageView!.image=UIImage(named:"unchecked")
        }
    }

}
// MARK: - 网络请求
extension ShowProvinceAddresViewController{
    /**
     请求地址信息
     - parameter pid: 父Id
     */
    func requestAddressInfo(_ pid:Int){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.selectAddressInfo(pid:pid), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            for(_,value) in json{
                let entity=self.jsonMappingEntity(RegionEntity(), object:value.object)
                ///默认未选中
                entity?.isSelected=2
                if self.provinces.count > 0{
                    ///如果有选中的省份 设置选中状态
                    if self.provinces.contains(where: { $0 == entity?.regionName }){
                        entity?.isSelected=1
                    }
                }
                 self.provinceArr.append(entity!)
            }
            self.dismissHUD()
            self.table?.reloadData()
        }) { (errorMsg) -> Void in
            self.dismissHUD()
            self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
