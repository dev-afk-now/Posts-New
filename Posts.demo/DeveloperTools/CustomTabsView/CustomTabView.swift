//
//  CustomBarView.swift
//  CustomMenuBar
//
//  Created by devmac on 05.01.2022.
//

import UIKit

protocol CustomTabViewDelegate: AnyObject {
    func tabItemSelected(_ item: String)
}

class CustomTabView: UIView {
    
    // MARK: - Private properties -
    
    weak var delegate: CustomTabViewDelegate?
    private var items = [String]()
    private var itemSize: CGSize = .zero
    private var selectedItemIndex: Int = 0 {
        didSet(newValue) {
            delegate?.tabItemSelected(items[newValue])
            setSelectionIndicatorPosition()
        }
    }
    private let selectionIndicatorHeight: CGFloat = 2
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(
            width: itemSize.width,
            height: itemSize.height
        )
        flowLayout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TabBarCollectionCell.self,
                      forCellWithReuseIdentifier: "TabBarCell")
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var selectionIndicatorBar: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private var selectionIndicator: UIView!
    
    // MARK: - Init -
    
    init(items: [String], in itemSize: CGSize) {
        super.init(frame: .zero)
        self.items = items
        self.itemSize = itemSize
        layoutContainerView()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setSelectionIndicatorPosition()
    }
    
    // MARK: - Private methods -
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
        containerView.addSubview(selectionIndicatorBar)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            selectionIndicatorBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            selectionIndicatorBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            selectionIndicatorBar.heightAnchor.constraint(equalToConstant: selectionIndicatorHeight),
            selectionIndicatorBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func commonInit() {
        setupSelectionIndicator()
        backgroundColor = .white
    }
    
    private func setupSelectionIndicator() {
        selectionIndicator = UIView(frame: CGRect(x: 0,
                                                  y: collectionView.frame.maxY,
                                                  width: widthForItem(),
                                                  height: selectionIndicatorHeight))
        containerView.addSubview(selectionIndicator)
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicator.backgroundColor = .black
    }
    
    private func widthForItem() -> CGFloat {
        return itemSize.width
    }
    
    private func setSelectionIndicatorPosition() {
        UIView.animate(withDuration: 0.05) { [unowned self] in
            guard selectionIndicator != nil else {
                return
            }
            let layoutAttributes = collectionView.layoutAttributesForItem(at: IndexPath(
                row: selectedItemIndex,
                section: .zero)
            )
            let center = collectionView.convert(layoutAttributes?.center ?? CGPoint(x: 0, y: 0),
                                                to: self)
            
            selectionIndicator.center = CGPoint(x: center.x,
                                                y: collectionView.frame.maxY - selectionIndicatorHeight / 2)
            layoutIfNeeded()
        }
    }
}

// MARK: - CollectionViewDelegate -

extension CustomTabView: UICollectionViewDelegate,
                         UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setSelectionIndicatorPosition()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarCell",
                                                            for: indexPath) as? TabBarCollectionCell else {
            return UICollectionViewCell()
        }
        cell.setTitle(items[indexPath.row])
        cell.switchSelectedState(selectedItemIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TabBarCollectionCell else {
            return
        }
        guard let cellToRemove = collectionView.cellForItem(at: IndexPath(
            row: selectedItemIndex,
            section: .zero)) as? TabBarCollectionCell else {
                return
            }
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
        collectionView.performBatchUpdates {
            cellToRemove.switchSelectedState(false)
            cell.switchSelectedState(true)
            selectedItemIndex = indexPath.row
        }
    }
}
