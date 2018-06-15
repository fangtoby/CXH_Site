//
//  BindWxAndAliViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/15.
//  Copyright © 2018年 zltx. All rights reserved.
//

///绑定微信支付宝
class BindWxAndAliViewController:BaseViewController{
    private var storeId=userDefaults.object(forKey: "storeId") as! Int
    private var table:UITableView!
    private var nameArr=["微信账号","支付宝账号"]
    //是否绑定微信
    var wxBindStatu=false
    //是否绑定支付宝
    var aliBindStatu=false
    ///支付用户昵称
    var alipayNickName:String?
    ///微信昵称
    var wx_nickname:String?
    ///保存获取验证码
    private var randCode:String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="收款账号信息"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame: CGRect.zero)
        self.view.addSubview(table)
        queryStoreBindWxOrAliStatu()
    }
}
extension BindWxAndAliViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier:"osId")
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "osId")
        }
        cell!.accessoryType = .disclosureIndicator
        cell!.textLabel!.text=nameArr[indexPath.row]
        cell!.textLabel!.font=UIFont.systemFont(ofSize:14)
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize:12)
        if indexPath.row == 0{
            if wxBindStatu{
                cell!.detailTextLabel!.text=alipayNickName
            }else{
                cell!.detailTextLabel!.text="未绑定"
            }
        }else{
            if aliBindStatu{
                cell!.detailTextLabel!.text=wx_nickname
            }else{
                cell!.detailTextLabel!.text="未绑定"
            }
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        if indexPath.row == 0{
            if wxBindStatu{//如果绑定跳转到详情页面
                UIAlertController.showAlertYesNo(self, title:"重要提示", message:"您要修改您的微信绑定信息吗?", cancelButtonTitle:"取消", okButtonTitle:"确定") { (action) in
                    self.verificationCode(flag:1)
                }
            }else{//绑定
                verificationCode(flag:1)
            }
        }else{
            if aliBindStatu{ //如果绑定跳转到详情页面
                UIAlertController.showAlertYesNo(self, title:"重要提示", message:"您要修改您的支付宝绑定信息吗?", cancelButtonTitle:"取消", okButtonTitle:"确定") { (action) in
                    self.verificationCode(flag:2)
                }
            }else{//绑定
                verificationCode(flag:2)
            }
        }
    }
}
///网络请求
extension BindWxAndAliViewController{
    //查询店铺是否绑定微信或者支付宝 ，并返回相应的基本信息
    private func queryStoreBindWxOrAliStatu(){

        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.queryStoreBindWxOrAliStatu(storeId:storeId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            self.wxBindStatu=json["wxBindStatu"].boolValue
            self.aliBindStatu=json["aliBindStatu"].boolValue
            if self.aliBindStatu{
                self.alipayNickName=json["alipayforstoreInfo"]["alipayNickName"].string

            }
            if self.wxBindStatu{
                self.wx_nickname=json["wxforstoreInfo"]["wx_nickname"].string
            }
            self.table.reloadData()
            self.dismissHUD()
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///绑定支付宝账号
    private func updateStoreBindAli(auth_code:String){
        self.showSVProgressHUD("正在绑定...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.updateStoreBindAli(storeId:storeId, auth_code: auth_code), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let success=json["success"].stringValue
            if success == "success"{
                UIAlertController.showAlertYes(self, title:"绑定成功", message:"您已成功绑定支付宝账号", okButtonTitle:"知道了")
                self.queryStoreBindWxOrAliStatu()
            }else if success == "aliUserIdExist"{
                self.showSVProgressHUD("此支付宝已经绑定其他的站点了", type: HUD.error)
            }else{
                self.showSVProgressHUD("绑定失败", type: HUD.error)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///获取支付宝授权参数 ； 调起支付宝授权所需的请求参数
    private func query_ali_AuthParams(){
        self.showSVProgressHUD("正在调起支付宝...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.query_store_ali_AuthParams(storeId:storeId), successClosure: { (any) in
            let json=self.swiftJSON(any)
            self.dismissHUD()
            let str=json["ali_auth_app_login"].stringValue
            AliPayManager.shared.login(self,withInfo:str, loginSuccess: { (str) in
                //print(str)
                let resultArr=str.components(separatedBy:"&")
                for(subResult) in resultArr{
                    if subResult.count > 10 && subResult.hasPrefix("auth_code="){
                        let auth_code=subResult[subResult.index(subResult.startIndex, offsetBy:10)...]
                        //print(auth_code)
                        self.updateStoreBindAli(auth_code:String(auth_code))
                        return
                    }
                }
                self.showSVProgressHUD("绑定失败", type: HUD.error)
            }, loginFail: {
                self.showSVProgressHUD("绑定失败", type: HUD.error)
            })
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///绑定微信
    private func updateStoreBindWx(code:String){
        self.showSVProgressHUD("正在绑定...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.updateStoreBindWx(storeId:storeId, code: code), successClosure: { (any) in
            let json=self.swiftJSON(any)
            let success=json["success"].stringValue
            if success=="success"{
                UIAlertController.showAlertYes(self, title:"绑定成功", message:"您已成功绑定微信账号", okButtonTitle:"知道了")
                self.queryStoreBindWxOrAliStatu()
            }else if success == "openIdExist"{
                self.showSVProgressHUD("此微信已经绑定了其他站点", type: HUD.error)
            }else{
                self.showSVProgressHUD("绑定失败", type: HUD.error)
            }
        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
    ///验证  1微信 2支付宝
    private func verificationCode(flag:Int){
        if randCode == nil{//如果没有输入 发送验证码
            UIAlertController.showAlertYesNo(self, title:"安全验证", message:"防止账号被其他人绑定,请先获取验证码", cancelButtonTitle:"取消", okButtonTitle:"获取验证码") { (action) in
                self.sendVerificationCode(flag:flag)
            }
        }else{//直接去绑定
            if flag == 1{//微信
                WXApiManager.shared.login(self, loginSuccess: { (code) in
                    self.updateStoreBindWx(code:code)
                }, loginFail: {
                    self.showSVProgressHUD("绑定失败", type: HUD.error)
                })
            }else{//支付宝
                self.query_ali_AuthParams()
            }
        }
    }
    ///1微信 2支付宝
    private func inputVerificationCode(flag:Int){
        let alert = UIAlertController(title:"重要提示", message:"如果您取消输入验证码,需要等待1分钟以后才能重新获得验证码", preferredStyle: UIAlertControllerStyle.alert);
        alert.addTextField(configurationHandler: { (txt) in
            txt.keyboardType = .numberPad
            txt.placeholder="请输入验证码"
            NotificationCenter.default.addObserver(self, selector: #selector(self.alertTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange,object:txt)
        })
        //确定
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,handler:{ Void in
            let text=(alert.textFields?.first)! as UITextField
            if text.text != nil{
                if self.randCode == text.text{
                    if flag == 1{//微信
                        WXApiManager.shared.login(self, loginSuccess: { (code) in
                            self.updateStoreBindWx(code:code)
                        }, loginFail: {
                            self.showSVProgressHUD("绑定失败", type: HUD.error)
                        })
                    }else{//支付宝
                        self.query_ali_AuthParams()
                    }
                }else{
                    self.showSVProgressHUD("验证码输入错误", type: HUD.error)
                    self.inputVerificationCode(flag:flag)
                }
            }
        })
        let cAction=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel) { (action) in
            ///清空验证码
            self.randCode=nil
        }
        alert.addAction(cAction)
        alert.addAction(okAction)
        okAction.isEnabled=false
        self.present(alert, animated: true, completion: nil)
    }
    //检测输入框
    @objc func alertTextFieldDidChange(_ notification: Notification){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let text = (alertController!.textFields?.first)! as UITextField
            let okAction = alertController!.actions.last! as UIAlertAction
            if text.text != nil && text.text!.count > 0 {
                okAction.isEnabled = true
            }else{
                okAction.isEnabled=false
            }
        }
    }
    ///发送验证码 1微信 2支付宝
    private func sendVerificationCode(flag:Int){
        ///获取账号
        let account=userDefaults.object(forKey:"userAccount") as? String ?? ""
        self.showSVProgressHUD("正在获取验证码...", type: HUD.textClear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(NewRequestAPI.sendDuanxin(account:account), successClosure: { (any) in
            let json=self.swiftJSON(any)
            //print(json)
            let success=json["success"].stringValue
            if success == "success"{
                self.dismissHUD()
                self.randCode=json["randCode"].stringValue
                self.inputVerificationCode(flag:flag)
            }else{
                self.showSVProgressHUD("获取验证码失败", type: HUD.error)
            }

        }) { (error) in
            self.showSVProgressHUD(error!, type: HUD.error)
        }
    }
}
