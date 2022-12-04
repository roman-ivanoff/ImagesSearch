//
//  ImagesListViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit
import Kingfisher

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

        imageModel.getImages(searchTerm: searchQuery, imageType: imageType) { [weak self] result in
            guard let self else {
                return
            }
            self.imageCountLabel.text = "\(self.imageModel.hits) Free Images"
            self.reloadCollectionView()
//            print(result)
        } onError: { error in
            self.showErrorAlert(title: NSLocalizedString("error", comment: ""), message: error.localizedDescription)
        }
    }

    // MARK: - Custom Methods
    private func setupViews() {
        hideViews()
        indicator.startAnimating()
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
}

extension ImagesListViewController: UICollectionViewDelegate {

}

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
            let url = URL(string: imageModel.images[indexPath.row].webformatURL)!

            imageCell.imageView.kf.indicatorType = .activity
            imageCell.imageView.kf.setImage(with: url, options: [
                .processor(RoundCornerImageProcessor(cornerRadius: 5)),
                .processor(DownsamplingImageProcessor(size: imageCell.imageView.bounds.size)),
                .transition(.fade(0.7)),
                .cacheOriginalImage]
            )

            cell = imageCell
        }

        return cell
    }
}

extension ImagesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 386, height: 217)
    }
}
