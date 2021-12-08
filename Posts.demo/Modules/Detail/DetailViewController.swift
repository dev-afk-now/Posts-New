//
//  PostDetailViewController.swift
//  Posts.demo
//
//  Created by New Mac on 11.10.2021.
//

import UIKit

protocol DetailViewControllerProtocol: class {
    func updateView(items: [ViewItem])
    func showNoInternetConnectionError()
    func showUnreachableServiceError()
    func showTimeOutConnectionError()
}

class DetailViewController: UIViewController {
    
    var presenter: DetailPresenter!
    
    @IBOutlet private weak var progressView: UIActivityIndicatorView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var failDescriptionLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageStackView: UIStackView!
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = .white
        $0.font = UIFont(name: "Helvetica Neue", size: 20)
        return $0
    } (UILabel())
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBackAction)
        )
        button.tintColor = .white
        return button
    }()
    
    @objc func goBackAction() {
        presenter.navigateToRootViewController()
    }
    
    @IBAction private func updateContentView(_ sender: Any) {
        presenter.viewDidLoad()
        progressView.startAnimating()
        alertView.isHidden = true
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupNavigationBar()
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func showTimeOutConnectionError() {
        setUpViewsForError(text: "The request timed out", alertBackground: .blue)
    }
    
    func showNoInternetConnectionError() {
        setUpViewsForError(text: "No Internet Connection", alertBackground: .lightGray)
    }
    
    func showUnreachableServiceError() {
        setUpViewsForError()
    }
    
    private func setUpViewsForError(text: String = "Something went wrong", alertBackground: UIColor = .red) {
        DispatchQueue.main.async { [unowned self] in
            progressView.stopAnimating()
            alertView.backgroundColor = alertBackground
            failDescriptionLabel.text = text
            alertView.isHidden = false
        }
    }
    
    func updateView(items: [ViewItem]) {
        DispatchQueue.main.async { [unowned self] in
            self.progressView.stopAnimating()
            self.imageStackView?.subviews.forEach { $0.removeFromSuperview() }
            for item in items {
                self.createStackViewSubView(from: item)
            }
        }
    }
    
    private func createStackViewSubView(from item: ViewItem) {
        switch item {
        case is TitleItem:
            let title = item as! TitleItem
            titleLabel.text = title.title
            headlineLabel.text = title.title
        case is TextItem:
            let description = item as! TextItem
            descriptionLabel.text = description.text
        case is ImageItem:
            let imageItem = item as! ImageItem
            let imageView = UIImageView()
            guard let url = imageItem.image else { break }
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { break }
            imageView.image = image
            let aspectRatio = image.size.width / image.size.height
            imageView.heightAnchor.constraint(equalToConstant: (self.view?.frame.size.width)! / aspectRatio).isActive = true
            self.imageStackView?.addArrangedSubview(imageView)
        case is DetailItem:
            let detailItem = item as! DetailItem
            likesLabel.text = String(detailItem.likes)
            dateLabel.text = detailItem.date.toStringShort()
        default:
            break
        }
    }
}


extension Date {
    func toStringShort() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
