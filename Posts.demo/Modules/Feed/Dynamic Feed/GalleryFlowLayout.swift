//
//  GalleryFlowLayout.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 04.01.2022.
//

import UIKit

final class GalleryFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        let horizontalInset: CGFloat = 16
        let verticalInset: CGFloat = 16
        self.sectionInset = UIEdgeInsets(top: verticalInset,
                                         left: horizontalInset,
                                         bottom: verticalInset,
                                         right: horizontalInset)
        let insetsSum = self.sectionInset.left + self.sectionInset.right
        let widthForItem: CGFloat = UIScreen.main.bounds.width - insetsSum
        self.estimatedItemSize = CGSize(
            width: widthForItem,
            height: 200
        )
        self.minimumLineSpacing = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
