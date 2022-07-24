//
//  NiblessNavigationViewController.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit

open class NiblessNavigationController: UINavigationController {
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    @available(*, unavailable,
                message: "Load navigation controller using nib is unsupported")
    public override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable,
                message: "Load navigation controller using nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Load navigation controller using nib is unsupported")
    }
}

