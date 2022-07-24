//
//  NiblessViewController.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit

open class NiblessViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable,
                message: "Load viewcontroller using nib is unsupported")
    public override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
    
    @available(*, unavailable,
                message: "Load viewcontroller using nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Load viewcontroller using nib is unsupported")
    }
}

