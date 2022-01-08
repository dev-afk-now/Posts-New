//
//  PageMenuCell.swift
//  CustomMenuBar
//
//  Created by devmac on 05.01.2022.
//

import UIKit

class PageMenuCell: BaseCollectionViewCell {
    
    // MARK: - Private properties -
    private var isInSelectedState = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .applicatonFont(.bold, size: 18)
        label.textAlignment = .center
        return label
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
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func switchSelectedState(_ isInSelectedState: Bool) {
        self.isInSelectedState = isInSelectedState
        titleLabel.textColor = isInSelectedState ? .black : .lightGray
    }
    
    // MARK: - Private methods -
    private func setupConstraints() {
        let verticalInset: CGFloat = self.bounds.height / 5
        let horizontalInset: CGFloat = self.bounds.height / 5
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: verticalInset),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                 constant: -horizontalInset),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -verticalInset),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func initialSetup() {
        setupConstraints()
    }
}
