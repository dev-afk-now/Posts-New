//
//  CollectionViewCell.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 19.12.2021.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(of type: T.Type) {
        self.register(type,
                      forCellWithReuseIdentifier: String(describing: T.self))
    }
}
