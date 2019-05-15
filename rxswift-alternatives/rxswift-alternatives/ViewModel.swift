//
//  ViewModel.swift
//  rxswift-alternatives
//
//  Created by Afonso Graça on 16/5/19.
//  Copyright © 2019 Airtasker Pty Ltd. All rights reserved.
//

import Foundation

struct ViewModel {

    enum LoginError: Error {
        case wrongCredentials
    }

    func isValidEmail(email: String?) -> Bool {
        return email?.contains("@@") ?? false
    }
    func isValidPassword(password: String?) -> Bool {
        return password?.isEmpty != true
    }

    func login(with email: String?, password: String?, completion: (Result<Void, LoginError>) -> ()) {
        guard isValidEmail(email: email), isValidPassword(password: password) else {
            completion(.failure(.wrongCredentials))
            return
        }
        completion(.success(()))
    }
}
