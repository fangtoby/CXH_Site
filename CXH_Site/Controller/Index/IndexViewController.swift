//
//  IndexViewController.swift
//  CXHSalesman
//
//  Created by hao peng on 2017/4/10.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit

/// 我的信息
class IndexViewController:BaseViewController{
    let storeId=userDefaults.object(forKey: "storeId") as! Int

    /// 信息view
    fileprivate var informationView:UIImageView!
    ///
    fileprivate var collectionView:UICollectionView!
    fileprivate let identity=userDefaults.object(forKey: "identity") as! Int
    fileprivate var imgArr=["classify_1","sdsj","classify_3","classify_5","classify_6","classify_7","classify_8","classify_9","classify_10"]
    fileprivate var nameArr=["扫码收件","手动收件","手动揽件","收件历史","揽件清单","我的信息","商品管理","我的订单","批发授权"]
    ///订单总数
    private var orderCount:Int=0
    ///站点需要确认的退款售后订单数量
    private var returnGoodsCount:Int=0
    ///个人中心的数量
    private var userInfoCount=0
    ///保存订单集合
    private var orderCountArr=[OrderCountEntity]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryCountOrderGroupByOrderStatuByStoreId()
        queryStoreStatisticsByVariousStatesCount()
        self.navigationController?.navigationBar.isTranslucent=false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="首页"
        self.view.backgroundColor=UIColor.viewBackgroundColor()

        if identity == 3{
            imgArr=["classify_1","sdsj","classify_5","classify_6","classify_7"]
            nameArr=["扫码收件","手动揽件","收件历史","揽件清单","我的信息"]
            
        }else if identity == 1{
            imgArr=["classify_1","classify_1","classify_7"]
            nameArr=["扫码揽/返件","扫码代签收","我的信息"]
            
        }else if identity == 4{
            imgArr=["classify_8","classify_7"]
            nameArr=["菜品管理","切换账号"]
        }
        buildView()

    }
}

// MARK: - 构建页面
extension IndexViewController{
    
    func buildView(){
        informationView=UIImageView()
        informationView.image=UIImage(named:"index_bac")
        self.view.addSubview(informationView)
        
        
        let layout=UICollectionViewFlowLayout()
        let cellWidth=boundsWidth/3
        layout.itemSize=CGSize(width:cellWidth,height:cellWidth)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
        layout.minimumLineSpacing = 0;//每个相邻layout的上下
        layout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        collectionView=UICollectionView(frame:CGRect(x:0,y:0,width:0,height:0), collectionViewLayout:layout)
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.isScrollEnabled=false
        collectionView.backgroundColor=UIColor.clear
        collectionView.register(IndexCollectionViewCell.self,forCellWithReuseIdentifier:"IndexCollectionViewCell")
        self.view.addSubview(collectionView)
        informationView.snp.makeConstraints { (make) in
            make.width.equalTo(boundsWidth)
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(130)
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(informationView.snp.bottom).offset(10)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(boundsWidth)
        }
        
    }
}

// MARK: - 实现协议
extension IndexViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "IndexCollectionViewCell", for:indexPath) as! IndexCollectionViewCell
        let imgStr=imgArr[indexPath.row]
        let str=nameArr[indexPath.row]
        switch indexPath.item / 3 {
        case 0:
            cell.linwSeparatorOptions = [.top, .right]
        case 1:
            cell.linwSeparatorOptions = [.top, .right]
        case 2:
            cell.linwSeparatorOptions = [.top, .right, .bottom]
        default:
            {}()
        }
        if identity == 2{
            if indexPath.item == 7{
                cell.btnBadge.badgeValue=orderCount==0 ? "":orderCount.description
            }else{
                if indexPath.item == 5{
                    cell.btnBadge.badgeValue=userInfoCount==0 ? "":userInfoCount.description
                }else{
                    cell.btnBadge.badgeValue=""
                }
            }
        }
        cell.updateCell(imgStr,str:str)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArr.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if identity == 2{//站点
            switch indexPath.row {
            case 0:
                let camera: PrivateResource = .camera
                let propose: Propose = {
                    proposeToAccess(camera, agreed: {
                        let vc=SweepCodeReceiptViewController()
                        self.navigationController?.pushViewController(vc, animated:true)
                    }, rejected: {
                        self.alertNoPermissionToAccess(camera)
                    })
                }
                showProposeMessageIfNeedFor(camera, andTryPropose: propose)

                break
            case 1:
                let vc=ManualReceiptViewController()
                vc.flag=2
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 2:
                let vc=CourierEntryViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 3:
                let vc=StoreInboxViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 4:
                let vc=CourierListViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            case 5:
                let vc=PersonalCenterViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 6:
                let vc=GoodListViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 7:
                let vc=OrderListViewController()
                vc.orderCountArr=self.orderCountArr
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 8:
                let vc=WholesaleAuthViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }else if identity == 3{//司机
            switch indexPath.row {
            case 0:
                let vc=SweepCodeReceiptViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 1:
                let vc=ManualReceiptViewController()
                vc.flag=3
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 2:
                let vc=LogisticsInboxViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 3:
                let vc=CourierListViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 4:
                let vc=PersonalCenterViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            default:
                break
            }
        }else if identity == 1{//仓库管理员
            switch indexPath.row {
            case 0:
                let vc=SweepCodeReceiptViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            case 1:
                let vc=CKSweepCodeReceiptViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            case 2:
                let vc=PersonalCenterViewController()
                self.navigationController?.pushViewController(vc, animated:true)
                break
            default:
                break
            }
        }else if identity == 4{
            if indexPath.row == 0{
                let vc=FoodListViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            }else{
                returnLogin()
            }
        }
    }
    /**
     退出登录
     */
    func returnLogin(){
        UIAlertController.showAlertYesNo(self, title:"城乡惠", message:"您确定要退出登录吗?", cancelButtonTitle:"取消", okButtonTitle:"确定") {  Void in
            //清除缓存中会员id
            userDefaults.removeObject(forKey: "storeId")
            userDefaults.removeObject(forKey: "userId")
            userDefaults.synchronize();
            //切换根视图
            let app=UIApplication.shared.delegate as! AppDelegate
            let vc=LoginViewController()
            app.window?.rootViewController=UINavigationController(rootViewController:vc);
        }
    }
    ///查询订单数量
    private func queryCountOrderGroupByOrderStatuByStoreId(){
        self.orderCount=0

        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryCountOrderGroupByOrderStatuByStoreId(storeId:storeId), successClosure: { (any) in
            
            let json=self.swiftJSON(any)
            self.orderCountArr=self.jsonMappingArrEntity(OrderCountEntity(), object:json.object) ?? [OrderCountEntity]()
            if self.orderCountArr.count > 0{
                for i in 0..<self.orderCountArr.filter({ (entity) -> Bool in
                    if entity.orderStatu == 2 || entity.orderStatu == 3{
                       return true
                    }else{
                        return false
                    }

                }).count{
                    self.orderCount+=self.orderCountArr[i].countOrder ?? 0
                }
                self.collectionView.reloadItems(at: [IndexPath.init(row:7, section:0)])
            }
        }) { (error) in
            self.showSVProgressHUD("查询订单数量失败", type: HUD.error)
        }
    }
    ///查询各种订单数量
    private func queryStoreStatisticsByVariousStatesCount(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStoreStatisticsByVariousStatesCount(storeId:storeId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            self.userInfoCount=json["returnGoodsCount"].intValue+json["expressmailUpdateCount"].intValue
            self.collectionView.reloadItems(at: [IndexPath.init(row:5, section:0)])
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
}
