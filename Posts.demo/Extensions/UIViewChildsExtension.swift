//
//  UIView.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import UIKit

extension UIView {
    func configureBorder(width: CGFloat, with color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    var cornerRadius: CGFloat {
        get {
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

extension UIView {
    func makeGradient(colors: [UIColor]) {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.colors = colors.map {$0.cgColor}
        self.isUserInteractionEnabled = false
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIApplication {
    var newKeyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}

extension UIViewController {
    static func swapCurrentViewController(with newViewController: UIViewController,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.75,
                                   isReversed: Bool = false) {
        
        guard let window = UIApplication.shared.newKeyWindow else {
            return
        }
        // Get a reference to the window's current `rootViewController` (the "old" one)
        let oldViewController = window.rootViewController
        
        if animated, let oldView = oldViewController?.view {
            
            // Replace the window's `rootViewController` with the new one
            window.rootViewController = newViewController
            
            // Add the old view controller's view on top of the new `rootViewController`
            newViewController.view.addSubview(oldView)
            
            // Remove the old view controller's view in an animated fashion
            UIView.transition(with: window,
                              duration: duration,
                              options: isReversed ? .transitionFlipFromLeft : .transitionFlipFromRight,
                              animations: { oldView.removeFromSuperview() },
                              completion: nil)
        } else {
            window.rootViewController = newViewController
        }
    }
}

extension UIViewController {
    func showAlert(with errorMessage: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                               comment: "Default action"),
                                      style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
