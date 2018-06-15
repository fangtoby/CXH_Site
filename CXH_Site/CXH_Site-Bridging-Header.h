//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//重写导航栏返回事件
#import "UIViewController+BackButtonHandler.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SEPrinterManager.h"
/// 文本默认提示
#import "UITextView+Placeholder.h"
///微信
#import "WXApi.h"
#import "WXApiObject.h"
//支付宝
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
//百度移动统计
#import "BaiduMobStat.h"

/// 引入 按钮Badge效果
#import "UIButton+Badge.h"

