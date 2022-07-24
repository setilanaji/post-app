//
//  PostPageRouter.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit
import RealmSwift

final class PostPageRouter: PostPageWireFrame {
    
    private unowned let viewController: UIViewController
    private let realm: Realm
    
    init(
        viewController: UIViewController,
        realm: Realm
    ) {
        self.viewController = viewController
        self.realm = realm
    }
        
    static func assembleModule(realm: Realm) -> UIViewController {
        
        let viewController = PostPageViewController()
        let interactor = Injection.providePostPageInteractor(realm: realm)
        let router = PostPageRouter(viewController: viewController, realm: realm)
        let presenter = PostPagePresenter(
            interactor: interactor,
            router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
    
    func toPostFormPage(session: UserSessionModel) {
        let postFormPageViewController = PostFormPageRouter.assembleModule(realm: realm, session: session, delegate: viewController as? PostFormPageDelegate)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.present(postFormPageViewController, animated: true)
    }
    
}
