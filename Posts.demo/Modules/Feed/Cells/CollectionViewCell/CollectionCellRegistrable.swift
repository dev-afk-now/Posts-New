//
//  CollectionCellRegistrable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellRegistrable: UICollectionViewCell {}

extension CollectionCellRegistrable {
    static func register(in collection: UICollectionView) {
        collection.register(self,
                           forCellWithReuseIdentifier: String(describing: self))
    }
    
    static func registerNib(in collection: UICollectionView) {
        collection.register(UINib(nibName: String(describing: self),
                                 bundle: .main),
                           forCellWithReuseIdentifier: String(describing: self))
    }
}
