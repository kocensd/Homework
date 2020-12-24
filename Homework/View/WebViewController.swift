//
//  WebViewController.swift
//  Homework
//
//  Created by SangDo on 2020/09/09.
//  Copyright © 2020 SangDo. All rights reserved.

// test3브랜치

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView!
    var naviTitle: String = ""
    var urlStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = checkValid(naviTitle)
        webView = WKWebView(frame: self.view.frame)
        self.view = self.webView
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    deinit {
        print("WebViewControllerDeInit")
    }
}
//회사맥테스트
//test
//test
