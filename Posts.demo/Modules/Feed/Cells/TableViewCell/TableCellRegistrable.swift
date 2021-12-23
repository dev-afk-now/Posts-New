//
//  TableCellRegistrable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol TableCellRegistrable: AnyObject {}

extension TableCellRegistrable {
    static func register<T: UITableViewCell>(in tableView: UITableView,
                                             _ : T.Type) {
        tableView.register(T.self,
                           forCellReuseIdentifier: String(describing: T.self))
    }
    
    static func registerNib<T: UITableViewCell>(in tableView: UITableView, _ : T.Type) {
        tableView.register(UINib(nibName: String(describing: T.self),
                                 bundle: .main),
                           forCellReuseIdentifier: String(describing: T.self))
    }
}
