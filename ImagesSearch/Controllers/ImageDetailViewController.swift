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

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        registerCell(relatedCollectionView, id: cellId)
        relatedCollectionView.delegate = self
        relatedCollectionView.dataSource = self
        relatedCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")

        loadData(id: imageModel.id)
    }

    // MARK: - Custom Methods
    private func loadData(id: String) {
        imageModel.getImage(imageId: id) { [weak self] _ in
            guard let self else {
                return
            }
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

    }

    private func setupViews() {
        indicator.startAnimating()
        hideViews()
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
    }

    private func reloadCollectionView() {
        indicator.stopAnimating()
        relatedCollectionView.reloadData()
        showHiddenViews()
    }

    private func registerCell(_ collectionView: UICollectionView, id: String) {
        collectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: id)
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

    // MARK: - Actions
    @IBAction func zoomImageAction(_ sender: UIButton) {
    }
    
    @IBAction func downloadImageAction(_ sender: SearchButton) {
    }

    @IBAction func shareImageAction(_ sender: ShareButton) {
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
            withReuseIdentifier: cellId,
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
