//
//  ViewModel.swift
//  rxswift-alternatives
//
//  Created by Afonso Graça on 16/5/19.
//  Copyright © 2019 Airtasker Pty Ltd. All rights reserved.
//

import Foundation
import RxSwift


enum LoginError: Error {
    case wrongCredentials
}

func viewModel(email: Observable<String?>,
               password: Observable<String?>,
               buttonTap: Observable<Void>) -> Observable<Result<Void, LoginError>> {
    return buttonTap
        .withLatestFrom(Observable.combineLatest(email, password))
        .flatMapLatest(login)
}

func isValidEmail(email: String?) -> Bool {
    return email?.contains("@") ?? false
}
func isValidPassword(password: String?) -> Bool {
    return password?.isEmpty != true
}

func login(with email: String?, password: String?) -> Observable<Result<Void, LoginError>> {
    guard isValidEmail(email: email), isValidPassword(password: password) else {
        return .just(.failure(.wrongCredentials))
    }
    return .just(.success(()))
}
