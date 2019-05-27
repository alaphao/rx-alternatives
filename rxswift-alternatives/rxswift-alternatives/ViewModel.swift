//
//  ViewModel.swift
//  rxswift-alternatives
//
//  Created by Afonso Graça on 16/5/19.
//  Copyright © 2019 Airtasker Pty Ltd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum LoginError: Error {
    case wrongCredentials
}

struct ViewModel {
    private let activityIndicator = ActivityIndicator()
    var isLoading: Driver<Bool> {
        return activityIndicator.asDriver()
    }

    let loginService: LoginService

    func isValidEmail(email: String) -> Bool {
        return email.contains("@")
    }

    func isValidPassword(password: String) -> Bool {
        return !password.isEmpty
    }

    func login(with email: String, password: String) -> Observable<Result<String, LoginError>> {
        return loginService
            .login(email: email, password: password)
            .trackActivity(activityIndicator)
            .asObservable()
    }
}
