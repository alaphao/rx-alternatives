//
//  LoginService.swift
//  rxswift-alternatives
//
//  Created by Aleph Retamal on 27/5/19.
//  Copyright © 2019 Airtasker Pty Ltd. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginActions {
    func login(email: String, password: String) -> Single<Result<String, LoginError>>
}

final class LoginService: LoginActions {
    func login(email: String, password: String) -> Single<Result<String, LoginError>> {
        return Single<Result<String, LoginError>>
            .just(.success("token123"))
            .delay(1, scheduler: MainScheduler.instance)
    }
}
