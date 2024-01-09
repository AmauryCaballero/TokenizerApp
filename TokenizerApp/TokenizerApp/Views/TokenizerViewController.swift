//
//  ViewController.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 8/1/24.
//

import UIKit

class TokenizerViewController: UIViewController {
    private let viewModel: TokenizerViewModel
    
    // MARK: - Initialization
    init(viewModel: TokenizerViewModel = TokenizerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
          setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
    }
    
    private func bindViewModel() {
    }
    
    // MARK: - Actions
    @objc private func tokenizeButtonTapped() {
    }
}
