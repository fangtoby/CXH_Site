//
//
//                   _oo8oo_
//                  o8888888o
//                  88" . "88
//                  (| -_- |)
//                  0\  =  /0
//                ___/'==='\___
//              .' \\|     |// '.
//             / \\|||  :  |||// \
//            / _||||| -:- |||||_ \
//           |   | \\\  -  /// |   |
//           | \_|  ''\---/''  |_/ |
//           \  .-\__  '-'  __/-.  /
//         ___'. .'  /--.--\  '. .'___
//      ."" '<  '.___\_<|>_/___.'  >' "".
//     | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//     \  \ `-.   \_ __\ /__ _/   .-` /  /
// =====`-.____`.___ \_____/ ___.`____.-`=====
//                   `=---=`
//
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//        佛祖保佑         永不闪退/永无bug

//NSLog使用指示符

//指示符	描述
//%@	对象，String、Array、Dictionary等都是对象
//%%	『%』字符
//%d,%D	带符号的32位整数
//%u,%U	无符号的32位整数
//%x,%X	无符号的32位整数，按照16进制输出
//%o,%O	无符号的32位整数，按照8进制输出
//%f	64位浮点数
//%e,%E	64位浮点数，按照科学记数法输出
//%c	八位无符号字符
//%C	16位Unicode字符
//%a,%A	64位浮点数，按照科学记数法输出
//%F	64位浮点数，按照16进制输出
//
//  PublicUtility.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/3/11.
//  Copyright © 2016年 penghao. All rights reserved.
import Foundation
import SDWebImage
//app公用常量

///图片请求路径
let URLIMG="http://192.168.1.142";
///数据请求路径  http://192.168.199.121/
let URL="http://192.168.1.142/";

let SERVERERROR="服务器异常"
/// 屏幕宽
let boundsWidth=UIScreen.main.bounds.width

/// 屏幕高
let boundsHeight=UIScreen.main.bounds.height

/// 全局缓存
let userDefaults=UserDefaults.standard

/// 导航栏高度
let navHeight:CGFloat=boundsHeight==812.0 ? 88 : 64

/// 底部安全距离
let bottomSafetyDistanceHeight:CGFloat=boundsHeight==812.0 ? 34 : 0

/// tabBar高度
let tabBarHeight:CGFloat=boundsHeight==812.0 ? 83 : 49

//app公用方法

/**
用Storyboard构建页面需要StoryboardId找到页面

- parameter storyboardId:

- returns: 返回UIViewController
*/
func storyboardPushView(_ storyboardId:String) -> UIViewController{
    //先拿到main文件
    let storyboard=UIStoryboard(name:"Main", bundle:nil);
    let vc=storyboard.instantiateViewController(withIdentifier: storyboardId) as UIViewController;
    return vc
}

extension UIImage{
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {

        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in:  CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    // 通过"UIColor"返回一张“UIImage”
    class func imageFromColor(_ color: UIColor) -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)

        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
//设置文字红色
func redText(_ str:String) -> NSMutableAttributedString{
    let nsStr:NSMutableAttributedString=NSMutableAttributedString(string:str);
    let normalAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red]
    nsStr.addAttributes(normalAttributes, range:NSMakeRange(0,1))
    return nsStr
}
func isStrNil(_ arr:[String?]) -> Bool{
    var b=true
    for i in 0..<arr.count{
        if arr[i] != nil && arr[i]!.count > 0{
            for j in 0..<arr.count{
                if arr[j] == nil || arr[j]!.count == 0{
                    b=false
                }
            }
        }
    }
    return b
}
/**
 中文转拼音首字母

 - parameter str: String

 - returns:String
 */
func chineISInitials(_ str:String)->String{
    let str1:CFMutableString = CFStringCreateMutableCopy(nil, 0, str as CFString);
    CFStringTransform(str1, nil, kCFStringTransformToLatin, false)
    CFStringTransform(str1, nil, kCFStringTransformStripCombiningMarks, false)
    let str2 = CFStringCreateWithSubstring(nil, str1, CFRangeMake(0, 1))
    return (str2! as String).capitalized
}
// MARK: - 扩展UIButton
extension UIButton{
    
    /// 实现按钮半透明+不可点效果
    func disable(){
        self.isEnabled = false
        self.alpha = 0.5
        
    }
    /// 正常按钮+可点击效果
    func enable(){
        self.isEnabled = true
        self.alpha = 1
    }
    
}
// 扩展String

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[(startIndex ..< endIndex)])
        }
    }
}
extension String{
    /**
     过滤特殊字符
     
     - returns:
     */
    func check() -> String {
        
        let  result = NSMutableString()
        // 使用正则表达式一定要加try语句
        
        do {
            
            // - 1、创建规则
            
            let pattern = "[a-zA-Z_0-9_一-龥]"
            
            // - 2、创建正则表达式对象
            
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            // - 3、开始匹配
            
            let res = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count))
            
            // 输出结果
            
            for checkingRes in res {
                
                let nn = (self as NSString).substring(with: checkingRes.range) as NSString
                
                result.append(nn as String)
                
            }
            
        }
            
        catch {
            
            print(error)
            
        }
        
        return result as String
        
    }
}

/**
 判断字符是否为空
 
 - parameter str: 字符
 
 - returns: 结果(true表示不为空)
 */
func isStringNil(_ str:String?) -> Bool{
    var b=true
    if str == nil{
       b=false
       
    }else{
        if str == "" || str!.count == 0{
            b=false
        }else{
            b=true
        }
    }
    return b
}
/**
获取缓存中的会员ID

- returns: 返回Optional对象 自行判断
*/
func IS_NIL_MEMBERID() -> Int?{
    return userDefaults.object(forKey: "memberId") as? Int
}
/**
 计算缓存  计算MB
 - returns: 缓存大小
 */
func folderSizeAtPath() -> Float{
    var folderSize:Float
    folderSize=Float(SDImageCache.shared().getSize())/1024.0/1024.0
    return folderSize
}
/**
 清除图片缓存
 */
func clearCache(){
    SDImageCache.shared().clearDisk()
}
/**
 截取Double小数点后2位
 */
func toDecimalNumberTwo(_ float:Double) ->String{
    let str=NSString(format:"%.2f",float)
    return "\(str.doubleValue)";
    
}
//截取小数点后1位
func toFloatTwo(_ float:Float) ->String{
    let str=NSString(format:"%.1f",float)
    return "\(str.floatValue)"
}
// MARK: - 扩展Double
extension Double{
    /**
     截取Double小数点后2位
     */
    func toDecimalNumberTwo(_ float:Double) ->Double{
        let str=NSString(format:"%.2f",float)
        return str.doubleValue;
        
    }
}

// MARK: - 扩展字符串
extension String {
    /**
     //根据文字多少大小计算UILabel的宽高度
     
     - parameter font: UILabel大小
     - parameter size: UILabel的最大宽高
     
     - returns: 当前文本所占的宽高
     */
    func textSizeWithFont(_ font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if __CGSizeEqualToSize(size,CGSize.zero){
            let attributes=NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
            textSize=self.size(withAttributes:attributes as? [NSAttributedStringKey : Any])
        }else{
            let attributes=NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
            let stringRect = self.boundingRect(with:size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes as? [NSAttributedStringKey : Any], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
    /**
     判断字符串中是否有中文
     
     - parameter str: 传入字符串
     
     - returns: bool
     */
    func IsChinese(_ str:String) ->Bool{
        var flag=false;
        let length=NSString(string: str).length;
        for i in 0..<length{
            let range=NSMakeRange(i,1);
            let subString:NSString=NSString(string: str).substring(with: range) as NSString;
            let char=subString.utf8String;
            if strlen(char) == 3{
                flag=true;
            }
        }
        return flag;
    }

}

/**
 计算时间差
 
 - parameter dateStr:传入日期字符串
 
 - returns:返回时间差
 */
func stringDate(_ dateStr:String)->String{
    //转换成日期格式
    let inputFormatter=DateFormatter();
    inputFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
    let date=inputFormatter.date(from: dateStr)

    let now = Date()
    //now即为现在的时间，由于后面的NSCalendar可以匹配系统日期所以不用设置local
    let das = Calendar.current
    let flags: NSCalendar.Unit = [.year,.month,.day,.hour,.minute]
    //设置格式
    let nowCom = (das as NSCalendar).components(flags, from: now)
    let timeCom = (das as NSCalendar).components(flags, from: date!)
    if timeCom.year == nowCom.year{
        if timeCom.month == nowCom.month {
            if timeCom.day == nowCom.day{
                if timeCom.hour == nowCom.hour{
                    return "\(nowCom.minute! - timeCom.minute!)分钟前"
                }else{
                    return "今天\(timeCom.hour!):\(timeCom.minute!)"
                }
            }else{
                if nowCom.day! - timeCom.day! == 1{
                    return "昨天\(timeCom.hour!):\(timeCom.minute!)"
                }else{
                    return "\(nowCom.day! - timeCom.day!)天前"
                }
            }
        }else{
            return "\(nowCom.month! - timeCom.month!)月前"
        }
        
    }else{
        return "\(timeCom.year!)-\(timeCom.month!)-\(timeCom.day!)"
    }
    
}
// MARK: - 扩展系统自带弹出层
extension UIAlertController {
    /**
     弹出单个按钮
     
     - parameter presentController: 传入self
     - parameter title:             标题名称名称
     - parameter message:           弹出内容
     - parameter okButtonTitle:     按钮名称
     */
    class func showAlertYes(_ presentController: UIViewController!,title: String!,message: String!,okButtonTitle: String?) {
            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.alert)
            if (okButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.default, handler: nil))
            }
            
            presentController!.present(alert, animated: true, completion: nil)
    }
    /**
    弹出单个按钮(需要传入一个闭包参数)
    
     - parameter presentController: 传入self
     - parameter title:             标题名称名称
     - parameter message:           弹出内容
     - parameter okButtonTitle:     按钮名称
     - parameter okHandler:         闭包参数
     */
    class func showAlertYes(_ presentController: UIViewController!,title: String!,message: String!,okButtonTitle: String? ,okHandler: ((UIAlertAction?) -> Void)!) {
            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.alert)
            if (okButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.default, handler: okHandler))
            }
            
            presentController!.present(alert, animated: true, completion: nil)
    }
    /**
     弹出带确定取消的按钮
     
     - parameter presentController: 传入self
     - parameter title:             标题名称名称
     - parameter message:           弹出内容
     - parameter okButtonTitle:     确定按钮名称
     - parameter cancelButtonTitle: 取消按钮名称
     */
    class func showAlertYesNo(_ presentController: UIViewController!,title: String!,message: String!,cancelButtonTitle: String?,okButtonTitle: String?) {
            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.alert)
            if (cancelButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.default, handler: nil))
            }
            if (okButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.default, handler: nil))
            }
            
            presentController!.present(alert, animated: true, completion: nil)
    }
    /**
     弹出带确定取消的按钮(需要传入一个闭包参数)
     
     - parameter presentController: 传入self
     - parameter title:             标题名称名称
     - parameter message:           弹出内容
     - parameter okButtonTitle:     确定按钮名称
     - parameter cancelButtonTitle: 取消按钮名称
     - parameter okHandler:         闭包参数
     */
    class func showAlertYesNo(_ presentController: UIViewController!,title: String!,message: String!,cancelButtonTitle: String? ,okButtonTitle: String? ,okHandler: ((UIAlertAction?) -> Void)!) {
            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.alert)
            if (cancelButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.default, handler: nil))
            }
            if (okButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.default, handler: okHandler))
            }
            presentController!.present(alert, animated: true, completion: nil)
    }
    /**
     弹出带确定取消的按钮(需要传入2个闭包参数)
     
     - parameter presentController: 传入self
     - parameter title:             标题名称名称
     - parameter message:           弹出内容
     - parameter okButtonTitle:     确定按钮名称
     - parameter cancelButtonTitle: 取消按钮名称
     - parameter okHandler:         闭包参数
     */
    class func showAlertYesNo(_ presentController: UIViewController!,title: String!,message: String!,cancelButtonTitle: String? ,okButtonTitle: String? ,okHandler: ((UIAlertAction?) -> Void)!,cancelHandler:((UIAlertAction?) -> Void)!) {
        let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.alert)
        if (cancelButtonTitle != nil) {
            alert.addAction(UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.default, handler:cancelHandler))
        }
        if (okButtonTitle != nil) {
            alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.default, handler: okHandler))
        }
        presentController!.present(alert, animated: true, completion: nil)
    }
}

/**
 各个页面为空提示
 
 - parameter str: 传入提示信息
 
 - returns: 返回UILabel
 */
func nilTitle(_ str:String) ->UILabel{
    let lbl=UILabel(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 20))
    lbl.text=str
    lbl.textColor=UIColor.textColor()
    lbl.font=UIFont.boldSystemFont(ofSize: 14)
    lbl.textAlignment = .center
    return lbl
}







