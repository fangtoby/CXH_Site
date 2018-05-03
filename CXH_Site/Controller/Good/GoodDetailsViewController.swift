//
//  GoodDetailsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/4.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 商品详细信息
class GoodDetailsViewController:BaseViewController{
    var goodName:String?
    var goodsbasicInfoId:Int?
    fileprivate var entity:GoodDetailsEntity?
    fileprivate var scrollView:UIScrollView!
    fileprivate var table:UITableView!
    fileprivate var collectionView:UICollectionView!
    fileprivate var sourceCollectionView:UICollectionView!
    fileprivate var imgArr=[String]()
    fileprivate var sourceArr=[SourceEntity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=goodName
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        httpGoodDetailsInfo()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissHUD()
    }
    func buildView(){
        scrollView=UIScrollView(frame:self.view.bounds)
        self.view.addSubview(scrollView)
        table=UITableView(frame:CGRect(x:0,y:0,width: boundsWidth,height: 18*50+210))
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        scrollView.addSubview(table)
        scrollView.contentSize=CGSize(width: boundsWidth,height: table.frame.maxY+10)
    }
}
// MARK: - table协议
extension GoodDetailsViewController:UITableViewDelegate,UITableViewDataSource{
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
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="商品基本信息"
                break
            case 1:
                name.text="商品名"
                nameValue.text=entity!.goodInfoName
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 2:
                name.text="  分类"
                nameValue.text=entity!.sCategoryName
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 3:
                name.text="  单位"
                nameValue.text=entity!.goodUnit
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 4:
                name.text="  规格"
                nameValue.text=entity!.goodUcode
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 5:
                name.text="  价格"
                if entity!.goodsPrice != nil{
                    nameValue.text="￥\(entity!.goodsPrice!)"
                }
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 6:
                name.text="  条码"
                nameValue.text=entity!.goodInfoCode
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            default:break
            }
            break
        case 1:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="商品其他详细信息"
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
                name.text="保质期"
                if entity!.goodLife != nil{
                    nameValue.text="\(entity!.goodLife!)天"
                }
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 3:
                name.text="  产地"
                
                nameValue.text=entity!.goodSource
                
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 4:
                name.text="  售后"
                nameValue.text=entity!.goodService
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 5:
                name.text="  配料"
                nameValue.text=entity!.goodMixed
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 6:
                name.text="  描述"
                nameValue.text=entity!.remark
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            case 7:
                name.text=" 提供人"
                nameValue.text=entity!.producer
                cell!.contentView.addSubview(name)
                cell!.contentView.addSubview(nameValue)
                break
            default:break
            }
            
            break
        case 2:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="商品的图片信息"
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
                collectionView.isScrollEnabled=false
                collectionView.backgroundColor=UIColor.clear
                collectionView.tag=100
                collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCellId")
                cell!.contentView.addSubview(collectionView)
                break
            default:break
            }
            break
        case 3:
            if indexPath.row == 0{
                cell!.textLabel!.text="商品的来源信息"
            }else{
                let layout=UICollectionViewFlowLayout()
                let cellWidth=70
                layout.itemSize=CGSize(width:cellWidth,height:100)
                layout.scrollDirection = UICollectionViewScrollDirection.horizontal
                layout.minimumLineSpacing = 7.5;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右
                if sourceCollectionView == nil{
                    sourceCollectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: boundsWidth-30,height: 100), collectionViewLayout:layout)
                    sourceCollectionView.dataSource=self
                    sourceCollectionView.delegate=self
                    sourceCollectionView.tag=200
                    sourceCollectionView.backgroundColor=UIColor.clear
                    sourceCollectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"SourceCollectionViewCell")
                    cell!.contentView.addSubview(sourceCollectionView)
                }
            }
            break
        default:break
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 2
        }else if section == 3{
            return 2
        }else if section == 0{
            return 7
        }else{
            return 8
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            if indexPath.row == 1{
                return 100
            }else{
                return 50
            }
        }else if indexPath.section == 3{
            if indexPath.row == 1{
                return 130
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
extension GoodDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cells=UICollectionViewCell()
        if collectionView.tag == 100{
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
            cells=cell
        }else{
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "SourceCollectionViewCell", for: indexPath)
            let goodImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 70,height: 70))
            goodImg.layer.borderColor=UIColor.borderColor().cgColor
            goodImg.layer.borderWidth=1
            cell.contentView.addSubview(goodImg)
            let btnLyInfo=ButtonControl().button(ButtonType.cornerRadiusButton, text:"", textColor: UIColor.black, font:13, backgroundColor: UIColor.white, cornerRadius:10)
            btnLyInfo.frame=CGRect(x: 0,y: 80,width: 70,height: 20)
            btnLyInfo.layer.borderColor=UIColor.borderColor().cgColor
            btnLyInfo.layer.borderWidth=1
            cell.contentView.addSubview(btnLyInfo)
            let entity=sourceArr[indexPath.row]
            if entity.miaoshu != nil{
                btnLyInfo.setTitle(entity.miaoshu, for: UIControlState())
            }else{
                btnLyInfo.setTitle("来源描述", for: UIControlState())
            }
            if sourceArr.count > 0{
                entity.testgoodsdetailspic=entity.testgoodsdetailspic ?? ""
                goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+entity.testgoodsdetailspic!), placeholderImage:UIImage(named: "addImg"))
                
            }else{
                goodImg.image=UIImage(named:"addImg")
            }
            cells=cell
        }
        return cells
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100{
            return imgArr.count
        }else{
            return sourceArr.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - 网络请求
extension GoodDetailsViewController{
    func httpGoodDetailsInfo(){
        self.showSVProgressHUD("正在加载...", type: HUD.text)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.getGoodsById(goodsbasicInfoId: goodsbasicInfoId!), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            print(json)
            self.entity=self.jsonMappingEntity(GoodDetailsEntity(), object:json["ga"].object)
            self.entity!.sCategoryName=json["sCategoryName"].string
            self.imgArr.append(self.entity!.goodPic!)
            for(_,value) in json["goodsdetailspic"]{
                let imgPic=value["goodsDetailsPic"].stringValue
                self.imgArr.append(imgPic)
            }
            for(_,value) in json["tg"]{
                let entity=self.jsonMappingEntity(SourceEntity(), object: value.object)
                self.sourceArr.append(entity!)
            }
            self.buildView()
            self.dismissHUD()
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
