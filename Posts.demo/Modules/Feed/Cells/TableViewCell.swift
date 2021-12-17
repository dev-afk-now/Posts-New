//
//  TableViewCell.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit

protocol TableViewCellProtocol: AnyObject {
    func compressDescriptionLabel(_ cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var showFullPreviewButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    private var buttonTitleIfExpanded = "Скрыть"
    private var buttonTitleIfNotExpanded = "Показать полностью"
    
    weak var delegate: TableViewCellProtocol?
    
    @IBAction func expandDescriptionLabel(_ sender: UIButton) {
        delegate?.compressDescriptionLabel(self)
    }
    
    func configure(postState: PostCellModel) {
        self.titleLabel.text = postState.title
        self.descriptionLabel.text = postState.text
        self.likesCountLabel.text = postState.likes
        self.timestampLabel.text = Date.stringFromInt(timestamp: postState.timestamp)
        self.descriptionLabel.numberOfLines = postState.isShowingFullPreview ? 0 : 2
        self.showFullPreviewButton.setTitle(postState.isShowingFullPreview ? buttonTitleIfExpanded : buttonTitleIfNotExpanded , for: .normal)
    }
}
