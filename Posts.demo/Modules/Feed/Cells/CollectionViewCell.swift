//
//  CollectionViewCell.swift
//  Posts.demo
//
//  Created by devmac on 08.12.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private func setupSubviews() {
        let label = UILabel()
        label.text = "Label"
        self.addSubview(label)
    }

}
