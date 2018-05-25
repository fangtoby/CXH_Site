//
//  StorePrepaidrecordDetailViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/25.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
///充值订单明细
class StorePrepaidrecordDetailViewController:BaseViewController{
    ///接收id
    var prepaidrecordId:Int?
    private var table:UITableView!
    ///订单的总分享费
    private var orderShareSumPrice:Double?
    ///订单的总佣金
    private var orderComment:Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="订单明细"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView.init(frame:self.view.bounds)
        table.dataSource=self
        table.dataSource=self
        table.tableFooterView=UIView.init(frame: CGRect.zero)
        self.view.addSubview(table)
        queryStoreOrderPrepaidrecordDetailByPrepaidrecordId()

    }
    private func queryStoreOrderPrepaidrecordDetailByPrepaidrecordId(){
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStoreOrderPrepaidrecordDetailByPrepaidrecordId(prepaidrecordId:prepaidrecordId ?? 0), successClosure: { (any) in
            let json=self.swiftJSON(any)
            self.orderShareSumPrice=json["orderShareSumPrice"].double
            self.orderComment=json["orderComment"].double
            self.table.reloadData()
            self.dismissHUD()
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
// MARK: - table协议
extension StorePrepaidrecordDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell=tableView.dequeueReusableCell(withIdentifier:"id")
        if cell == nil{
            cell=UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier:"id")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize:15)
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize:14)
        if indexPath.row == 0{
            cell!.textLabel!.text="订单佣金扣除"
            cell!.detailTextLabel!.text=orderShareSumPrice?.description
        }else{
            cell!.textLabel!.text="订单分享费扣除"
            cell!.detailTextLabel!.text=orderComment?.description
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中效果颜色
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
