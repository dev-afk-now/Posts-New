//
//  ViewItem.swift
//  Posts.demo
//
//  Created by devmac on 21.12.2021.
//

import Foundation

protocol ViewItem {}
struct TitleItem: ViewItem {
    let title: String
}
struct TextItem: ViewItem {
    let text: String
}
struct ImageItem: ViewItem {
    let image: URL?
}
struct DetailItem: ViewItem {
    let likes: Int
    let date: Date
}
