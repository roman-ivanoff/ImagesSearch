//
//  UIButton+Configuration.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

extension UIButton {
    func alignmentImageRight() {
        semanticContentAttribute = .forceRightToLeft
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }

    func drawBorder(edges: [UIRectEdge], borderWidth: CGFloat, color: UIColor, margin: CGFloat) {
            for item in edges {
                let borderLayer: CALayer = CALayer()
                borderLayer.borderColor = color.cgColor
                borderLayer.borderWidth = borderWidth
                switch item {
                case .top:
                    borderLayer.frame = CGRect(x: margin, y: 0, width: frame.width - (margin*2), height: borderWidth)
                case .left:
                    borderLayer.frame =  CGRect(
                        x: 0,
                        y: margin,
                        width: borderWidth,
                        height: frame.height - (margin * 2)
                    )
                case .bottom:
                    borderLayer.frame = CGRect(
                        x: margin,
                        y: frame.height - borderWidth,
                        width: frame.width - (margin * 2),
                        height: borderWidth
                    )
                case .right:
                    borderLayer.frame = CGRect(
                        x: frame.width - borderWidth,
                        y: margin,
                        width: borderWidth,
                        height: frame.height - (margin * 2)
                    )
                case .all:
                    drawBorder(
                        edges: [.top, .left, .bottom, .right],
                        borderWidth: borderWidth,
                        color: color,
                        margin: margin
                    )
                default:
                    break
                }
                self.layer.addSublayer(borderLayer)
            }
        }
}
