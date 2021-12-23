//
//  CollectionCellRegistrable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellRegistrable: AnyObject {}

extension CollectionCellRegistrable {
    static func register<T: UICollectionViewCell>(in tableView: UICollectionView,
                                             _ : T.Type) {
        tableView.register(T.self,
                           forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    static func registerNib<T: UICollectionViewCell>(in tableView: UICollectionView, _: T.Type) {
        tableView.register(UINib(nibName: String(describing: T.self),
                                 bundle: .main),
                           forCellWithReuseIdentifier: String(describing: T.self))
    }
}
