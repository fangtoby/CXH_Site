//
//  SettingsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/4/13.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 设置页面
class SettingsViewController:BaseViewController{
    fileprivate var table:UITableView!
    fileprivate var nameArr=["订单包邮设置","提现账户设置","设置分享费比例","修改密码"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="设置"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame: self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
    }
}
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 14)
        cell!.textLabel!.text=nameArr[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.row == 0{
            let vc=SettingPostageViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 1{
            let vc=BindWxAndAliViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc=SettingShareProportionViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 3{
            let vc=UpdatePasswordViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
}
