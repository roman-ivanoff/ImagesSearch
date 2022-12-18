//
//  UIView+Configuration.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 18.12.2022.
//

import UIKit

extension UIView {
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "\(type(of: self))", bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }
}
