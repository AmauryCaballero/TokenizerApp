//
//  Languages.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 9/1/24.
//

import Foundation

enum Languages: String, CaseIterable {
    case English = "en"
    case Spanish = "es"
    
    init(rawValue: String) throws {
        guard let language = Languages(rawValue: rawValue) else {
            throw TokenizerError.unsupportedLanguage
        }
        self = language
    }
}
