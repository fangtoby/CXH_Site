//
//  PublicRecruitmentViewController.swift
//  CXH
//
//  Created by hao peng on 2017/5/26.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 公共展示物流信息查询
class PublicRecruitmentViewController:BaseViewController {
    var orderInfoId:Int?
    fileprivate var table:UITableView!
    fileprivate var acceptArr=[AcceptEntity]()
    fileprivate var acceptCellArr=[AcceptTableViewCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="物流查询"
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-navHeight))
        table.delegate=self
        table.dataSource=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        table.separatorStyle = .none
        self.view.addSubview(table)
        if orderInfoId != nil{
            wlQueryForOrderInfoId()
        }
    }
}
// MARK: - table协议
extension PublicRecruitmentViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "AcceptTableViewCell") as? AcceptTableViewCell
        if cell == nil{
            cell=AcceptTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"AcceptTableViewCell")
        }
        cell!.selectionStyle = .none
        if acceptArr.count > 0{
            let entity=acceptArr[indexPath.row]
            cell!.updateCell(entity, row:indexPath.row)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acceptArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if acceptArr.count > 0{
            let cell=acceptCellArr[indexPath.row]
            let entity=acceptArr[indexPath.row]
            cell.updateCell(entity,row:indexPath.row)
            return cell.frame.size.height
        }else{
            return 0
        }
    }

}
// MARK: - 网络请求
extension PublicRecruitmentViewController{
    func wlQueryForOrderInfoId(){
//        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.wlQueryForOrderInfoId(orderInfoId:orderInfoId!, memberId:IS_NIL_MEMBERID()!), successClosure: { (result) -> Void in
//            let json=self.swiftJSON(result)
//            let success=json["Success"].boolValue
//            
//            if success {
//                for(_,value) in json["Traces"]{
//                    let entity=self.jsonMappingEntity(AcceptEntity(), object:value.object)
//                    self.acceptArr.append(entity!)
//                    self.acceptCellArr.append(AcceptTableViewCell())
//                }
//                self.table.reloadData()
//            }else{
//                self.showSVProgressHUD("还没有找到相关物流信息", type: HUD.info)
//                
//            }
//            self.dismissHUD()
//            }) { (errorMsg) -> Void in
//                self.showSVProgressHUD(errorMsg!, type: HUD.Error)
//        }
    }
}
