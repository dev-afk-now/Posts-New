//
//  TermsOfService.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit
import WebKit

protocol WebViewControllerEntity: AnyObject {}

class WebViewController: UIViewController {
    
    var presenter: WebPresenter!
    
    // MARK: - Private properties -
    
    private let termsOfServiceUrl = "https://google.com"
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero,
                                configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        return webView
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        return button
    }()
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        loadPage(urlString: termsOfServiceUrl)
        setupNavigationBar()
    }
    
    // MARK: - Private methods -
    
    private func loadPage(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - Actions -
    
    @objc private func backButtonClicked() {
        presenter.backButtonClicked()
    }
}

extension WebViewController: WKUIDelegate {}

extension WebViewController: WebViewControllerEntity {}
