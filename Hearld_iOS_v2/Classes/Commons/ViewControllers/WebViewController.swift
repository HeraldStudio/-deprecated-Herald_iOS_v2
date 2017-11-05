//
//  WebViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 05/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    var webView = UIWebView()
    var spinner = UIActivityIndicatorView()
    
    var activeDownloads = 0
    var webUrl: URL? = nil{
        didSet{
            if webView.window != nil{
                loadURL()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addSubview(spinner)
        view.addSubview(webView)
        layoutSubViews()
        
        loadURL()
    }
    
    private func loadURL() {
        if webUrl != nil {
            let request = URLRequest(url: webUrl!)
            spinner.startAnimating()
            webView.loadRequest(request)
        }
    }
    
    private func layoutSubViews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            webView.frame = CGRect(x: 0,
                                   y: navigationController.getHeight(),
                                   width: screenRect.width,
                                   height: screenRect.height - navigationController.getHeight())
            webView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
            webView.scalesPageToFit = true
            webView.delegate = self
            
            spinner.centerX().centerY()
            spinner.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            spinner.hidesWhenStopped = true
            spinner.activityIndicatorViewStyle = .whiteLarge
        }
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activeDownloads += 1
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activeDownloads -= 1
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        return true
//    }
}
