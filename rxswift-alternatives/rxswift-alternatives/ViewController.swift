//
//  ViewController.swift
//  rxswift-alternatives
//
//  Created by Afonso Graça on 16/5/19.
//  Copyright © 2019 Airtasker Pty Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    // MARK: - Views
    private lazy var username: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderWidth = 0.5
        field.layer.cornerRadius = 4
        field.clipsToBounds = true
        return field
    }()
    private lazy var password: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderWidth = 0.5
        field.layer.cornerRadius = 4
        field.clipsToBounds = true
        return field
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    private let spinner: UIActivityIndicatorView = {
        let e = UIActivityIndicatorView(style: .gray)
        e.hidesWhenStopped = true
        e.translatesAutoresizingMaskIntoConstraints = false
        return e
    }()

    // MARK: - Properties
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: ViewModel = ViewModel(loginService: LoginService())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup methods
extension ViewController {

    private func commonInit() {
        view.backgroundColor = .white
        [username, password, button, spinner].forEach(view.addSubview)
        NSLayoutConstraint.activate([
            username.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            username.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            username.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8)
            ])
        NSLayoutConstraint.activate([
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            password.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 8)
            ])
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 16)
            ])
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        setupBindings()
        
    }

    private func setupBindings() {
        let validEmail = username.rx.text.orEmpty
            .map(viewModel.isValidEmail)

        let validPassword = password.rx.text.orEmpty
            .map(viewModel.isValidPassword)

        // Set email text field's background to green if valid or red if invalid
        validEmail.map({ $0 ? UIColor.green : UIColor.red })
            .bind(to: username.rx.backgroundColor)
            .disposed(by: disposeBag)

        // Set password text field's background to green if valid or red if invalid
        validPassword.map({ $0 ? UIColor.green : UIColor.red })
            .bind(to: password.rx.backgroundColor)
            .disposed(by: disposeBag)

        // Enable button only if email and password are valid
        Observable.combineLatest(validEmail, validPassword) { $0 && $1 }
            .debug("Button enabled")
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)

        // Show / hide activity indicator (spinner)
        viewModel.isLoading
            .drive(spinner.rx.isAnimating)
            .disposed(by: disposeBag)

        // Button tap
        button.rx.tap
            // Get username and password from text fields
            .withLatestFrom(Observable.combineLatest(username.rx.text.orEmpty, password.rx.text.orEmpty))
            // Hide keyboard
            .do(onNext: { [weak self] _ in self?.resignResponders() })
            // Login request
            .flatMapLatest(viewModel.login)
            .debug("3")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    // Do success route if succeed
                    self?.showSuccessAlert()
                case let .failure(error):
                    // Show error if fails
                    self?.handle(error: error)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Actions
extension ViewController {

    private func resignResponders() {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }

    func handle(error: LoginError) {
        let alert = UIAlertController(title: "Login Failed", message: "Wrong Credentials", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success!!", message: "Login was a success", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
