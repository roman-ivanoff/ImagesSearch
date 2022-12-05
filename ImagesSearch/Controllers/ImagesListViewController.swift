//
//  ImagesListViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit
import Kingfisher

// swiftlint:disable: force_cast
class ImagesListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    var searchQuery: String!
    var imageType: ImageType!
    let imageModel = ImageListModel()
    let cellId = "imageCell"

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        registerCell(collectionView, "ImageCollectionViewCell", id: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self

        imageModel.getImages(
            searchTerm: searchQuery,
            imageType: imageType,
            page: String(imageModel.page),
            perPage: String(imageModel.perPage)
        ) { [weak self] _ in
            guard let self else {
                return
            }
            self.imageCountLabel.text = "\(self.imageModel.hits) Free Images"
            self.reloadCollectionView()
        } onError: { error in
            self.showErrorAlert(title: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
        }
    }

    // MARK: - Custom Methods
    private func setupViews() {
        setNavBar()
        hideViews()
        indicator.startAnimating()
    }

    private func setNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.red
//        let height: CGFloat = 24
//        let bounds = self.navigationController!.navigationBar.bounds
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        let height: CGFloat = 50
        print(self.navigationController!.navigationBar.bounds.height)
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        print(self.navigationController!.navigationBar.bounds.height)

        navigationItem.setHidesBackButton(true, animated: false)

        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        backButton.backgroundColor = UIColor(named: "violetColor")
        backButton.setImage(UIImage(named: "p"), for: .normal)
        backButton.addTarget(self, action: #selector(backToMain(_:)), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem

        let settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        settingsButton.layer.borderColor = UIColor(named: "textFieldColor")?.cgColor
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.cornerRadius = 5
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        let rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
//        rightBarButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
//        rightBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 52).isActive = true
//        rightBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 52).isActive = true
        navigationItem.rightBarButtonItem?.customView?.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem?.customView?.heightAnchor.constraint(equalToConstant: 52).isActive = true
        navigationItem.rightBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 52).isActive = true
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func reloadCollectionView() {
        indicator.stopAnimating()
        collectionView.reloadData()
        showHiddenViews()
    }

    private func hideViews() {
        collectionView.isHidden = true
    }

    private func showHiddenViews() {
        collectionView.isHidden = false
    }

    private func registerCell(_ collectionView: UICollectionView, _ nibName: String, id: String) {
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: id)
    }

    private func showErrorAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel)
        dialogMessage.addAction(okAction)
        present(dialogMessage, animated: true)
    }

    @objc func shareImage(_ sender: UIButton) {
        let cell = collectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! ImageCollectionViewCell
        let imageToShare = [cell.imageView.image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    @objc func backToMain(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension ImagesListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == imageModel.images.count - 1  && imageModel.canLoadImages() {
            imageModel.page += 1
            imageModel.getImages(
                searchTerm: searchQuery,
                imageType: imageType,
                page: String(imageModel.page),
                perPage: String(imageModel.perPage)
            ) { [weak self] _ in
                guard let self else {
                    return
                }
                collectionView.performBatchUpdates {
                    collectionView
                        .insertItems(
                            at: Array(
                                self.imageModel.images.count - self.imageModel.perPage ..< self.imageModel.images.count
                            ).map { IndexPath(item: $0, section: 0) }
                        )
                }
            } onError: { _ in
                self.showErrorAlert(
                    title: NSLocalizedString("error", comment: ""),
                    message: NSLocalizedString("cannot_load_images", comment: "")
                )
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ImagesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageModel.images.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if let imageCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath
        ) as? ImageCollectionViewCell {
            imageCell.shareButton.tag = indexPath.row
            let url = URL(string: imageModel.images[indexPath.row].webformatURL)!
            let resource = ImageResource(downloadURL: url, cacheKey: imageModel.images[indexPath.row].webformatURL)

            imageCell.imageView.kf.indicatorType = .activity
            imageCell.imageView.kf.setImage(
                with: resource,
                options: [
                    .processor(RoundCornerImageProcessor(cornerRadius: 5)),
                    .processor(DownsamplingImageProcessor(size: imageCell.imageView.bounds.size)),
                    .transition(.fade(0.7)),
                    .cacheOriginalImage
                ]
            ) { result in
                    switch result {
                    case .success:
                        imageCell.shareButton.isHidden = false
                        imageCell.shareButton.addTarget(
                            self,
                            action: #selector(self.shareImage(_:)),
                            for: .touchUpInside
                        )
                    case .failure:
                        imageCell.shareButton.isHidden = true
                    }
                }

            imageCell.imageView.contentMode = .scaleAspectFill
            cell = imageCell
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var size: CGSize
        let height: CGFloat = 217
        let orientation = UIApplication.shared.statusBarOrientation

        if orientation == .landscapeLeft || orientation == .landscapeRight {
            size = CGSize(width: (collectionView.frame.width - 20) / 2, height: height)
        } else {
            size = CGSize(width: collectionView.frame.width, height: height)
        }

        return size
    }
}
