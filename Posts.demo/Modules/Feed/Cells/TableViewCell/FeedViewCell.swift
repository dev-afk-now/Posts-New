//
//  TableViewCell.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit

protocol FeedViewCellDelegate: AnyObject {
    func compressDescriptionLabel(_ cell: FeedViewCell)
}

class FeedViewCell: UITableViewCell {
    
    weak var delegate: FeedViewCellDelegate?
    
    // MARK: - Outlets -
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var showFullPreviewButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - Private variables -
    
    private var buttonTitleIfExpanded = "Скрыть"
    private var buttonTitleIfNotExpanded = "Показать полностью"
    
    // MARK: - Public methods -
    
    func configure(postState: PostCellModel) {
        self.headlineLabel.text = postState.title
        self.descriptionLabel.text = postState.text
        self.likesLabel.text = postState.likes
        self.timestampLabel.text = Date.stringFromInt(timestamp: postState.timestamp)
        self.descriptionLabel.numberOfLines = postState.isShowingFullPreview ? 0 : 2
        self.showFullPreviewButton.setTitle(postState.isShowingFullPreview ? buttonTitleIfExpanded : buttonTitleIfNotExpanded , for: .normal)
    }
    
    // MARK: - Actions -
    
    @IBAction func expandDescriptionLabel(_ sender: UIButton) {
        delegate?.compressDescriptionLabel(self)
    }
}
