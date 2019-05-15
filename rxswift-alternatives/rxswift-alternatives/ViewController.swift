//
//  ViewController.swift
//  rxswift-alternatives
//
//  Created by Afonso Graça on 16/5/19.
//  Copyright © 2019 Airtasker Pty Ltd. All rights reserved.
//

import UIKit

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
        button.addTarget(self, action: #selector(loginPressed), for: .primaryActionTriggered)
        return button
    }()

    // MARK: - Properties
    let viewModel: ViewModel

    init(viewModel: ViewModel = ViewModel()) {
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
        [username, password, button].forEach(view.addSubview)
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
    }
}

// MARK: - Actions
extension ViewController {

    @objc
    func loginPressed() {
        resignResponders()
        viewModel.login(with: username.text, password: password.text) { result in
            guard case let .failure(error) = result else { return }
            handle(error: error)
        }
    }

    private func resignResponders() {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }

    func handle(error: ViewModel.LoginError) {
        let alert = UIAlertController(title: "Login Failed", message: "Wrong Credentials", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
