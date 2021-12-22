//
//  CollectionCellRegistrable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol CollectionCellRegistrable: AnyObject {}

extension CollectionCellRegistrable {
    static func register<T: UITableViewCell>(in tableView: UITableView,
                                             _ : T.Type) {
        tableView.register(T.self,
                           forCellReuseIdentifier: String(describing: self))
    }
    
    static func registerNib(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self),
                                 bundle: .main),
                           forCellReuseIdentifier: String(describing: self))
    }
}
