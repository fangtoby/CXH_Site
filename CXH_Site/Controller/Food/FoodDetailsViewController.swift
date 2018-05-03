//
//  FoodDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/10/24.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 菜品详情
class FoodDetailsViewController:BaseViewController{
    var foodId:Int?
    fileprivate var entity:FoodEntity?
    fileprivate var imgArr=[String]()
    fileprivate var table:UITableView!
    fileprivate var scrollView:UIScrollView!
    fileprivate var foodCollectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        self.title="菜品详情"
        scrollView=UIScrollView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight))
        self.view.addSubview(scrollView)
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 12*50+80))
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        scrollView.addSubview(table)
        scrollView.contentSize=CGSize(width: boundsWidth,height: table.frame.maxY+10)
        http()
    }
}
// MARK: - table协议
extension FoodDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "goodDetailId")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"goodDetailId")
        }
        cell!.textLabel!.textColor=UIColor.black
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
        let name=buildLabel(UIColor.textColor(), font:15, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 0,width: 55,height: 50)
        let nameValue=buildLabel(UIColor.color999(), font:14, textAlignment: NSTextAlignment.left)
        nameValue.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
        if entity != nil{
            switch indexPath.section{
            case 0:
                switch indexPath.row{
                case 0:
                    cell!.textLabel!.text="菜品基本信息"
                    break
                case 1:
                    name.text="菜品名"
                    nameValue.text=entity!.foodName
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                case 2:
                    name.text="  单位"
                    nameValue.text=entity!.foodUnit
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                case 3:
                    name.text="  规格"
                    nameValue.text=entity!.foodUcode
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                case 4:
                    name.text="  价格"
                    if entity!.foodPrice != nil{
                        nameValue.text="￥\(entity!.foodPrice!)"
                    }
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                case 5:
                    name.text="  条码"
                    nameValue.text=entity!.foodCode
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                default:break
                }
                break
            case 1:
                switch indexPath.row{
                case 0:
                    cell!.textLabel!.text="菜品其他详细信息"
                    break
                case 1:
                    name.text="  库存"
                    if entity!.stock != nil{
                        nameValue.text="\(entity!.stock!)"
                    }
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                    
                case 2:
                    name.text="  配料"
                    nameValue.text=entity!.foodMixed
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                case 3:
                    name.text="  描述"
                    nameValue.text=entity!.foodRemark
                    cell!.contentView.addSubview(name)
                    cell!.contentView.addSubview(nameValue)
                    break
                default:break
                }
                
                break
            case 2:
                switch indexPath.row{
                case 0:
                    cell!.textLabel!.text="菜品的图片信息"
                    break
                case 1:
                    let layout=UICollectionViewFlowLayout()
                    let cellWidth=70
                    layout.itemSize=CGSize(width:cellWidth,height:cellWidth)
                    layout.scrollDirection = UICollectionViewScrollDirection.horizontal
                    layout.minimumLineSpacing = 7.5;//每个相邻layout的上下
                    layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右
                    foodCollectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 70), collectionViewLayout:layout)
                    foodCollectionView.dataSource=self
                    foodCollectionView.delegate=self
                    foodCollectionView.backgroundColor=UIColor.clear
                    foodCollectionView.tag=100
                    foodCollectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCellId")
                    cell!.contentView.addSubview(foodCollectionView)
                    break
                default:break
                }
                break
            default:break
            }
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 2
        }else if section == 0{
            return 6
        }else{
            return 4
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            if indexPath.row == 1{
                return 100
            }else{
                return 50
            }
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRect.zero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    
}
// MARK: - 实现协议
extension FoodDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
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

extension FoodDetailsViewController{
    func http(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.getFoodById(foodId:foodId!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            self.entity=self.jsonMappingEntity(FoodEntity(), object:json["food"].object)
            self.entity?.foodPrice=json["food"]["foodPrice"].stringValue
            for(_,value) in json["fd"]{
                let pic=value["foodDetailPic"].stringValue
                self.imgArr.append(pic)
            }
            self.table.reloadData()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
