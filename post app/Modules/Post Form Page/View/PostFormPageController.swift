//
//  PostFormPageController.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import UIKit
import Combine

public class PostFormPageViewController: NiblessViewController {
    
    var presenter: PresenterPostFormPageProtocol!
    var session: UserSessionModel?
    
    private lazy var formViewRoot: PostFormPageViewRoot = {
        return PostFormPageViewRoot(
            presenter: self.presenter,
            imagePicketHelper: self,
            alertHelper: self,
            creator: self.session?.user ?? UserModel()
        )
    }()
    
    public override func loadView() {
        view = formViewRoot
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add new post"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(dismissForm(_:)))
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: "Post",
                style: .done,
                target: formViewRoot,
                action: #selector(PostFormPageViewRoot.done(_:))),
            
            UIBarButtonItem(barButtonSystemItem: .camera, target: formViewRoot, action: #selector(PostFormPageViewRoot.tapAddPhotoButton(_:)))
        ]
    }
    
    @objc
    private func dismissForm(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension PostFormPageViewController: ImagePicketHelperProtocol, AlertHelperProtocol {
    // MARK: - Alert Helper Methods
    public func showAlert(with alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    // MARK: - Image Picker Helper Methods
    public func takeFromCamera(with picker: UIImagePickerController) {
        present(picker, animated: true)
    }
    
    public func takeFromLibrary(with picket: UIImagePickerController) {
        present(picket, animated: true)
    }
    
    public func dismiss() {
        dismiss(animated: true)
    }
}


