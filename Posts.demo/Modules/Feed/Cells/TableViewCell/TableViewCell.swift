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
    
    // MARK: - Public properties -
    
    weak var delegate: TableViewCellDelegate?
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var showFullPreviewButton: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    
    // MARK: - Private properties -
    
    private let buttonTitleIfExpanded = "Скрыть"
    private let buttonTitleIfNotExpanded = "Показать полностью"
    private let collapsedStateNumberOfLines = 2
    
    
    // MARK: - Life Cycle -
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public methods -
    
    func configure(postState: PostCellModel) {
        self.headlineLabel.text = postState.title
        self.descriptionLabel.text = postState.text
        self.likesLabel.text = postState.likes
        self.timestampLabel.text = Date.stringFromInt(timestamp: postState.timestamp)
        self.descriptionLabel.numberOfLines = postState.isShowingFullPreview ? 0 : collapsedStateNumberOfLines
        self.showFullPreviewButton.setTitle(
            postState.isShowingFullPreview ? buttonTitleIfExpanded : buttonTitleIfNotExpanded,
            for: .normal)
    }
    
    // MARK: - Actions -
    
    @IBAction func expandDescriptionLabel(_ sender: UIButton) {
        delegate?.compressDescriptionLabel(self)
    }
}
