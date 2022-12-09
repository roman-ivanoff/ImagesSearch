//
//  ImageSearchNavBar.swift
//  
//
//  Created by Roman Ivanov on 09.12.2022.
//

import UIKit

@IBDesignable
class ImageSearchNavBar: UINavigationBar {

    @IBInspectable var customHeight: CGFloat = 68

        override func sizeThatFits(_ size: CGSize) -> CGSize {

            return CGSize(width: UIScreen.main.bounds.width, height: customHeight)

        }

    override func layoutSubviews() {
        super.layoutSubviews()
        let heightDelta: CGFloat = UIScreen.main.nativeBounds.height == 2436 ? 44 : 20

        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("UIBarBackground") {

                subview.frame = CGRect(
                    x: 0,
                    y: -heightDelta,
                    width: self.frame.width,
                    height: customHeight + heightDelta
                )
                subview.backgroundColor = .white
//                subview.sizeToFit()
            }

            if stringFromClass.contains("UINavigationBarContentView") {
                let centerY = (customHeight - subview.frame.height) / 2.0
                subview.frame = CGRect(x: 0, y: centerY, width: self.frame.width, height: 52)
                subview.backgroundColor = .white
//                subview.sizeToFit()
            }
        }
    }
}
