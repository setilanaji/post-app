//
//  PostPageInteractor.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import Combine

public class PostPageInteractor<
    GetPosts: Repository,
    GetUsersData: Repository,
    UpdateUsersData: Repository,
    GetUserSession: Repository,
    SaveUserSession: Repository,
    DeleteUserSession: Repository
>: PresenterToInteractorPostPageProtocol
where
GetPosts.Request == [String: Any],
GetPosts.Response == [PostModel],
GetUsersData.Request == String,
GetUsersData.Response == [UserModel],
UpdateUsersData.Request == ([UserModel], String),
UpdateUsersData.Response == [UserModel],
GetUserSession.Request == Any?,
GetUserSession.Response == UserSessionModel?,
SaveUserSession.Request == UserSessionModel,
SaveUserSession.Response == UserSessionModel,
DeleteUserSession.Request == UserSessionModel,
DeleteUserSession.Response == UserSessionModel
{
    
    private let getPostsRepository: GetPosts
    private let getUsersDataRepository: GetUsersData
    private let updateUsersDataRepository: UpdateUsersData
    private let getUserSessionRepository: GetUserSession
    private let saveUserSessionRepository: SaveUserSession
    private let deleteUserSessionRepository: DeleteUserSession
    
    private let backgroundQueque = DispatchQueue(label: "PostPageQueque", qos: .background)
    
    required init(
        getPostsRepository: GetPosts,
        getUsersDataRepository: GetUsersData,
        updateUsersDataRepository: UpdateUsersData,
        getUserSessionRepository: GetUserSession,
        saveUserSessionRepository: SaveUserSession,
        deleteUserSessionRepository: DeleteUserSession
    ) {
        self.getPostsRepository = getPostsRepository
        self.getUsersDataRepository = getUsersDataRepository
        self.updateUsersDataRepository = updateUsersDataRepository
        self.getUserSessionRepository = getUserSessionRepository
        self.saveUserSessionRepository = saveUserSessionRepository
        self.deleteUserSessionRepository = deleteUserSessionRepository
    }
    
    public func getPosts() -> AnyPublisher<[PostModel], Error> {
        return self.getPostsRepository.excecute(request: [:])
            .receive(on: backgroundQueque)
            .eraseToAnyPublisher()
    }
    
    public func getUsersData() -> AnyPublisher<[UserModel], Error> {
        let key = "userdummieskey"
        let dummies = [
            UserModel(id: 1, name: "Joko Anwar", username: "jokoanwar34", avatar: "joko_anwar"),
            UserModel(id: 2, name: "Werkudara", username: "werkudara99jos", avatar: "werkudara"),
            UserModel(id: 3, name: "Nuraini", username: "nurnurnur", avatar: "ultraman")
        ]
        
        return self.getUsersDataRepository.excecute(request: key)
            .receive(on: backgroundQueque)
            .flatMap { users -> AnyPublisher<[UserModel], Error> in
                if users.isEmpty {
                    return self.updateWithDummies(with: (dummies, key))
                } else {
                    return Future<[UserModel], Error> { completion in
                        completion(.success(users))
                    }.eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func updateWithDummies(with request: ([UserModel], String)) -> AnyPublisher<[UserModel], Error> {
        return self.updateUsersDataRepository.excecute(request: request)
            .receive(on: backgroundQueque)
            .eraseToAnyPublisher()
    }
    
    public func getUserSession(with users: [UserModel]) -> AnyPublisher<UserSessionModel?, Error> {
        return self.getUserSessionRepository.excecute(request: nil)
            .receive(on: backgroundQueque)
            .flatMap { userSession -> AnyPublisher<UserSessionModel?, Error> in
                guard let session = userSession else {
                    if users.isEmpty {
                        return Future<UserSessionModel?, Error> { completion in
                            completion(.success(userSession))
                        }.eraseToAnyPublisher()
                    } else {
                        return self.saveUserSessionRepository.excecute(request: UserSessionModel(user: users.first!))
                            .map { saveSession in
                                return saveSession as UserSessionModel?
                            }.eraseToAnyPublisher()
                    }
                }
                
                if users.isEmpty {
                    return Future<UserSessionModel?, Error> { completion in
                        completion(.success(userSession))
                    }.eraseToAnyPublisher()
                } else {
                    if users.contains(session.user) {
                        return Future<UserSessionModel?, Error> { completion in
                            completion(.success(session))
                        }.eraseToAnyPublisher()
                    } else {
                        return self.deleteUserSessionRepository.excecute(request: session)
                            .flatMap { deleteSession -> AnyPublisher<UserSessionModel?, Error> in
                                return self.saveUserSessionRepository.excecute(request: UserSessionModel(user: users.first!))
                                    .map { saveSession in
                                        return saveSession as UserSessionModel?
                                    }.eraseToAnyPublisher()
                            }.eraseToAnyPublisher()
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func changeUserSession(from session: UserSessionModel?, with user: UserSessionModel) -> AnyPublisher<UserSessionModel, Error> {
        if let session = session {
            return self.deleteUserSessionRepository.excecute(request: session)
                .flatMap { deleteSession -> AnyPublisher<UserSessionModel, Error> in
                    return self.saveUserSessionRepository.excecute(request: user)
                        .map { saveSession in
                            return saveSession
                        }.eraseToAnyPublisher()
                }.eraseToAnyPublisher()
        } else {
            return self.saveUserSessionRepository.excecute(request: user)
                .map { saveSession in
                    return saveSession
                }.eraseToAnyPublisher()
        }
        
    }
}
