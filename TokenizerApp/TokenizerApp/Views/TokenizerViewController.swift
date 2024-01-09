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
    
    // UI Elements
    private let sentenceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter a sentence"
        return textField
    }()

    private let tokenizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tokenize", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 8
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
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white

        // Add subviews
        view.addSubview(sentenceTextField)
        view.addSubview(tokenizeButton)
        // Initially, sentencesTextView is not added to the view hierarchy

        // Set up constraints
        sentenceTextField.translatesAutoresizingMaskIntoConstraints = false
        tokenizeButton.translatesAutoresizingMaskIntoConstraints = false
        sentencesTextView.translatesAutoresizingMaskIntoConstraints = false // Ready for when we need to add it

        NSLayoutConstraint.activate([
            sentenceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sentenceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sentenceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tokenizeButton.topAnchor.constraint(equalTo: sentenceTextField.bottomAnchor, constant: 20),
            tokenizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tokenizeButton.widthAnchor.constraint(equalToConstant: 100),
            tokenizeButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        tokenizeButton.addTarget(self, action: #selector(tokenizeButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel?.updateView = { [weak self] sentences in
            DispatchQueue.main.async {
                self?.sentencesTextView.text = sentences.joined(separator: "\n")
            }
        }
    }

    
    // MARK: - Actions
    @objc private func tokenizeButtonTapped() {
        guard let text = sentenceTextField.text, !text.isEmpty else { return }
        viewModel?.tokenize(sentence: text, language: "en") // Defaulting to English for now
    }
}
