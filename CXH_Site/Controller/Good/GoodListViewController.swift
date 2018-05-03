//
//  GoodListViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/3.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
///商品list
class GoodListViewController:BaseViewController{
    let shelvesVC=ShelvesViewController()
    let theShelvesVC=TheShelvesViewController()
    let inExamineVC=InExamineViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
            self.title="商品管理"
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"上传商品", style: UIBarButtonItemStyle.done, target:self, action:#selector(pushUploadVC))
        self.view.backgroundColor=UIColor.white
        shelvesVC.title="已上架"
        shelvesVC.flag=1
        theShelvesVC.title="已下架"
        theShelvesVC.flag=1
        inExamineVC.title="审核中"
        let skScNavC=SKScNavViewController(subViewControllers:[shelvesVC,theShelvesVC,inExamineVC])
        skScNavC.showArrowButton=false
        skScNavC.addParentController(self)
    }
    @objc func pushUploadVC(){
        let vc=UploadGoodViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
