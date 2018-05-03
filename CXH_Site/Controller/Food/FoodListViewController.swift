//
//  FoodListViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/10/20.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
/// 菜品管理list
class FoodListViewController:BaseViewController{
    let shelvesVC=ShelvesViewController()
    let theShelvesVC=TheShelvesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="菜品管理"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"上传菜品", style: UIBarButtonItemStyle.done, target:self, action:#selector(pushUploadFoodVC))
        shelvesVC.title="已上架"
        shelvesVC.flag=2
        theShelvesVC.title="已下架"
        theShelvesVC.flag=2
        let skScNavC=SKScNavViewController(subViewControllers:[shelvesVC,theShelvesVC])
        skScNavC.showArrowButton=false
        skScNavC.addParentController(self)
    }
    @objc func pushUploadFoodVC(){
        let vc=UploadFoodViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
