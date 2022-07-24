//
//  RootRouter.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit
import RealmSwift

protocol RootWireFrame: AnyObject {
    func showRootScreen()
}

final class RootRouter: RootWireFrame {
    private let window: UIWindow
    private let realm: Realm
    
    public init(
        window: UIWindow,
        realm: Realm
    ) {
        self.realm = realm
        self.window = window
    }
    
    public func showRootScreen() {
        let rootViewController = PostPageRouter.assembleModule(realm: realm)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
