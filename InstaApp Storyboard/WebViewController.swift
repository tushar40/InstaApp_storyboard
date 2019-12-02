//
//  WebViewController.swift
//  InstaApp Storyboard
//
//  Created by Tushar Gusain on 02/12/19.
//  Copyright © 2019 Hot Cocoa Software. All rights reserved.
//

import Foundation
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var instagramApi: InstagramApi?
    
    var testUserData: InstagramTestUser?
    
    var mainVC: ViewController?

    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instagramApi?.authorizeApp { (url) in
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url!))
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        self.instagramApi?.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            self?.testUserData = instagramTestUser
            self?.dismissViewController()
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func dismissViewController() {

        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.mainVC?.testUserData = self.testUserData!
            }
        }
    }
}
