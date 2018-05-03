//
//  ReturnGoodsViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/14.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 退款/售后
class ReturnGoodsViewController:BaseViewController{
    let memberHasVc=MemberHasMailViewController()
    let VC=YReturnGoodsViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="退款/售后"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        memberHasVc.title="待退款"
        VC.title="已退款"
        let skScNavC=SKScNavViewController(subViewControllers:[memberHasVc,VC])
        skScNavC.showArrowButton=false
        skScNavC.addParentController(self)
    }
}
