//
//  AuthClient.swift
//  Keddr
//
//  Created by macbook on 19.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import KeychainAccess


class AuthClient {
    
    static let keychain = Keychain(service: "com.keddr.credentials")
    
    static let baseUrlRequest: URLRequest = {
        var request = URLRequest(url: URL(string: "https://keddr.com")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields =  [
            "Host": "keddr.com",
            "Connection" : "keep-alive",
            "Accept": "*/*",
            "Origin": "https://keddr.com",
            "X-Requested-With": "XMLHttpRequest",
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "Referer": "https://keddr.com/",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4"
        ]
        return request
    }()
    
    static func signIn(with user: User, complition: @escaping(_ error: ApiError?)->() ){
        guard let url = URL(string: "https://keddr.com/wp-login.php") else {
            complition(ApiErrorConstructor.genericError)
            return
        }
        var request = baseUrlRequest
        request.url = url
        let httpBodyString = "log=\(user.login)&pwd=\(user.password)&testcookie=1"
        request.httpBody = httpBodyString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                complition(ApiErrorConstructor.genericError)
                return
            }
            if let response = response as? HTTPURLResponse,
                let responseCookie = response.allHeaderFields["Set-Cookie"] as? String, responseCookie.contains("wordpress_sec"){
                keychain[UserCredentials.login.rawValue] = user.login
                keychain[UserCredentials.password.rawValue] = user.password
                if keychain[UserCredentials.uid.rawValue] != nil{
                    complition(nil)
                    return
                }
                Api.fetchUserId(complition: { (uid) in
                    guard let uid = uid else {
                        complition(ApiErrorConstructor.genericError)
                        return
                    }
                    keychain[UserCredentials.uid.rawValue] = uid
                    complition(nil)
                })
            } else {
                try? keychain.removeAll()
                complition(ApiErrorConstructor.badCredentialsError)
            }
            }.resume()
    }
    static func reply(for comment: Comment, complition: @escaping(_ error: ApiError?) -> () ){
        checkAndValidateUser { (error) in
            if let error = error { complition(error); return }
            guard let url = URL(string: "https://keddr.com/wp-comments-post.php"),
                let uid = keychain[UserCredentials.uid.rawValue],
                let parentId = comment.commentId,
                let postId = comment.postId else {
                    complition(ApiErrorConstructor.genericError)
                    return
            }
            let httpBodyString = "user_id=\(uid)&comment_post_ID=\(postId)&comment=d&url=&comment_parent=\(parentId)&subscribe_all_comments=false&subscribe_my_comment=false&social_icon="
            var request = baseUrlRequest
            request.url = url
            request.httpBody = httpBodyString.data(using: .utf8)
            baseInteractionTask(with: request, complition: { (error) in
                if let error = error {
                    complition(error)
                    return
                }
                complition(nil)
            })
        }
    }
    static func voteComment(with comment: Comment, like: Bool, complition: @escaping(_ error: ApiError?) -> () ){
        checkAndValidateUser { (error) in
            if let error = error { complition(error); return }
            guard let url = URL(string: "https://keddr.com/wp-admin/admin-ajax.php?lang=en&action=decom_comments&f=voting"),
                let uid = keychain[UserCredentials.uid.rawValue],
                let commentId = comment.commentId else {
                    complition(ApiErrorConstructor.genericError)
                    return
            }
            let vote = like ? "like" : "dislike"
            var request = baseUrlRequest
            request.url = url
            let httpBodyString = "fk_comment_id=\(commentId)&fk_user_id=\(uid)&voice=\(vote)"
            request.httpBody = httpBodyString.data(using: .utf8)
            baseInteractionTask(with: request) { (error) in
                if let error = error {
                    complition(error)
                    return
                }
                complition(nil)
            }
        }
    }
    static func baseInteractionTask(with request: URLRequest, complition: @escaping(_ error: ApiError?) -> () ){
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                complition(ApiErrorConstructor.genericError)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode.isSuccessHttpCode{
                complition(nil)
                return
            }
            complition(ApiErrorConstructor.genericError)
            }.resume()
    }
    static private func checkUser() -> User? {
        guard let login = keychain[UserCredentials.login.rawValue],
            let password = keychain[UserCredentials.password.rawValue] else { return nil }
        return User(login: login, password: password)
    }
    static func checkAndValidateUser(complition: @escaping(_ error: ApiError?)->() ){
        if let user = checkUser(){
            signIn(with: user, complition: { (error) in
                if let error = error{
                    complition(error)
                    return
                }
                complition(nil)
            })
        } else { complition(ApiErrorConstructor.authorizeError) }
    }
    static func logOut(){
        do{
            try keychain.removeAll()
            UserDefaults.standard.setIsLoginScreenShown(value: false)
        } catch { print("Failed logging out") }
    }
}




