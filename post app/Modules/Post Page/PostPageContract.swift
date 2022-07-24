//
//  PostPageContract.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Combine
import UIKit
import RealmSwift

protocol PresenterToViewPostPageProtocol: AnyObject {
    var posts: CurrentValueSubject<[PostModel], Error> { get }
    var usersdummies: CurrentValueSubject<[UserModel], Error> { get }
    var activeUser: CurrentValueSubject<UserSessionModel?, Error> { get }
}

protocol PresenterPostPageProtocol {
    var input: ViewToPresenterPostPageProtocol? { get }
    var output: PresenterToViewPostPageProtocol? { get }
}

public protocol PresenterToInteractorPostPageProtocol: AnyObject {
    func getPosts() -> AnyPublisher<[PostModel], Error>
    func getUsersData() -> AnyPublisher<[UserModel], Error>
    func getUserSession(with users: [UserModel]) -> AnyPublisher<UserSessionModel?, Error>
    func changeUserSession(from session: UserSessionModel?, with user: UserSessionModel) -> AnyPublisher<UserSessionModel, Error>
}

protocol ViewToPresenterPostPageProtocol: AnyObject {
    var getPosts: PassthroughSubject<Void, Never> { get }
    var tapAddButton: PassthroughSubject<Void, Never> { get }
    var tapUserProfile: PassthroughSubject<UserModel, Never> { get }
    var viewDidLoadTrigger: PassthroughSubject<Void, Never> { get }
}

protocol PostPageWireFrame: AnyObject {
    static func assembleModule(realm: Realm) -> UIViewController
    func toPostFormPage(session: UserSessionModel)
}
