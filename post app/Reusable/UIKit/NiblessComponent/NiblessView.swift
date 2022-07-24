//
//  NiblessView.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit

open class NiblessView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable,
                message: "Load view using nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Load view using nib is unsupported")
    }
}
