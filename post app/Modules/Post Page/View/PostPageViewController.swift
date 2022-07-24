//
//  PostPageViewController.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit
import Combine

public protocol PostPageViewControllerFactory {
    func makePostPageViewController() -> PostPageViewController
}

public class PostPageViewController: NiblessViewController {
        
    var presenter: PresenterPostPageProtocol!
    
    public override func loadView() {
        view = PostPageViewRoot(presenter: self.presenter)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.input?.viewDidLoadTrigger.send(())
        presenter.input?.getPosts.send(())
    }
}

extension PostPageViewController: PostFormPageDelegate {
    func didDisappear() {
        presenter.input?.getPosts.send(())
    }
}
