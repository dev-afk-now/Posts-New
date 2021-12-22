//
//  DequeueCell.swift
//  Posts.demo
//
//  Created by devmac on 21.12.2021.
//

import UIKit

extension UICollectionView {
    func dequeueCollectionViewCell(for indexPath: IndexPath) -> CollectionViewCell? {
        return self.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionViewCell.self),
            for: indexPath) as? CollectionViewCell
    }
}

extension UITableView {
    func dequeueTableViewCell(for indexPath: IndexPath) -> TableViewCell? {
        return self.dequeueReusableCell(
            withIdentifier: String(describing: TableViewCell.self),
            for: indexPath) as? TableViewCell
    }
}
