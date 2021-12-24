//
//  CollectionCellReusable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellReusable: UICollectionViewCell {}

extension CollectionCellReusable {
    static func cell(in collection: UICollectionView,
                     for indexPath: IndexPath) -> Self {
        return collection.dequeueReusableCell(withReuseIdentifier: String(describing: self),
                                              for: indexPath) as! Self
    }
}
