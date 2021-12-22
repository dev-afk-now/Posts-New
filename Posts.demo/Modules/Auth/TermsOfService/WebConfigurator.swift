//
//  WebConfigurator.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import Foundation
import UIKit

final class WebConfigurator {
    static func create() -> UIViewController {
        let view = WebViewController()
        let router = WebRouterImplementation(context: view)
        let presenter = WebPresenterImplementation(view: view,
                                                              router: router)
        view.presenter = presenter
        return view
    }
}
