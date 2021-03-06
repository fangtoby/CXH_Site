//
//  MyNumberDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/1.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 单号详情页面(展示页面)
class MyNumberDetailsViewController:BaseViewController{
    var entity:ExpressmailEntity?
    var expressmailId:Int?
    fileprivate var table:UITableView!
    fileprivate var scrollView:UIScrollView!
    fileprivate var collectionView:UICollectionView!
    fileprivate var imgArr=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="揽件详情"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        scrollView=UIScrollView(frame:self.view.bounds)
        self.view.addSubview(scrollView)
        if entity!.packagePic != nil{
            self.imgArr=entity!.packagePic!.components(separatedBy: ",")
        }
        buildView()
        
    }
    override func navigationShouldPopOnBackButton() -> Bool {
        self.navigationController?.popToRootViewController(animated: true)
        return true
    }
    func buildView(){
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 26*50+140))
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        scrollView.addSubview(table)
        scrollView.contentSize=CGSize(width: boundsWidth,height: table.frame.maxY+10)
        
    }
}
// MARK: - table协议
extension MyNumberDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil{
            cell=UITableViewCell(style: .value1, reuseIdentifier:"cellid")
        }
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.textLabel!.textColor=UIColor.color666()
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                cell!.textLabel!.text="寄件人信息录入 Shipper information"
                break
            case 1:
                if entity!.fromName != nil{
                    cell!.textLabel!.text="姓名:\(entity!.fromName!)"
                }
                break
            case 2:
                if entity!.fromprovince != nil{
                    cell!.textLabel!.text="始发地:\(entity!.fromprovince!+entity!.fromcity!+entity!.fromcounty!)"
                }
                break
            case 3:
                if entity!.fromphoneNumber != nil{
                    cell!.textLabel!.text="电话:\(entity!.fromphoneNumber!)"
                }
                break
            case 4:
                if entity!.idCard != nil{
                    cell!.textLabel!.text="身份证:\(entity!.idCard!)"
                }
                break
            case 5:
                if entity!.fromRemarks != nil{
                    cell!.textLabel!.text="备注:\(entity!.fromRemarks!)"
                    cell!.accessoryType = .disclosureIndicator
                }else{
                    cell!.textLabel!.text="备注:"
                }
                break
            default:break
            }
            break
        case 1:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                cell!.textLabel!.text="收件人信息录入 Consignee informationn"
                break
            case 1:
                if entity!.toName != nil{
                    cell!.textLabel!.text="姓名:\(entity!.toName!)"
                }
                break
            case 2:
                if entity!.toprovince != nil{
                    cell!.textLabel!.text="收货地区:\(entity!.toprovince!+entity!.tocity!+entity!.tocounty!)"
                }
                break
            case 3:
                if entity!.todetailAddress != nil{
                    cell!.textLabel!.text="详细地址:\(entity!.todetailAddress!)"
                    cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                }
                break
            case 4:
                if entity!.tophoneNumber != nil{
                    cell!.textLabel!.text="电话:\(entity!.tophoneNumber!)"
                }
                break
            case 5:
                if entity!.toRemarks != nil{
                    cell!.textLabel!.text="备注:\(entity!.toRemarks!)"
                    cell!.accessoryType = .disclosureIndicator
                }else{
                    cell!.textLabel!.text="备注:"
                }
                break
            default:break
            }
            break
        case 2:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
                cell!.textLabel!.textColor=UIColor.black
                cell!.textLabel!.text="费用及付款方式 Charge and payment"
                break
            case 1:
                if entity!.weight != nil{
                    cell!.textLabel!.text="重量:\(entity!.weight!)kg"
                }
                break
            case 2:
                if entity!.amount != nil{
                    cell!.textLabel!.text="数量:\(entity!.amount!)"
                }
                break
            case 3:
                if entity!.length != nil{
                    cell!.textLabel!.text="长:\(entity!.length!)CM"
                }else{
                    cell!.textLabel!.text="长:无"
                }
            case 4:
                if entity!.width != nil{
                    cell!.textLabel!.text="宽:\(entity!.width!)CM"
                }else{
                    cell!.textLabel!.text="宽:无"
                }
            case 5:
                if entity!.height != nil{
                    cell!.textLabel!.text="高:\(entity!.height!)CM"
                }else{
                    cell!.textLabel!.text="高:无"
                }
                break
            case 6:
                if entity!.freight != nil{
                    cell!.textLabel!.text="总运费:\(entity!.freight!)元"
                }else{
                    cell!.textLabel!.text="总运费:0元"
                }
                break
            case 7:
                if entity!.storeToHeadquarters != nil{
                    cell!.textLabel!.text="城乡运费:\(entity!.storeToHeadquarters!)元"
                }else{
                    cell!.textLabel!.text="城乡运费:0元"
                }
                break
            case 8:
                if entity!.insuredMoney != nil{
                    cell!.textLabel!.text="保价金额:\(entity!.insuredMoney!)元"
                }else{
                    cell!.textLabel!.text="保价金额:0元"
                }
                break
            case 9:
                if entity!.payType == 2{
                    cell!.textLabel!.text="付款方式:线上支付"
                }else{
                    cell!.textLabel!.text="付款方式:现金支付"
                }
                break
            case 10:
                if entity!.expressName != nil {
                    cell!.textLabel!.text="快递公司:\(entity!.expressName!)"
                }
                break
            case 11:
                if entity!.expressNo != nil {
                    cell!.textLabel!.text="快递单号:\(entity!.expressNo!)"
                }else{
                    cell!.textLabel!.text="快递单号:无"
                }
                break
            case 12:
                if entity!.inputRemarks != nil{
                    cell!.textLabel!.text="备注:\(entity!.inputRemarks!)"
                    cell!.accessoryType = .disclosureIndicator
                }else{
                    cell!.textLabel!.text="备注:"
                }
                break
            default:break
            }
            break
        case 3:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="包裹信息"
                break
            case 1:
                let layout=UICollectionViewFlowLayout()
                let cellWidth=70
                layout.itemSize=CGSize(width:cellWidth,height:cellWidth)
                layout.scrollDirection = UICollectionViewScrollDirection.horizontal
                layout.minimumLineSpacing = 7.5;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右
                collectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 70), collectionViewLayout:layout)
                collectionView.dataSource=self
                collectionView.delegate=self
                collectionView.backgroundColor=UIColor.clear
                collectionView.tag=100
                collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCellId")
                cell!.contentView.addSubview(collectionView)
                break
            default:break
            }
            
            break
        default:break
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 6
        }else if section == 1{
            return 6
        }else if section == 3{
            return 2
        }else{
            return 13
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3{
            if indexPath.row == 1{
                return 100
            }else{
                return 50
            }
        }else{
            return 50
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRect.zero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        if indexPath.section == 0{
            if indexPath.row == 5{
                if entity!.fromRemarks != nil{
                    UIAlertController.showAlertYes(self, title:"备注", message:entity!.fromRemarks!, okButtonTitle:"确定")
                }
            }
        }else if indexPath.section == 1{
            if indexPath.row  == 3{
                UIAlertController.showAlertYes(self, title:"详细地址", message:entity!.todetailAddress!, okButtonTitle:"确定")
            }else if indexPath.row == 5{
                if entity!.toRemarks != nil{
                    UIAlertController.showAlertYes(self, title:"备注", message:entity!.toRemarks!, okButtonTitle:"确定")
                }
            }
        }else if indexPath.section == 2{
            if indexPath.row == 12{
                if entity!.inputRemarks != nil{
                    UIAlertController.showAlertYes(self, title:"备注", message:entity!.inputRemarks!, okButtonTitle:"确定")
                }
            }
        }
    }
}
// MARK: - 实现协议
extension MyNumberDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellId", for: indexPath)
        let goodImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 70,height: 70))
        goodImg.layer.borderColor=UIColor.borderColor().cgColor
        goodImg.layer.borderWidth=1
        cell.contentView.addSubview(goodImg)
        if imgArr.count > 0{
            let pic=imgArr[indexPath.row]
            goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "addImg"))
        }else{
            goodImg.image=UIImage(named:"addImg")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgArr.count
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

