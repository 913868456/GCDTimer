//
//  UIButton+Tools.swift
//  GFExtensions
//
//  Created by 防神 on 2019/11/13.
//  Copyright © 2019 吃面多放葱. All rights reserved.
//

import Foundation
import UIKit

class GFCustomButton: UIButton {
    enum GFAlignment {
        /// 上图下文
        case normal
        /// 左文右图
        case leftRightChange
        /// 默认左图右文
        case `default`
    }
    
    var gfAlignment: GFAlignment = .normal
    
    var padding: CGFloat = 5.0
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        
        let imageRect = super.imageRect(forContentRect: contentRect)
        
        if imageRect == .zero { return rect }
        
        switch gfAlignment {
        case .leftRightChange:
            return CGRect(
                x: (frame.width - rect.width - imageRect.width - padding) * 0.5,
                y: rect.origin.y,
                width: rect.width,
                height: rect.height
            )
        case .normal:
            return CGRect(
                x: 0,
                y: imageRect.maxY - rect.height / 2.0 + padding / 2.0,
                width: contentRect.width,
                height: rect.height
            )
        case .default:
            return CGRect(
                x: (frame.width - rect.width - imageRect.width - padding) * 0.5 + imageRect.width + padding,
                y: rect.origin.y,
                width: rect.width,
                height: rect.height
            )
        }
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        
        let titleRect = self.titleRect(forContentRect: contentRect)
        
        switch gfAlignment {
        case .leftRightChange:
            return CGRect(
                x: (frame.width - rect.width - titleRect.width - padding) * 0.5 + titleRect.width + padding,
                y: rect.origin.y,
                width: rect.width,
                height: rect.height
            )
        case .normal:
            return CGRect(
                x: (contentRect.width - rect.width) / 2.0,
                y: (contentRect.height - titleRect.height - rect.height - padding) / 2.0,
                width: rect.width,
                height: rect.height
            )
        case .default:
            return CGRect(
                x: (frame.width - rect.width - titleRect.width - padding) * 0.5,
                y: rect.origin.y,
                width: rect.width,
                height: rect.height
            )
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        if let image = imageView?.image {
            var labelHeight: CGFloat = 0.0
            
            if let size = titleLabel?.sizeThatFits(CGSize(width: contentRect(forBounds: bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
                labelHeight = size.height
            }
            
            return CGSize(width: size.width + padding, height: image.size.height + labelHeight + padding)
        }
        
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerTitleLabel()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centerTitleLabel()
        setupUI()
    }
    
    private func centerTitleLabel() {
        titleLabel?.textAlignment = .center
    }
    
    func setupUI() {}
}

