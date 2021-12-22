//
//  DequeueCell.swift
//  Posts.demo
//
//  Created by devmac on 21.12.2021.
//

import UIKit

extension UICollectionView {
    func dequeueCollectionViewCell(for indexPath: IndexPath) -> CollectionCell? {
        return self.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionCell.self),
            for: indexPath) as? CollectionCell
    }
}

extension UITableView {
    func dequeuePostCell(for indexPath: IndexPath) -> PostCell? {
        return self.dequeueReusableCell(
            withIdentifier: String(describing: PostCell.self),
            for: indexPath) as? PostCell
    }
}
