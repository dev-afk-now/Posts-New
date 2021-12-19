//
//  TableViewCell.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func compressDescriptionLabel(_ cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var showFullPreviewButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    private var buttonTitleIfExpanded = "Скрыть"
    private var buttonTitleIfNotExpanded = "Показать полностью"
    
    weak var delegate: TableViewCellDelegate?
    
    @IBAction func expandDescriptionLabel(_ sender: UIButton) {
        delegate?.compressDescriptionLabel(self)
    }
    
    func configure(postState: PostCellModel) {
        self.headlineLabel.text = postState.title
        self.descriptionLabel.text = postState.text
        self.likesLabel.text = postState.likes
        self.timestampLabel.text = Date.dateStringFromTimestamp(postState.timestamp)
        self.descriptionLabel.numberOfLines = postState.isShowingFullPreview ? 0 : 2
        self.showFullPreviewButton.setTitle(postState.isShowingFullPreview ? buttonTitleIfExpanded : buttonTitleIfNotExpanded , for: .normal)
    }
}
