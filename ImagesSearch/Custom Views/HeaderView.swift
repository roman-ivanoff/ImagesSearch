//
//  HeaderView.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 08.12.2022.
//

import UIKit

class HeaderView: UICollectionReusableView, NIBAble {
    @IBOutlet weak var relatedLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initUIView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initUIView()
    }

    private func initUIView() {
        guard let view = loadViewFromNib() else {
            return
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
