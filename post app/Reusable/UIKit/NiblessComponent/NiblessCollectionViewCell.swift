//
//  NiblessCollectionViewCell.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit

open class NiblessCollectionViewCell: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable,
                message: "Load collection view using nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Load collection view using nib is unsupported")
    }
    
}
