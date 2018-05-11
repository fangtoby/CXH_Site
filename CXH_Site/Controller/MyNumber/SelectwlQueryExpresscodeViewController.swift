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
    private var keys=[String]()
    private var dic=Dictionary<String,[ExpressEntity]>()
    fileprivate var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="请选择一个物流公司"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target:self, action:#selector(cancel))
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        self.table = UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight))
        self.table!.delegate = self;
        self.table!.dataSource = self;
        //移除空单元格
        self.table!.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(self.table!)
        setData()
    }
    ///设置数据
    private func setData(){
        DispatchQueue.global().async(execute: {
            self.keys=DB.shared.selectLetterArr()
            for i in 0..<self.keys.count{
                self.dic[self.keys[i]]=DB.shared.selectArr(letter:self.keys[i])
            }
            if self.dic.count == 0{
                self.httpSelectwlQueryExpresscode()
            }else{
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
            self.dismissHUD()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissHUD()
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion:nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return keys.count
    }
    //索引代理
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return keys
    }
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //判断keys是否为空
        if keys.count > 0 {
            return keys[section]
        }else{
            return nil
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellid)
            cell!.accessoryType=UITableViewCellAccessoryType.none

        }
        if dic.count > 0{
            let entity=dic[keys[indexPath.section]]![indexPath.row]
            cell!.textLabel!.text=entity.expressName
        }
        return cell!

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if keys.count > 0{
            let keyStr = keys[section]
            let values = dic[keyStr]
            if values != nil{
                return values!.count
            }
        }
        return 0

    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
    }
    //字母点击
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity=dic[keys[indexPath.section]]![indexPath.row]
        self.expressEntity?(entity)
        self.cancel()
    }
    ///查询所有可选的快递公司
    private func httpSelectwlQueryExpresscode(){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.wlQueryExpresscode(), successClosure: { (result) -> Void in
            DB.shared.deleteArrEntity()
            let json=self.swiftJSON(result)
            for(_,value) in json{
                let entity=self.jsonMappingEntity(ExpressEntity(), object:value.object)
                entity?.letter=chineISInitials(entity?.expressName ?? "城乡惠")
                DB.shared.insertEntity(entity:entity!)
            }
            self.keys=DB.shared.selectLetterArr()
            for i in 0..<self.keys.count{
                self.dic[self.keys[i]]=DB.shared.selectArr(letter:self.keys[i])
            }
            self.table.reloadData()
            self.dismissHUD()
        }) { (errorMsg) -> Void in
            self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }

}
