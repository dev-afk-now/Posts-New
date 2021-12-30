//
//  CollectionViewCell.swift
//  Posts.demo
//
//  Created by devmac on 08.12.2021.
//

import UIKit

protocol CollectionCellDelegate: AnyObject {
    func compressDescriptionLabel(_ cell: CollectionCell)
}

class CollectionCell: FullWidthCollectionViewCell,
                      CollectionCellRegistrable,
                      CollectionCellReusable {
    
    weak var delegate: CollectionCellDelegate?
    
    // MARK: - Private properties -
    
    private let buttonTitleIfExpanded = "Скрыть"
    private let buttonTitleIfNotExpanded = "Показать полностью"

    private let collapsedStateNumberOfLines = 2
    
    private lazy var headlineLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = .applicatonFont(.bold, size: 20)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.font = .applicatonFont()
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var showFullPreviewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .applicatonFont(size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addAction(UIAction(handler: { _ in
            self.showFullDescription()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private func showFullDescription() {
        self.delegate?.compressDescriptionLabel(self)
    }
    
    private lazy var heartImageView: UIImageView = {
        let image = UIImage(systemName: "heart.fill")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    private lazy var likesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.font = .applicatonFont(.bold, size: 12)
        $0.text = "Description"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var timestampLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.font = .applicatonFont(size: 12)
        $0.text = "Description"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var footerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods -
    
    func configure(postState: PostCellModel) {
        headlineLabel.text = postState.title
        descriptionLabel.text = postState.text
        likesLabel.text = postState.likes
        timestampLabel.text = Date.dateStringFromTimestamp(postState.timestamp)
        descriptionLabel.numberOfLines = postState.isShowingFullPreview ? 0 : collapsedStateNumberOfLines
        showFullPreviewButton.setTitle(postState.isShowingFullPreview ?
                                            buttonTitleIfExpanded : buttonTitleIfNotExpanded,
                                            for: .normal)
    }
    
    // MARK: - Private functions -
    
    private func initialSetup() {
        layoutContainerView()
        arrangeContainerViewSubviews()
        setupSuperViewBackground()
        setupSubviewsConstraints()
    }
    
    private func setupSuperViewBackground() {
        contentView.backgroundColor = .clear
    }
    
    private func arrangeContainerViewSubviews() {
        containerView.addSubview(headlineLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(footerContainer)
        containerView.addSubview(showFullPreviewButton)
    }
    
    private func layoutContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        containerView.clipsToBounds = true
    }
    
    private func setupFooterContainerSubviews() {
        let verticalInset: CGFloat = 2
        let horizontalSpacing: CGFloat = 21
        footerContainer.addSubview(heartImageView)
        footerContainer.addSubview(likesLabel)
        footerContainer.addSubview(timestampLabel)
        NSLayoutConstraint.activate([
            heartImageView.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor),
            heartImageView.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: verticalInset),
            heartImageView.bottomAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: -verticalInset),
            heartImageView.widthAnchor.constraint(equalToConstant: 20),
            heartImageView.heightAnchor.constraint(equalToConstant: 20),
            
            likesLabel.leadingAnchor.constraint(equalTo: heartImageView.trailingAnchor, constant: horizontalSpacing / 2),
            likesLabel.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: verticalInset),
            likesLabel.bottomAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: -verticalInset),
            
            
            timestampLabel.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor, constant: -horizontalSpacing),
            timestampLabel.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: verticalInset),
            timestampLabel.bottomAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: -verticalInset),
            timestampLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupSubviewsConstraints() {
        let horizontalSpacing: CGFloat = 32
        let verticalInset: CGFloat = 16
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalSpacing),
            headlineLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalSpacing),
            headlineLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: verticalInset),
            headlineLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -verticalInset),

            descriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: verticalInset),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: footerContainer.topAnchor, constant: -verticalInset),
            
            footerContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalSpacing),
            footerContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalSpacing),
            footerContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: verticalInset),
            footerContainer.bottomAnchor.constraint(equalTo: showFullPreviewButton.topAnchor, constant: -verticalInset),
            
            showFullPreviewButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            showFullPreviewButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            showFullPreviewButton.topAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: verticalInset),
            showFullPreviewButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            showFullPreviewButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        setupFooterContainerSubviews()
    }
}
