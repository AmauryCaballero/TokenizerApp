//
//  TokenizerViewController+TextFieldDelegate.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 9/1/24.
//

import Foundation
import UIKit

extension TokenizerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor // Change border color to black when editing begins
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor // Change border color back to gray when editing ends
    }
}
