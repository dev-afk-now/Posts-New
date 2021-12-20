//
//  AppFont.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 19.12.2021.
//

import UIKit

extension UIFont {
    static func applicatonFont(_ type: ApplicationFonts = .regular, size: CGFloat = 15) -> UIFont {
        let fontName = type.value
        return UIFont(name: fontName,
                      size: size) ?? UIFont.systemFont(ofSize: size,
                                                       weight: .regular)
    }
}

enum ApplicationFonts {
    case regular
    case bold
    
    var value: String {
        switch self {
        case .bold:
            return "Helvetica Neue Bold"
        default:
            return "Helvetica Neue"
        }
    }
}
