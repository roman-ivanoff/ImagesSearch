//
//  ImageDetailViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit
import Kingfisher

class ImageDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var customNavbarView: CustomNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lightGrayView: UIView!
    @IBOutlet weak var scrollImageView: UIImageView!
    @IBOutlet weak var finishZoomButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    @IBOutlet weak var shareButton: ShareButton!
    @IBOutlet weak var downloadButton: SearchButton!
    @IBOutlet weak var apiLicenseLabel: UILabel!
    @IBOutlet weak var noAttributionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var imageFormatLabel: UILabel!
    @IBOutlet weak var zoomButton: UIButton!

    // MARK: - Properties
    let imageModel = ImageModel()
    let cellId = "imageCell"
    private lazy var searchDelegateObject = SearchDelegate { [weak self] searchTerm in
        guard let self else {
            return
        }

        self.sendingTerm(searchTerm: searchTerm)
    }
    var sendingDelegate: SearchTermSendingDelegate?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
//        registerCell(relatedCollectionView, id: cellId)
        relatedCollectionView.registerCustomCell(ImageCollectionViewCell.self)
        relatedCollectionView.delegate = self
        relatedCollectionView.dataSource = self
        relatedCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")

        scrollView.delegate = self

        loadData(id: imageModel.id)
    }

    // MARK: - Custom Methods
    private func loadData(id: String) {
        imageModel.getImage(imageId: id) { [weak self] _ in
            guard let self else {
                return
            }
            self.toggleActivityIndicator(self.imageModel.isLoading)
            self.imageFormatLabel.text = String(
                format: NSLocalizedString("photo_in_format", comment: ""),
                self.imageModel.getImageFormat()
            )

            let url = URL(string: self.imageModel.images[0].largeImageURL)!
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)

            self.detailImage.kf.indicatorType = .activity
            self.detailImage.kf.setImage(
                with: resource,
                options: [
                    .transition(.fade(0.7)),
                    .cacheOriginalImage
                ]
            ) { result in
                switch result {
                case .success:
                    self.zoomButton.isHidden = false
                case .failure:
                    self.zoomButton.isHidden = true
                }
            }

            self.reloadCollectionView()
        } onError: { error in
            self.showErrorAlert(title: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
        }
        toggleActivityIndicator(imageModel.isLoading)
    }

    private func setupViews() {
        setNavBar()
        indicator.startAnimating()
        hideViews()
    }

    private func toggleActivityIndicator(_ isLoading: Bool) {
        isLoading ? indicator.stopAnimating() : indicator.startAnimating()
    }

    private func setNavBar() {
        customNavbarView.backButton.addTarget(self, action: #selector(backToPrevious(_:)), for: .touchUpInside)
        customNavbarView.textField.addTarget(
            searchDelegateObject,
            action: #selector(SearchDelegate.editingChanged(_:)),
            for: .editingChanged
        )
    }

    private func hideViews() {
        relatedCollectionView.isHidden = true
        apiLicenseLabel.isHidden = true
        freeLabel.isHidden = true
        noAttributionLabel.isHidden = true
        shareButton.isHidden = true
        downloadButton.isHidden = true
        detailImage.isHidden = true
        zoomButton.isHidden = true
        imageFormatLabel.isHidden = true
        lightGrayView.isHidden = true
    }

    private func showHiddenViews() {
        relatedCollectionView.isHidden = false
        apiLicenseLabel.isHidden = false
        freeLabel.isHidden = false
        noAttributionLabel.isHidden = false
        shareButton.isHidden = false
        downloadButton.isHidden = false
        detailImage.isHidden = false
//        zoomButton.isHidden = false
        imageFormatLabel.isHidden = false
        lightGrayView.isHidden = false
    }

    private func reloadCollectionView() {
        indicator.stopAnimating()
        relatedCollectionView.reloadData()
        showHiddenViews()
    }

    @objc func backToPrevious(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showErrorAlert(
                title: NSLocalizedString("error", comment: ""),
                message: error.localizedDescription
            )
        } else {
            showErrorAlert(
                title: NSLocalizedString("success", comment: ""),
                message: NSLocalizedString("image_saved", comment: "")
            )
        }
    }

    private func showZoomViews() {
        scrollView.isHidden = false
        scrollImageView.isHidden = false
        finishZoomButton.isHidden = false
    }

    private func hideZoomViews() {
        scrollView.isHidden = true
        scrollImageView.isHidden = true
        finishZoomButton.isHidden = true
    }

    private func sendingTerm(searchTerm: String) {
        sendingDelegate?.sendSearchTerm(searchTerm: searchTerm)
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions
    @IBAction func zoomImageAction(_ sender: UIButton) {
        UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve) { [self] in
            guard let image = self.detailImage.image else {
                return
            }

            self.scrollImageView.image = image
            self.hideViews()
            self.showZoomViews()
        }
    }

    @IBAction func downloadImageAction(_ sender: SearchButton) {
        guard let selectedImage = detailImage.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(
            selectedImage,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction func finishZoomAction(_ sender: UIButton) {
        scrollView.zoomScale = 1
        UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve) { [self] in
            self.hideZoomViews()
            self.showHiddenViews()
            zoomButton.isHidden = false
        }
    }

    @IBAction func shareImageAction(_ sender: ShareButton) {
        guard let imageToShare = detailImage.image else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension ImageDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadData(id: String(imageModel.relatedImages[indexPath.row].id))
    }
}

// MARK: - UICollectionViewDataSource
extension ImageDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageModel.relatedImages.count
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
            imageCell.shareButton.isHidden = true
            let url = URL(string: imageModel.relatedImages[indexPath.row].webformatURL)!
            imageCell.configureCell(url: url, isHideButton: true)
            imageCell.shareButton.isHidden = true
            cell = imageCell
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "headerCell",
                for: indexPath
            )
            guard let headerView = headerView as? HeaderView else {
                return headerView
            }
            headerView.relatedLabel.text = NSLocalizedString("related", comment: "")

            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImageDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 2, height: 129)
    }
}

// MARK: - UIScrollViewDelegate
extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            guard let image = scrollImageView.image else {
                return
            }

            let ratioW = scrollImageView.frame.width / image.size.width
            let ratioH = scrollImageView.frame.height / image.size.height
            let ratio = ratioW < ratioH ? ratioW : ratioH

            let newWidth = image.size.width * ratio
            let newHeight = image.size.height * ratio

            let conditionLeft = newWidth * scrollView.zoomScale > scrollImageView.frame.width
            let left = 0.5 * (
                conditionLeft ?
                newWidth - scrollImageView.frame.width :
                    scrollView.frame.width - scrollView.contentSize.width
            )

            let conditionTop = newHeight * scrollView.zoomScale > scrollImageView.frame.height
            let top = 0.5 * (
                conditionTop ?
                newHeight - scrollImageView.frame.height :
                    scrollView.frame.height - scrollView.contentSize.height
            )

            scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
        } else {
            scrollView.contentInset = .zero
        }
    }
}
