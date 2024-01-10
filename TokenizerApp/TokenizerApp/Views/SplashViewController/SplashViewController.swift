//
//  SplashViewController.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 9/1/24.
//

import Foundation
import UIKit
import Lottie

class SplashViewController: UIViewController, UIViewControllerProtocol {
    private var viewModel: SplashViewModel?
    
    init(viewModel: SplashViewModel = SplashViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewModel = SplashViewModel()
    }
    
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        animationView = LottieAnimationView(name: "languages")
        animationView?.center = self.view.center
        animationView?.loopMode = .playOnce
        animationView?.backgroundColor = view.backgroundColor
        animationView?.contentMode = .scaleToFill
        animationView?.isHidden = false
        
        if let animationView = animationView {
            view.addSubview(animationView)
            NSLayoutConstraint.activate([
                animationView.topAnchor.constraint(equalTo: view.topAnchor),
                animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
            
            animationView.play { [weak self] (finished) in
                if finished {
                     self?.navigateToNextStoryboard()
                 }
            }
        }
    }
    
    private func navigateToNextStoryboard() {
        let tokenizerViewController = TokenizerViewController()

         // Configurar el nuevo controlador de vista como raíz
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tokenizerViewController
            window.makeKeyAndVisible()
        }
    }
}
