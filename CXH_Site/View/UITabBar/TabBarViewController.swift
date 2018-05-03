////
////  TabBarViewController.swift
////
////
////  Created by hefeiyue on 15/6/5.
////  Copyright (c) 2015年 奈文魔尔. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class TabBarViewController:UITabBarController {
//    override func viewDidLoad() {
//        super.viewDidLoad();
//        //首页
//        addChildViewController(IndexViewController(), title:"首页", imageName: "1")
//        addChildViewController(MallViewController(), title:"商城", imageName:"2")
//        addChildViewController(CarViewController(), title:"购物车", imageName:"3")
//        //个人中心
//        addChildViewController(PersonalCenterView(), title:"会员中心", imageName: "4")
//        self.tabBar.tintColor=UIColor.applicationMainColor()
//     }
//
//    /**
//    初始化子控制器
//    
//    - parameter childController: 需要初始化的子控制器
//    - parameter title:           子控制器的标题
//    - parameter imageName:       子控制器的图片
//    */
//    private func addChildViewController(childController: UIViewController, title:String?, imageName:String) {
//        
//        // 1.设置子控制器对应的数据
//        childController.tabBarItem.image = UIImage(named:imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        childController.tabBarItem.selectedImage = UIImage(named:"selected"+imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        
//        // 2.设置底部工具栏标题
//        childController.tabBarItem.title=title
//        
//        // 3.给子控制器包装一个导航控制器
//        let nav = UINavigationController()
//        nav.addChildViewController(childController)
//        
//        // 4.将子控制器添加到当前控制器上
//        addChildViewController(nav)
//    }
//    deinit{
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//}
