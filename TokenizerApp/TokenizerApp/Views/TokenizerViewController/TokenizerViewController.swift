//
//  ViewController.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 8/1/24.
//

import UIKit
import Lottie

class TokenizerViewController: UIViewController, UIViewControllerProtocol {
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
    
    private var animationView: LottieAnimationView?
    
    private let sentenceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Enter a sentence"
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set the height of the text field
        
        // Centrado vertical del contenido y el placeholder
        textField.contentVerticalAlignment = .center

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        leftView.backgroundColor = .clear
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()


    private let languageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Language: 🇺🇸", for: .normal) // Default language
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
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
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "press to tokenize"
        label.textColor = UIColor.gray
        return label
    }()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sentenceTextField.delegate = self
        setupUI()
        setupKeyboardNotifications()
        bindViewModel()
    }
    
    // MARK: - Setup
    // Declare the sentencesTextViewHeightConstraint as an instance variable in your view controller
    var sentencesTextViewHeightConstraint: NSLayoutConstraint!

    internal func setupUI() {
        view.backgroundColor = UIColor.white

        setupAnimationView()
        
        // Add subviews to the stack view
        stackView.addArrangedSubview(sentenceTextField)
        stackView.addArrangedSubview(languageButton)

        // Add stack view and other subviews to the view
        
        view.addSubview(animationView!)
        view.addSubview(buttonLabel)
        view.addSubview(stackView)
        view.addSubview(tokenizeButton)
        view.addSubview(sentencesTextView)

        // Disable autoresizing masks for Auto Layout
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        sentenceTextField.translatesAutoresizingMaskIntoConstraints = false
        tokenizeButton.translatesAutoresizingMaskIntoConstraints = false
        sentencesTextView.translatesAutoresizingMaskIntoConstraints = false

        // Set width constraint for languageButton
        let languageButtonWidthConstraint = languageButton.widthAnchor.constraint(equalToConstant: 100) // Adjust this value as needed

        // Set maximum width constraint for sentenceTextField
        let sentenceTextFieldMaxWidthConstraint = sentenceTextField.widthAnchor.constraint(lessThanOrEqualTo: stackView.widthAnchor, multiplier: 0.7) // Adjust the multiplier as needed

        if let animationView = animationView {
            NSLayoutConstraint.activate([
                animationView.topAnchor.constraint(equalTo: view.topAnchor),
                animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            animationView.play()
        }
        
        
        // Set constraints
        NSLayoutConstraint.activate([
            buttonLabel.bottomAnchor.constraint(equalTo: tokenizeButton.topAnchor, constant: -10),
            buttonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            languageButtonWidthConstraint,
            sentenceTextFieldMaxWidthConstraint,

            tokenizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tokenizeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15),
            tokenizeButton.heightAnchor.constraint(equalToConstant: 65),
            tokenizeButton.widthAnchor.constraint(equalToConstant: 65),

            sentencesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sentencesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sentencesTextView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            sentencesTextView.heightAnchor.constraint(equalToConstant: 200) // Initial height, adjust as needed
        ])

        
        addShadowToInteractiveElements()
        // Button actions
        languageButton.addTarget(self, action: #selector(showLanguagePicker), for: .touchUpInside)
        tokenizeButton.addTarget(self, action: #selector(tokenizeButtonTapped), for: .touchUpInside)

        // Initially hide the textView
        sentencesTextView.isHidden = true
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
    
    private func addShadowToInteractiveElements() {
        sentenceTextField.addShadow()
        languageButton.addShadow()
        tokenizeButton.addShadow()
        sentencesTextView.addShadow()
        buttonLabel.addShadow()
    }
    
    private func setupAnimationView() {
        animationView = LottieAnimationView(name: "letters")
        animationView?.center = self.view.center
        animationView?.loopMode = .loop
        animationView?.contentMode = .center
        animationView?.isHidden = false
    }
    
    private func updateLanguage(to languageCode: String) {
        switch languageCode {
        case "en":
            languageButton.setTitle("Language: 🇺🇸", for: .normal)
            viewModel?.updateLanguage(to: "en")
            // Update any other relevant UI or settings for English
        case "es":
            languageButton.setTitle("Language: 🇪🇸", for: .normal)
            viewModel?.updateLanguage(to: "es")
            // Update any other relevant UI or settings for Spanish
        default:
            break
        }
    }

    
    // MARK: - Actions
    @objc private func tokenizeButtonTapped() {
        guard let text = sentenceTextField.text, !text.isEmpty else { return }
        viewModel?.tokenize(sentence: text)
    }

    @objc private func showLanguagePicker() {
        let alert = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)

        let englishAction = UIAlertAction(title: "English 🇺🇸", style: .default) { [weak self] _ in
            self?.updateLanguage(to: "en")
        }
        let spanishAction = UIAlertAction(title: "Español 🇪🇸", style: .default) { [weak self] _ in
            self?.updateLanguage(to: "es")
        }

        alert.addAction(englishAction)
        alert.addAction(spanishAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true)
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
                let transformAffine =  CGAffineTransform(translationX: 0, y: -keyboardHeight + bottomInset + -20)
                self.buttonLabel.transform = transformAffine
                self.tokenizeButton.transform = transformAffine
                self.animationView?.layer.opacity = 0.2
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.buttonLabel.transform = .identity
            self.tokenizeButton.transform = .identity
            self.animationView?.layer.opacity = 1
        }
    }
}
