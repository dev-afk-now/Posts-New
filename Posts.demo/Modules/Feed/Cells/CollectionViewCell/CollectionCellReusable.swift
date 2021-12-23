//
//  CollectionCellReusable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellReusable: AnyObject {}

extension CollectionCellReusable {
    static func cell<T: UICollectionViewCell>(in tableView: UICollectionView,
                                              for indexPath: IndexPath,
                                              _ : T.Type) -> T? {
        return tableView.dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                             for: indexPath) as? T
    }
}
