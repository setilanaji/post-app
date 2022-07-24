//
//  PostFormPageViewRoot.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import UIKit
import Combine

public protocol ImagePicketHelperProtocol {
    func takeFromCamera(with picker: UIImagePickerController)
    func takeFromLibrary(with picket: UIImagePickerController)
    func dismiss()
}

public protocol AlertHelperProtocol {
    func showAlert(with alert: UIAlertController)
}

public class PostFormPageViewRoot: NiblessView {
    
    var hirearchyNotReady = true
    let presenter: PresenterPostFormPageProtocol
    let imagePicketHelper: ImagePicketHelperProtocol
    let alertHelper: AlertHelperProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var forms: [PostFormSectionType] = [.text(text: ""), .image(image: nil)]
    private var postToAdd: PostModel?
    private var creator: UserModel
    
    private lazy var formTableView: UITableView = {
        let table = UITableView(frame: bounds)
        
        table.dataSource = self
        table.delegate = self
        table.separatorColor = .clear
        table.isUserInteractionEnabled = true
        table.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapTable(_:))))
        table.register(TextForm.self, forCellReuseIdentifier: TextForm.identifier)
        table.register(ImageForm.self, forCellReuseIdentifier: ImageForm.identifier)
        return table
    }()
    
    init(
        frame: CGRect = .zero,
        presenter: PresenterPostFormPageProtocol,
        imagePicketHelper: ImagePicketHelperProtocol,
        alertHelper: AlertHelperProtocol,
        creator: UserModel
    ) {
        self.creator = creator
        self.imagePicketHelper = imagePicketHelper
        self.alertHelper = alertHelper
        self.presenter = presenter
        super.init(frame: frame)
        
        bind()
    }
    
    public override func didMoveToWindow() {
        guard hirearchyNotReady else {
            return
        }
        
        constructHirearchy()
        activateConstraints()
        hirearchyNotReady = false
    }
    
    private func constructHirearchy() {
        [formTableView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            formTableView.topAnchor.constraint(equalTo: topAnchor),
            formTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            formTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            formTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    
    @objc
    func done(_ sender: Any) {
        
        if forms[0].text.isNothing && forms[1].image == nil {
            return
        }
        
        var post: PostModel
        if let temp = postToAdd {
            post = temp
        } else {
            post = PostModel(id: PostModel.nextID(), text: "", image: "", date: "", creator: self.creator)
        }
        
        post.text = forms[0].text
        
        // Save image
        if let image = forms[1].image {
            if !post.hasPhoto {
                post.photoID = PostModel.nextPhotoID()
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: post.photoURL, options: .atomic)
                    post.image = post.photoURL.absoluteString
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
                
        presenter.input?.tapSaveButton.send(post)
    }
}

extension PostFormPageViewRoot: UITableViewDelegate {
    
    @objc
    func onTapTable(_ sender: Any) {
        formTableView.reloadData()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.endEditing(true)
    }
}

extension PostFormPageViewRoot: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return forms.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch forms[indexPath.section] {
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextForm.identifier, for: indexPath) as? TextForm else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .image(let image):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageForm.identifier, for: indexPath) as? ImageForm else {
                return UITableViewCell()
            }
            cell.setImage(with: image)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        
    }
    
    func edit(text: String) {
        forms[0] = .text(text: text)
    }
    
    func show(image: UIImage?) {
        forms[1] = .image(image: image)
        formTableView.reloadData()
    }
    
}

private extension PostFormPageViewRoot {
    func bind() {
        presenter.output?.postToAdd
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { value in
                self.postToAdd = value
            })
            .store(in: &subscriptions)
    }

}

extension PostFormPageViewRoot: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Image Helper Methods
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicketHelper.takeFromCamera(with: imagePicker)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicketHelper.takeFromLibrary(with: imagePicker)
    }
    
    @objc
    func tapAddPhotoButton(_ sender: Any) {
        self.endEditing(true)
        pickPhoto()
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(
            title: "Take Photo",
            style: .default) { _ in
                self.takePhotoWithCamera()
            }
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(
            title: "Choose From Library",
            style: .default) { _ in
                self.choosePhotoFromLibrary()
            }
        alert.addAction(actLibrary)
        alertHelper.showAlert(with: alert)
    }
    
    
    // MARK: - Image Picker Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        imagePicketHelper.dismiss()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicketHelper.dismiss()
    }
}

extension PostModel {
    
    static func nextID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PostID") + 1
        userDefaults.set(currentID, forKey: "PostID")
        return currentID
    }
    
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    static func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        return currentID
    }
    
    var photoURL: URL {
        assert(photoID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
}

extension PostFormPageViewRoot: TextViewCellDelegate {
    func updateCellHeight() {
        formTableView.beginUpdates()
        formTableView.endUpdates()
    }
    
    func updateText(with value: String) {
        edit(text: value)
    }

}

extension PostFormPageViewRoot: ImageViewCellDelegate {
    func removeImage() {
        show(image: nil)
    }
}

