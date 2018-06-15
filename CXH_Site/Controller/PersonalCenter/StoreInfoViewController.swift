//
//  StoreInfoViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/26.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
///店铺信息
class StoreInfoViewController:BaseViewController{
    private var storeId=userDefaults.object(forKey:"storeId") as! Int
    private var entity:StoreEntity?
    private var table:UITableView!
    private var arrName=["店铺编号","店铺名称","店铺昵称","店铺联系方式","分享费比例","店铺创建时间"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="站点信息"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView.init(frame: CGRect.zero)
        self.view.addSubview(table)
        queryStoreInfo()
    }

    ///查询店铺信息
    private func queryStoreInfo(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStoreInfo(storeId:storeId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            //print(json)
            self.entity=StoreEntity(JSONString:json.description)
            self.table.reloadData()
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
}
///协议
extension StoreInfoViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table.dequeueReusableCell(withIdentifier:"storeId")
        if cell == nil{
            cell=UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier:"storeId")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize:15)
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
        cell!.textLabel!.text=arrName[indexPath.row]
        if entity != nil{
            switch indexPath.row{
            case 0:
                cell!.detailTextLabel!.text=entity?.storeNo
                break
            case 1:
                cell!.detailTextLabel!.text=entity?.storeName
                break
            case 2:
                cell!.detailTextLabel!.text=entity?.ownerName
                break
            case 3:
                cell!.detailTextLabel!.text=entity?.tel
                break
            case 4:
                cell!.detailTextLabel!.text=((entity!.shareBili ?? 0).description)+"%"
                cell!.accessoryType = .disclosureIndicator
                break
            case 5:
                cell!.detailTextLabel!.text=entity?.addTime
                break
            default:
                break
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        if indexPath.row == 4{
            let vc=SettingShareProportionViewController()
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }

}

