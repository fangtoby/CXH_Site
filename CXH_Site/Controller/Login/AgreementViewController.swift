//
//  AgreementViewController.swift
//  CXH_Site
//
//  Created by hao peng on 2018/5/22.
//  Copyright © 2018年 zltx. All rights reserved.
//

import Foundation
///质量保证协议
class AgreementViewController:BaseViewController,UIWebViewDelegate{
    private var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="质量保证协议"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        self.webView = UIWebView.init(frame:self.view.bounds)
        webView.delegate=self
        self.view.addSubview(self.webView)
        let url:Foundation.URL
        url=Foundation.URL.init(string:"\(URL)agreementBack/getQualityAgreement")!
        self.webView.loadRequest(URLRequest.init(url:url))
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showSVProgressHUD("正在加载...", type: HUD.textClear)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.dismissHUD()
    }
}
