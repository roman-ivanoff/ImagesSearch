//
//  TagCollectionView.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 21.12.2022.
//

import UIKit

class TagCollectionView: UIView {

    @IBOutlet weak var tagCollectionView: UICollectionView!

    private(set) var tags: [String] = []
    var passTagDelegate: PassTagDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initUIView()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initUIView()
        setup()
    }

    private func initUIView() {
        guard let view = loadViewFromNib() else {
            return
        }
        view.frame = self.bounds
        addSubview(view)
    }

    private func setup() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.registerCustomCell(TagCell.self)
        tagCollectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.identifier
        )

        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionFlowLayout.scrollDirection = .horizontal
        tagCollectionView.collectionViewLayout = collectionFlowLayout
    }

    func passTags(tags: [String]) {
        self.tags = tags
        tagCollectionView.reloadData()
    }
}

extension TagCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        passTagDelegate?.passTag(tag: tags[indexPath.row])
    }
}

extension TagCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if let tagCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCell.identifier,
            for: indexPath
        ) as? TagCell {
            tagCell.tagLabel.text = tags[indexPath.row]

            cell = tagCell
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
                withReuseIdentifier: HeaderView.identifier,
                for: indexPath
            )
            guard let headerView = headerView as? HeaderView else {
                return headerView
            }
            headerView.relatedLabel.text = NSLocalizedString("related", comment: "")
            headerView.relatedLabel.textColor = UIColor(named: "textFieldFontColor")
            headerView.relatedLabel.font = UIFont(name: "OpenSans-Regular", size: 14)

            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
            return CGSize(width: 60, height: 26)
    }
}

extension TagCollectionView: UICollectionViewDelegateFlowLayout {
}
