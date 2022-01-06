//
//  GridFlowLayout.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 29.12.2021.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        let horizontalInset: CGFloat = 16
        let verticalInset: CGFloat = 16
        let numberOfColumns: CGFloat = 2
        let screenWidth = UIScreen.main.bounds.width
        self.sectionInset = UIEdgeInsets(top: verticalInset,
                                         left: horizontalInset,
                                         bottom: verticalInset,
                                         right: horizontalInset)
        let insetsSum = self.sectionInset.left + self.sectionInset.right
        let widthForItem = (screenWidth / numberOfColumns) - insetsSum
        self.itemSize = CGSize(
            width: widthForItem,
            height: 200
        )
        self.minimumLineSpacing = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
