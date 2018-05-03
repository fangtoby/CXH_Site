//
//  ShippinglinesViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
//定义闭包类型
typealias closureShippingLinesEntity = (ShippingLinesEntity) -> Void
/// 司机路线
class ShippinglinesViewController:BaseViewController {
    var shippingLinesClosure:closureShippingLinesEntity?
    fileprivate var table:UITableView!
    fileprivate var arr=[ShippingLinesEntity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="路线选择"
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-navHeight))
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        queryShippinglines()
    }
}
// MARK: - table协议
extension ShippinglinesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cellid")
        }
        cell!.accessoryType = .disclosureIndicator
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.textLabel!.text=entity.shippingName
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let entity=arr[indexPath.row]
        UIAlertController.showAlertYesNo(self, title:"", message:"您确定选择\(entity.shippingName!)吗?", cancelButtonTitle:"取消", okButtonTitle:"确定") {  Void in
            self.shippingLinesClosure?(entity)
            
        }
    }
}
// MARK: - 网络请求
extension ShippinglinesViewController{
    /**
     获取路线信息
     */
    func queryShippinglines(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryShippinglines(), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            for(_,value) in json{
                let entity=self.jsonMappingEntity(ShippingLinesEntity(), object:value.object)
                self.arr.append(entity!)
            }
            self.table.reloadData()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
