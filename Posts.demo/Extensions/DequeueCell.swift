//
//  DequeueCell.swift
//  Posts.demo
//
//  Created by devmac on 21.12.2021.
//

import UIKit

extension UICollectionView {
    func dequeueCollectionViewCell(_ identifier: String,
                                   for indexPath: IndexPath) -> CollectionViewCell? {
        return self.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath) as? CollectionViewCell
    }
}

extension UITableView {
    func dequeueTableViewCell(_ identifier: String,
                                   for indexPath: IndexPath) -> TableViewCell? {
        return self.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath) as? TableViewCell
    }
}
