//
//  ViewController.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 8/1/24.
//

import UIKit

class TokenizerViewController: UIViewController {
    private var viewModel: TokenizerViewModel?
    
    // MARK: - Initialization
    init(viewModel: TokenizerViewModel = TokenizerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewModel = TokenizerViewModel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // UI Elements
    private let sentenceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter a sentence"
        return textField
    }()

    private let tokenizeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 32.5
        button.layer.borderWidth = 5.5
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let sentencesTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = .none
        textView.layer.borderWidth = 1.0
        return textView
    }()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardNotifications()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white

        // Add subviews
        view.addSubview(sentenceTextField)
        view.addSubview(tokenizeButton)
        view.addSubview(sentencesTextView) // Add it to the view, but it's hidden initially

        // Set up constraints
        sentenceTextField.translatesAutoresizingMaskIntoConstraints = false
        tokenizeButton.translatesAutoresizingMaskIntoConstraints = false
        sentencesTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sentenceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sentenceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sentenceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tokenizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tokenizeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15),
            tokenizeButton.heightAnchor.constraint(equalToConstant: 65),
            tokenizeButton.widthAnchor.constraint(equalToConstant: 65),

            // sentencesTextView constraints initially offscreen or 0 height
            sentencesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sentencesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sentencesTextView.topAnchor.constraint(equalTo: sentenceTextField.bottomAnchor, constant: 20),
            // Initially set the height to 0 to hide the textView
            sentencesTextView.heightAnchor.constraint(equalToConstant: 0)
        ])

        tokenizeButton.addTarget(self, action: #selector(tokenizeButtonTapped), for: .touchUpInside)
        sentencesTextView.isHidden = true // Hide the textView initially
    }
    
    private func bindViewModel() {
        viewModel?.updateView = { [weak self] sentences in
            DispatchQueue.main.async {
                self?.sentencesTextView.text = sentences.joined(separator: "\n")
                // Update the visibility and height constraint of sentencesTextView
                self?.sentencesTextView.isHidden = sentences.isEmpty
                let isTextViewVisible = !sentences.isEmpty
                self?.sentencesTextView.constraints.forEach { constraint in
                    // Adjust the height constraint of sentencesTextView as needed
                    if constraint.firstAttribute == .height {
                        constraint.constant = isTextViewVisible ? 200 : 0 // Example height, adjust as needed
                    }
                }
                self?.view.layoutIfNeeded() // Animate the constraint changes
            }
        }
    }
    
    // MARK: - Actions
    @objc private func tokenizeButtonTapped() {
        guard let text = sentenceTextField.text, !text.isEmpty else { return }
        viewModel?.tokenize(sentence: text, language: "en") // Defaulting to English for now
    }

    
    // MARK: - Keyboard Notifications
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let bottomInset = view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.3) {
                self.tokenizeButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + bottomInset + -20)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.tokenizeButton.transform = .identity
        }
    }
}
