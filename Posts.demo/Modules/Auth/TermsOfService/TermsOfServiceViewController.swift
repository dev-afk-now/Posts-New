//
//  TermsOfService.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit
import WebKit

protocol TermsOfServiceViewControllerEntity: AnyObject {}

class TermsOfServiceViewController: UIViewController {
    
    var presenter: TermsOfServicePresenter!
    
    // MARK: - Private variables -
    
    private var termsOfServiceUrl = "https://google.com"
    
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
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        loadPage(urlString: termsOfServiceUrl)
        setupNavigationBar()
    }
    
    // MARK: - Private funcs -
    
    private func loadPage(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc private func backButtonClicked() {
        presenter.backButtonClicked()
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
}

extension TermsOfServiceViewController: WKUIDelegate {}

extension TermsOfServiceViewController: TermsOfServiceViewControllerEntity {}
