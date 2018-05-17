//
//  Level2CategoryViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 2级分类
class Level2CategoryViewController:BaseViewController{
    //接收分类entity
    var pEntity:GoodsCategoryEntity?
    fileprivate var arr=[GoodsCategoryEntity]()
    fileprivate var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=pEntity!.goodscategoryName
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame:self.view.bounds)
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        queryGoodsCateGoryWhereGoodsCateGoryPId()
    }
    
}
// MARK: - table协议
extension Level2CategoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.textColor=UIColor.textColor()
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.accessoryType = .disclosureIndicator
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize:14)
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.textLabel!.text=entity.goodscategoryName
            cell!.detailTextLabel!.text="佣金比例:\(entity.goodscategoryCommission ?? 0)%"
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let entity=arr[indexPath.row]
        var arrs=[GoodsCategoryEntity]()
        arrs.append(pEntity!)
        arrs.append(entity)
        //通知上一页面刷新数据
        NotificationCenter.default.post(name: Notification.Name(rawValue: "postUpdateCategory"), object:arrs)
        self.dismiss(animated: true, completion:nil)
    }
}

// MARK: - 网络请求
extension Level2CategoryViewController{
    func queryGoodsCateGoryWhereGoodsCateGoryPId(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsCateGoryWhereGoodsCateGoryPId(pid:pEntity!.goodscategoryId!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            for(_,value) in json{
                let entity=self.jsonMappingEntity(GoodsCategoryEntity(), object:value.object)
                self.arr.append(entity!)
            }
            self.table.reloadData()
            self.dismissHUD()
            if self.arr.count == 0{
                UIAlertController.showAlertYes(self, title:"", message:"没有相关分类,请联系相关人员尽快上传", okButtonTitle:"确定", okHandler: {  Void in
                    self.dismiss(animated: true, completion:nil)
                })
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
