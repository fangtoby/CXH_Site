//
//  ConnectThePrinterViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/9.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 连接打印机
class ConnectThePrinterViewController:BaseViewController{
    //1打印站点二维码 2打印商品二维商品
    var flag:Int?
    var entity:PrinterEntity?
    //接收商品二维码
    var code:String?
    var goodName:String?
    fileprivate var table:UITableView!
    fileprivate var arr=[CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="打印二维码信息"
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame: self.view.bounds)
        table.delegate=self
        table.dataSource=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"打印", style: UIBarButtonItemStyle.done, target:self, action:#selector(connectThePrinter))
        SEPrinterManager.sharedInstance().startScanPerpheralTimeout(10, success: { (perpherals,isTimeout) -> Void in
            self.arr=perpherals!
                self.table.reloadData()
            }) { (SEScanError) -> Void in
                self.showSVProgressHUD("没有搜索到蓝牙打印设备", type: HUD.error)
        }
    }
    /**
     打印
     */
    @objc func connectThePrinter(){
        let printer=self.getPrinter()
        let mainData=printer.getFinalData()
        SEPrinterManager.sharedInstance().sendPrint(mainData) { (_,_,error) -> Void in
            self.showSVProgressHUD("未连接到打印设备", type: HUD.error)
        }

    }
    /**
     生成打印数据
     
     - returns:
     */
    func getPrinter()-> HLPrinter{
        let printer=HLPrinter()
        if flag == 1{
            printer.appendText("城乡惠", alignment: HLTextAlignment.center, fontSize: HLFontSize.titleMiddle)
            printer.appendSeperatorLine()
            printer.appendTitle("站点名称:", value:entity!.storeName!,valueOffset:150)
            printer.appendTitle("重量:", value:"\(entity!.weight!)kg", valueOffset:150)
            printer.appendTitle("运费:", value:entity!.freight!,valueOffset:150)
            printer.appendTitle("录入时间:", value:entity!.time!,valueOffset:150)
            printer.appendSeperatorLine()
            printer.appendTitle("", value:"",valueOffset:150)
            printer.appendQRCode(withInfo: entity!.code!)
        }else{
            printer.appendText("城乡惠商品来源", alignment: HLTextAlignment.center, fontSize: HLFontSize.titleMiddle)
            printer.appendSeperatorLine()
            printer.appendTitle("商品名称:", value:goodName!,valueOffset:150)
            printer.appendSeperatorLine()
            printer.appendTitle("", value:"",valueOffset:150)
            printer.appendQRCode(withInfo: code!)
        }
        printer.appendTitle("", value:"",valueOffset:150)
        printer.appendFooter("湘潭县银河商贸有限公司")
        printer.appendTitle("", value:"",valueOffset:150)
        printer.appendTitle("", value:"",valueOffset:150)
        printer.appendTitle("", value:"",valueOffset:150)
        return printer
    }
}
// MARK: - table协议
extension ConnectThePrinterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:cellid)
        
        }
        if arr.count > 0{
            cell!.textLabel!.text=arr[indexPath.row].name
            let peripheral=SEPrinterManager.sharedInstance().connectedPerpheral
            if peripheral != nil{
                if cell!.textLabel!.text == peripheral?.name{
                    cell!.detailTextLabel!.text="已连接"
                }else{
                    cell!.detailTextLabel!.text="未连接"
                    cell!.accessoryType = .disclosureIndicator
                }
            }else{
                cell!.detailTextLabel!.text="未连接"
                cell!.accessoryType = .disclosureIndicator
            }
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showSVProgressHUD("正在连接蓝牙...", type: HUD.textClear)
        tableView.deselectRow(at: indexPath,animated:true)
        let peripheral=arr[indexPath.row]
        SEPrinterManager.sharedInstance().connect(peripheral) { (_,error) -> Void in
            if error != nil{
                self.showSVProgressHUD("连接失败", type: HUD.error)
            }else{
                self.table.reloadData()
                self.dismissHUD()
            }
        }
        
    }
    

}
