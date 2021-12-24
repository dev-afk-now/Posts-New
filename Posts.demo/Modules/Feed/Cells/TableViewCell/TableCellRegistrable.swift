//
//  TableCellRegistrable.swift
//  Posts.demo
//
//  Created by devmac on 22.12.2021.
//

import UIKit

protocol TableCellRegistrable: UITableViewCell {}

extension TableCellRegistrable {
    static func register(in tableView: UITableView) {
        tableView.register(self,
                           forCellReuseIdentifier: String(describing: self))
    }
    
    static func registerNib(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self),
                                 bundle: .main),
                           forCellReuseIdentifier: String(describing: self))
    }
}
