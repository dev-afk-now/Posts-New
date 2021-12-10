//
//  CollectionCollectionViewCell.swift
//  Posts.demo
//
//  Created by devmac on 08.12.2021.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func compressDescriptionLabel(_ cell: CollectionViewCell)
}

class CollectionViewCell: FullWidthCollectionViewCell {
    
    private let horizontalSpacing: CGFloat = 32
    private let verticalInset: CGFloat = 16
    
    private var buttonTitleIfExpanded = "Скрыть"
    private var buttonTitleIfNotExpanded = "Показать полностью"
    
    weak var delegate: CollectionViewCellDelegate?
    
    private lazy var headlineLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Helvetica Neue", size: 20)
        $0.text = "Главная"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Helvetica Neue", size: 20)
        $0.text = "Description"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var showFullPreviewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать полностью", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .black
        button.addAction(UIAction(handler: { _ in
            self.showFullDescription()
        }), for: .touchUpInside)
        return button
    }()
    
    private func showFullDescription() {
        self.delegate?.compressDescriptionLabel(self)
    }
    
    private lazy var heartImageView: UIImageView = {
        let image = UIImage(systemName: "heart.fill")
        let view = UIImageView(image: image)
        view.frame.size = CGSize(width: 12, height: 12)
        return view
    }()
    
    private lazy var likesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Helvetica Neue", size: 20)
        $0.text = "Description"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCellConstraints()
    }
    
    func configure(postState: PostCellModel) {
        self.headlineLabel.text = postState.title
        self.descriptionLabel.text = postState.text
        self.likesLabel.text = postState.likes
  //      self.timestampLabel.text = Date.stringFromInt(timestamp: postState.timestamp)
        self.descriptionLabel.numberOfLines = postState.isShowingFullPreview ? 0 : 2
        self.showFullPreviewButton.setTitle(postState.isShowingFullPreview ? buttonTitleIfExpanded : buttonTitleIfNotExpanded , for: .normal)
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(headlineLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(showFullPreviewButton)
    }
    
    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalSpacing),
            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalSpacing),
            headlineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalInset),
            headlineLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -verticalInset),

            descriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: verticalInset),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: showFullPreviewButton.topAnchor, constant: -verticalInset),
            
            showFullPreviewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showFullPreviewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            showFullPreviewButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: verticalInset),
            showFullPreviewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalInset),
            showFullPreviewButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
//    override func systemLayoutSizeFitting(
//        _ targetSize: CGSize,
//        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
//        verticalFittingPriority: UILayoutPriority) -> CGSize {
//
//        // Replace the height in the target size to
//        // allow the cell to flexibly compute its height
//        var targetSize = targetSize
//        targetSize.height = CGFloat.greatestFiniteMagnitude
//
//        // The .required horizontal fitting priority means
//        // the desired cell width (targetSize.width) will be
//        // preserved. However, the vertical fitting priority is
//        // .fittingSizeLevel meaning the cell will find the
//        // height that best fits the content
//        let size = super.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel
//        )
//
//        return size
//    }
    
}
