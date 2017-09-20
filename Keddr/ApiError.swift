//
//  ApiError.swift
//  Keddr
//
//  Created by macbook on 20.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

struct ApiError: Error {
    let userDescription: String
}

class ApiErrorConstructor {
    static let badCredentialsError = ApiError(userDescription: "Неверные имя пользователя или пароль")
    static let authorizeError = ApiError(userDescription: "Необходимо авторизоваться")
    static let genericError = ApiError(userDescription: "Что-то пошло не так")
}










