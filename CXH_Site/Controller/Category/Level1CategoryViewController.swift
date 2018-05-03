//
//  Level1CategoryViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 1级分类
class Level1CategoryViewController:BaseViewController{
    fileprivate var arr=[GoodsCategoryEntity]()
    fileprivate var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="1级分类"
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame:self.view.bounds)
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        queryGoodsCateGoryForOne()
    }
    
}
// MARK: - table协议
extension Level1CategoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.textColor=UIColor.textColor()
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.accessoryType = .disclosureIndicator
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.textLabel!.text=entity.goodscategoryName
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let entity=arr[indexPath.row]
        let vc=Level2CategoryViewController()
        vc.pEntity=entity
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

// MARK: - 网络请求
extension Level1CategoryViewController{
    func queryGoodsCateGoryForOne(){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsCateGoryForOne(), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            for(_,value) in json{
                let entity=self.jsonMappingEntity(GoodsCategoryEntity(), object:value.object)
                self.arr.append(entity!)
            }
            self.table.reloadData()
            self.dismissHUD()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
