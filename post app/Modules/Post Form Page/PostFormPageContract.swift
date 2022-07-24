//
//  PostFormPageContract.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Combine
import UIKit
import RealmSwift

protocol PresenterToViewPostFormPageProtocol: AnyObject {
    var postToAdd: CurrentValueSubject<PostModel?, Error> { get }
}

protocol PresenterPostFormPageProtocol {
    var input: ViewToPresenterPostFormPageProtocol? { get }
    var output: PresenterToViewPostFormPageProtocol? { get }
}

public protocol PresenterToInteractorPostFormPageProtocol: AnyObject {
    func addPost(with data: PostModel) -> AnyPublisher<Bool, Error>
}

protocol ViewToPresenterPostFormPageProtocol: AnyObject {
    var tapSaveButton: PassthroughSubject<PostModel, Never> { get }
}

protocol PostFormPageWireFrame: AnyObject {
    static func assembleModule(
        realm: Realm,
        session: UserSessionModel,
        delegate: PostFormPageDelegate?
    ) -> UINavigationController
    func closePage()
}
