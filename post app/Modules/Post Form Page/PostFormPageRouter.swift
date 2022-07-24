//
//  PostFormPageRouter.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import UIKit
import RealmSwift

protocol PostFormPageDelegate {
    func didDisappear()
}

final class PostFormPageRouter: PostFormPageWireFrame {
    
    private unowned let viewController: UIViewController
    private let realm: Realm
    private let delegate: PostFormPageDelegate?
    
    init(
        viewController: UIViewController,
        realm: Realm,
        delegate: PostFormPageDelegate?
    ) {
        self.viewController = viewController
        self.realm = realm
        self.delegate = delegate
    }
        
    static func assembleModule(realm: Realm, session: UserSessionModel, delegate: PostFormPageDelegate?) -> UINavigationController {
        
        let viewController = PostFormPageViewController()
        let interactor = Injection.providePostFormPageInteractor(realm: realm)
        let router = PostFormPageRouter(viewController: viewController, realm: realm, delegate: delegate)
        let presenter = PostFormPagePresenter(
            interactor: interactor,
            router: router)
        
        viewController.presenter = presenter
        viewController.session = session
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
    
    func closePage() {
        viewController.dismiss(animated: true, completion: {
            self.delegate?.didDisappear()
        })
    }
    
}
