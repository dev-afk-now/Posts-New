//
//  GridCollectionCell.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 29.12.2021.
//

import UIKit

class GridCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!
    
    func configure(postState: PostCellModel) {
        headlineLabel.text = postState.title
        print(headlineLabel.frame.height)
        likesLabel.text = postState.likes
        timestampLabel.text = Date.dateStringFromTimestamp(postState.timestamp)
    }
}

extension GridCollectionCell: CollectionCellRegistrable,
                          CollectionCellReusable {}
