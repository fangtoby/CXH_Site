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
    fileprivate var nameArr=["关于我们","修改密码"]
    fileprivate var imgArr=["gywm","bb"]
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
        //图片
        let img=UIImageView(frame:CGRect(x:14,y:12.5,width:25,height:25))
        img.image=UIImage(named:imgArr[indexPath.row])
        cell!.contentView.addSubview(img)
        //文字描述
        let name=UILabel(frame:CGRect(x:img.frame.maxX+5,y:15,width:100,height:20))
        name.font=UIFont.systemFont(ofSize: 14)
        name.text=nameArr[indexPath.row]
        cell!.contentView.addSubview(name)
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.row == 1{
            let vc=UpdatePasswordViewController()
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
}
