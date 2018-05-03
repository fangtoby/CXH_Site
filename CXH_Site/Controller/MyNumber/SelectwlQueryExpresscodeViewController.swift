//
//  SelectwlQueryExpresscodeViewController.swift
//  CXH
//
//  Created by hao peng on 2017/5/24.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
//定义闭包类型
typealias closureExpressEntity = (ExpressEntity) -> Void
/// 查询所有的物流公司
class SelectwlQueryExpresscodeViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource{
    var arr=[ExpressEntity]()
    var expressEntity:closureExpressEntity?
    fileprivate var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="请选择一个物流公司"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target:self, action:#selector(cancel))
        self.table = UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight))
        self.table!.delegate = self;
        self.table!.dataSource = self;
        //移除空单元格
        self.table!.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(self.table!)
        selectwlQueryExpresscode()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissHUD()
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion:nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellid)
            cell!.accessoryType=UITableViewCellAccessoryType.none
            
        }
        if arr.count > 0{
            let entity=arr[indexPath.row]
            cell!.textLabel!.text=entity.expressName
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity=arr[indexPath.row]
        self.expressEntity?(entity)
        self.cancel()
    }
    /**
     选择物流公司
     */
    func selectwlQueryExpresscode(){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.wlQueryExpresscode(), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            for(_,value) in json{
                let entity=self.jsonMappingEntity(ExpressEntity(), object:value.object)
                self.arr.append(entity!)
            }
            self.table.reloadData()
            self.dismissHUD()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }

}
