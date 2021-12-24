//
//  CollectionCellRegistrable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellRegistrable: AnyObject {}

extension CollectionCellRegistrable {
    static func register(in tableView: UICollectionView) {
        tableView.register(self,
                           forCellWithReuseIdentifier: String(describing: self))
    }
    
    static func registerNib(in tableView: UICollectionView) {
        tableView.register(UINib(nibName: String(describing: self),
                                 bundle: .main),
                           forCellWithReuseIdentifier: String(describing: self))
    }
}
