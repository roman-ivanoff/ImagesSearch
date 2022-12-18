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
    @IBOutlet weak var customNavbarView: CustomNavBar!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    let imageModel = ImageListModel()
    let cellId = "imageCell"
    private lazy var searchDelegateObject = SearchDelegate { [weak self] searchTerm in
        self?.fetchNewImages(searchTerm: searchTerm)
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
//        registerCell(collectionView, id: cellId)
        collectionView.registerCustomCell(ImageCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self

        fetchImages()
    }

    // MARK: - Custom Methods
    private func setupViews() {
        setNavBar()
        hideViews()
        indicator.startAnimating()
    }

    private func setNavBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        customNavbarView.textField.addTarget(
            searchDelegateObject,
            action: #selector(SearchDelegate.editingChanged(_:)),
            for: .editingChanged
        )
        customNavbarView.backButton.addTarget(self, action: #selector(backToMain(_:)), for: .touchUpInside)
    }

    private func fetchImages() {
        imageModel.getImages(
            searchTerm: imageModel.searchTerm,
            imageType: imageModel.imageType,
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

//    private func registerCell(_ collectionView: UICollectionView, id: String) {
//        collectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: id)
//    }

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

    private func fetchNewImages(searchTerm: String) {
        imageModel.images = []
        imageModel.page = 1

        hideViews()
        indicator.startAnimating()

        imageModel.getImages(
            searchTerm: searchTerm,
            imageType: .photo,
            page: String(imageModel.page),
            perPage: String(imageModel.perPage)
        ) { [weak self] _ in
            guard let self else {
                return
            }

            self.imageModel.searchTerm = searchTerm
            self.reloadCollectionView()
        } onError: { error in
            self.showErrorAlert(title: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
        }

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
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ImageDetail", bundle: nil)
        let imageDetailVC = storyboard
            .instantiateViewController(withIdentifier: "imageDetail") as! ImageDetailViewController
        let image = imageModel.images[indexPath.row]
        imageDetailVC.imageModel.id = String(image.id)
        imageDetailVC.imageModel.relatedImages = imageModel.getRelatedImages(image: image, images: imageModel.images)
        imageDetailVC.sendingDelegate = self
        self.navigationController?.pushViewController(imageDetailVC, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == imageModel.images.count - 1  && imageModel.canLoadImages() {
            imageModel.page += 1
            imageModel.getImages(
                searchTerm: imageModel.searchTerm,
                imageType: imageModel.imageType,
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
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ImageCollectionViewCell {
            imageCell.shareButton.tag = indexPath.row
            let url = URL(string: imageModel.images[indexPath.row].webformatURL)!
            imageCell.configureCell(url: url, isHideButton: false)
            imageCell.shareButton.addTarget(
                self,
                action: #selector(self.shareImage(_:)),
                for: .touchUpInside
            )
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

// MARK: - SearchTermSendingDelegate
extension ImagesListViewController: SearchTermSendingDelegate {
    func sendSearchTerm(searchTerm: String) {
        fetchNewImages(searchTerm: searchTerm)
    }
}
