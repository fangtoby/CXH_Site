//
//  CourierListViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/5.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 揽件清单
class CourierListViewController:BaseViewController{
    let stayVC=StayCouierViewController()
    let hasVC=HasCourierViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="揽件清单"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        stayVC.title="待揽件"
        hasVC.title="已揽件"
        let skScNavC=SKScNavViewController(subViewControllers:[stayVC,hasVC])
        skScNavC.showArrowButton=false
        skScNavC.addParentController(self)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target:self, action:#selector(searchVC))
    }
    @objc func searchVC(){
        let vc=SearchCourierViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
