//
//  PostPageViewController.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit

public protocol PostPageNavigationControllerFactory {
    func makePostPageNavigationController() -> PostPageNavigationController
}

public class PostPageNavigationController: NiblessNavigationController {
    
    init(
        contentViewController: PostPageViewController
    ) {
        super.init(rootViewController: contentViewController)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
