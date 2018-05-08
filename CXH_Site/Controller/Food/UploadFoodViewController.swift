//
//  UploadFoodViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/10/20.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
/// 上传菜品
class UploadFoodViewController:BaseViewController {
    fileprivate var scrollView:UIScrollView!
    fileprivate var table:UITableView!
    fileprivate var txtGoodInfoName:UITextField!
    fileprivate var txtGoodUcode:UITextField!
    fileprivate var txtGoodUnit:UITextField!
    fileprivate var txtGoodsPrice:UITextField!
    fileprivate var txtStock:UITextField!
    fileprivate var txtGoodLife:UITextField!
    fileprivate var lblGoodSource:UILabel!
    fileprivate var txtGoodService:UITextField!
    fileprivate var txtGoodPic:UITextField!
    fileprivate var txtGoodsDetailsPic:UITextField!
    fileprivate var txtGoodInfoCode:UITextField!
    fileprivate var txtGoodMixed:UITextField!
    fileprivate var txtRemark:UITextField!
    fileprivate var imgGoodImg:UIImageView!
    fileprivate var imgGoodDetailsImg1:UIImageView!
    fileprivate var imgGoodDetailsImg2:UIImageView!
    fileprivate var imgGoodDetailsImg3:UIImageView!
    fileprivate var collectionView:UICollectionView!
    fileprivate var imgArr=["addImg"]
    fileprivate var categoryArr=[GoodsCategoryEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="上传菜品"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        scrollView=UIScrollView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight))
        self.view.addSubview(scrollView)
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 12*50+80))
        table.delegate=self
        table.dataSource=self
        table.isScrollEnabled=false
        scrollView.addSubview(table)
        
        let btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"确认上传", textColor:UIColor.white, font:15, backgroundColor:UIColor.applicationMainColor(), cornerRadius:20)
        btn.frame=CGRect(x: 30,y: table.frame.maxY+30,width: boundsWidth-60,height: 40)
        btn.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        
        scrollView.addSubview(btn)
        scrollView.contentSize=CGSize(width: boundsWidth,height: btn.frame.maxY+30)
        
        //监听地区选择通知
        NotificationCenter.default.addObserver(self,selector:#selector(updateAddress), name:NSNotification.Name(rawValue: "postUpdateAddress"), object:nil)
    }
    @objc func updateAddress(_ obj:Notification){
        let addressStr=obj.object as! String
        let addressArr=addressStr.components(separatedBy: "-")
        lblGoodSource.text=addressArr[0]+addressArr[1]+addressArr[2]
    }
}
// MARK: - 提交
extension UploadFoodViewController{
    @objc func submit(){
        let goodInfoName=txtGoodInfoName.text
        let goodUcode=txtGoodUcode.text
        let goodUnit=txtGoodUnit.text
        let goodsPrice=txtGoodsPrice.text
        let stock=txtStock.text
        var goodInfoCode=txtGoodInfoCode.text
        var goodMixed=txtGoodMixed.text
        var remark=txtRemark.text

        if goodInfoName == nil || goodInfoName!.count == 0{
            self.showSVProgressHUD("菜品名称不能为空", type: HUD.info)
            return
        }
        if goodUcode == nil || goodUcode!.count == 0{
            self.showSVProgressHUD("菜品规格不能为空", type: HUD.info)
            return
        }
        if goodUnit == nil || goodUnit!.count == 0{
            self.showSVProgressHUD("菜品单位不能为空", type: HUD.info)
            return
        }
        if goodsPrice == nil || goodsPrice!.count == 0{
            self.showSVProgressHUD("菜品价格不能为空", type: HUD.info)
            return
        }
        if stock == nil || stock!.count == 0{
            self.showSVProgressHUD("菜品库存不能为空", type: HUD.info)
            return
        }
        if imgArr.count == 1{
            self.showSVProgressHUD("请上传商品图片", type: HUD.info)
            return
        }
        goodInfoCode=goodInfoCode ?? ""
        goodMixed=goodMixed ?? ""
        remark=remark ?? ""
        var goodsDetailsPic=""
        if imgArr.count > 2{
            for i in 1..<imgArr.count-1{
                goodsDetailsPic+=imgArr[i]+","
            }
            print(goodsDetailsPic)
            let index=goodsDetailsPic.characters.index(goodsDetailsPic.endIndex, offsetBy: -1)
            goodsDetailsPic=goodsDetailsPic.substring(to: index)
            print(goodsDetailsPic)
        }
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
        let storeId=userDefaults.object(forKey: "storeId") as! Int
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.saveFood(foodName: goodInfoName!, foodPrice:goodsPrice!, foodRemark:remark!, foodUnit:goodUnit!, foodPic:imgArr[0], testStoreId:storeId,foodUcode:goodUcode!, foodMixed:goodMixed!, foodCode:goodInfoCode!, stock:Int(stock!)!, foodDetailPic: goodsDetailsPic), successClosure: { (result) -> Void in
            let json=self.swiftJSON(result)
            let success=json["success"].stringValue
            print(success)
            if success == "success"{
                self.showSVProgressHUD("上传成功", type: HUD.success)
                self.navigationController?.popViewController(animated: true)
                self.dismissHUD()
            }else{
                self.showSVProgressHUD("上传商品失败", type: HUD.error)
            }
            }) { (errorMsg) -> Void in
                self.showSVProgressHUD(errorMsg!, type: HUD.error)
        }
    }
}
// MARK: - table 协议
extension UploadFoodViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "goodid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"goodid")
        }
        cell!.textLabel!.textColor=UIColor.black
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
        let name=buildLabel(UIColor.textColor(), font:15, textAlignment: NSTextAlignment.left)
        name.frame=CGRect(x: 15,y: 0,width: 55,height: 50)
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                cell!.textLabel!.text="菜品基本信息"
                break
            case 1:
                name.attributedText=redText("*菜品名")
                cell!.contentView.addSubview(name)
                txtGoodInfoName=buildTxt(14, placeholder:"请输入菜品名称", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodInfoName.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodInfoName)
                break
            case 2:
                name.attributedText=redText("*单位")
                cell!.contentView.addSubview(name)
                txtGoodUnit=buildTxt(14, placeholder:"请输入菜品单位,如盘,份,千克等", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodUnit.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodUnit)
                break
            case 3:
                name.attributedText=redText("*规格")
                cell!.contentView.addSubview(name)
                txtGoodUcode=buildTxt(14, placeholder:"请输入菜品规格如(1*1)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodUcode.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodUcode)
                break
            case 4:
                name.attributedText=redText("*价格")
                cell!.contentView.addSubview(name)
                txtGoodsPrice=buildTxt(14, placeholder:"请输入菜品单价", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.decimalPad)
                txtGoodsPrice.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodsPrice)
                break
            case 5:
                name.text="  条码"
                cell!.contentView.addSubview(name)
                txtGoodInfoCode=buildTxt(14, placeholder:"请输入菜品条码(可无)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodInfoCode.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodInfoCode)
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
                name.attributedText=redText("*库存")
                cell!.contentView.addSubview(name)
                txtStock=buildTxt(14, placeholder:"请输入菜品库存", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.numberPad)
                txtStock.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtStock)
                break
            case 2:
                name.text="  配料"
                cell!.contentView.addSubview(name)
                txtGoodMixed=buildTxt(14, placeholder:"请输入菜品相关配料(可无)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtGoodMixed.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtGoodMixed)
                break
            case 3:
                name.text="  描述"
                cell!.contentView.addSubview(name)
                txtRemark=buildTxt(14, placeholder:"请输入菜品描述(可无)", tintColor:UIColor.color999(),keyboardType: UIKeyboardType.default)
                txtRemark.frame=CGRect(x: 75,y: 0,width: boundsWidth-75-30,height: 50)
                cell!.contentView.addSubview(txtRemark)
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
                layout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
                layout.minimumLineSpacing = 0;//每个相邻layout的上下
                layout.minimumInteritemSpacing = 7.5;//每个相邻layout的左右
                collectionView=UICollectionView(frame:CGRect(x: 15,y: 15,width: 325,height: 70), collectionViewLayout:layout)
                collectionView.dataSource=self
                collectionView.delegate=self
                collectionView.isScrollEnabled=false
                collectionView.backgroundColor=UIColor.clear
                
                collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"UICollectionViewCell")
                cell!.contentView.addSubview(collectionView)
                break
            default:break
            }
            break
        default:break
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 6
        }else if section == 1{
            return 4
        }else if section == 2{
            return 2
        }
        return 0
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
//        if indexPath.section == 0{
//            if indexPath.row == 2{
//                let vc=Level1CategoryViewController()
//                let nav=UINavigationController(rootViewController:vc)
//                self.presentViewController(nav, animated:true, completion:nil)
//            }
//        }else if indexPath.section == 1{
//            if indexPath.row == 3{
//                let vc=ShowAddressViewController()
//                let nav=UINavigationController(rootViewController:vc)
//                self.presentViewController(nav, animated:true, completion:nil)
//            }
//        }
    }
    
}
// MARK: - 实现协议
extension UploadFoodViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        let goodImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 70,height: 70))
        goodImg.layer.borderColor=UIColor.borderColor().cgColor
        goodImg.layer.borderWidth=1
        cell.contentView.addSubview(goodImg)
        if imgArr.count > 1{
            let pic=imgArr[indexPath.row]
            goodImg.sd_setImage(with: Foundation.URL(string:URLIMG+pic), placeholderImage:UIImage(named: "addImg"))
        }else{
            goodImg.image=UIImage(named:"addImg")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgArr.count > 4{
            return 4
        }else{
            return imgArr.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.choosePicture(indexPath.row)
    }
}
// MARK: - 上传商品
extension UploadFoodViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //选择图像
    func choosePicture(_ index:Int){
        //图片选择控制器
        let imagePickerController=UIImagePickerController()
        imagePickerController.delegate=self
        imagePickerController.view.tag=index
        // 设置是否可以管理已经存在的图片
        imagePickerController.allowsEditing = true
        // 判断是否支持相机
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let alert:UIAlertController=UIAlertController(title:"修改个人图像", message:"您可以自己拍照或者从相册中选择", preferredStyle: UIAlertControllerStyle.actionSheet)
            let photograph=UIAlertAction(title:"拍照", style: UIAlertActionStyle.default, handler:{
                Void in
                // 设置类型
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
                
                
            })
            let photoAlbum=UIAlertAction(title:"从相册选择", style: UIAlertActionStyle.default, handler:{
                Void in
                // 设置类型
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                //改navigationBar背景色
                imagePickerController.navigationBar.barTintColor = UIColor.applicationMainColor()
                //改navigationBar标题色
                imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                //改navigationBar的button字体色
                imagePickerController.navigationBar.tintColor = UIColor.white
                self.present(imagePickerController, animated: true, completion: nil)
            })
            let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(photograph)
            alert.addAction(photoAlbum)
            alert.addAction(cancel)
            self.present(alert, animated:true, completion:nil)
            
        }
        
        
    }
    //保存图片至沙盒
    func saveImage(_ currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: Data = UIImageJPEGRepresentation(newImage, percent)!
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent(imageName)
        // 将图片写入文件
        try? imageData.write(to: Foundation.URL(fileURLWithPath: filePath), options: [])
    }
    //实现ImagePicker delegate 事件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image: UIImage!
        // 判断，图片是否允许修改
        if(picker.allowsEditing){
            //裁剪后图片
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            //原始图片
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        // 保存图片至本地，方法见下文
        self.saveImage(image, newSize: CGSize(width:boundsWidth, height:boundsWidth), percent:1, imageName: "currentImage.png")
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("currentImage.png")
        //        let imageData = UIImagePNGRepresentation(savedImage);
        self.showSVProgressHUD("正在上传中...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.testStoreUpload(Img:"Img", filePath: filePath), successClosure: { (value) in
            let json=self.swiftJSON(value)
            let pic=json["success"].stringValue
            if pic == "fail"{
                self.showSVProgressHUD("上传图片失败", type: HUD.error)
            }else{
                print(picker.view.tag)
                self.imgArr.insert(pic,at:self.imgArr.count-1)
                self.collectionView.reloadData()
                self.showSVProgressHUD("上传图片成功", type: HUD.success)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    // 当用户取消时，调用该方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
