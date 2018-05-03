//
//  UpdateGoodViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2017/6/4.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 修改商品信息
class UpdateGoodViewController:BaseViewController{
    var goodsbasicInfoId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="修改商品信息"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
    }
}