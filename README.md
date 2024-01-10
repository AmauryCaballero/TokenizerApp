# TokenizerApp Documentation

## Introduction

TokenizerApp is an iOS application designed to tokenize sentences based on specific keywords. It supports English and Spanish languages, identifying the words "if" and "and" for English, and "si" and "y" for Spanish to tokenize sentences.

## Requirements

### Functional Requirements

- Tokenize sentences by "if" and "and" in English.
- Tokenize sentences by "si" and "y" in Spanish.

### Non-Functional Requirements

- Language configurability.

## Application Architecture

This application follows the MVVM (Model-View-ViewModel) design pattern to ensure a separation of concerns and improve maintainability.


## Views
### SplashViewController

- Handles the initial language selection and transitions to the main tokenization interface.
- Implements `UIViewControllerProtocol` to standardize UI setup routines.

### TokenizerViewController

- Manages user input for sentence tokenization.
- Updates the UI in response to language selection and tokenization output.

## Models

### Languages Enumeration (`Languages.swift`)

#### Overview
The `Languages` enumeration defines the supported languages within the TokenizerApp. It includes a failable initializer that can throw an error if an unsupported language code is used.

#### Cases
- `English`: Represents the English language with the raw value "en".
- `Spanish`: Represents the Spanish language with the raw value "es".

#### Initialization
- `init(rawValue: String) throws`: Attempts to create a `Languages` instance from a given raw value. Throws a `TokenizerError.unsupportedLanguage` if the raw value does not correspond to a supported language.

#### Usage
Used throughout the app to handle language-specific functionality, such as tokenization rules and language settings.

### SentenceTokenizer Class (`SentenceTokenizer.swift`)

#### Overview
`SentenceTokenizer` is responsible for the core functionality of tokenizing input sentences based on language-specific keywords.

#### Properties
- `private let tokens: [Languages: [String]]`: A dictionary mapping `Languages` to their respective tokenization keywords.

#### Initialization
- `init(tokens: [Languages: [String]] = [Languages.English: ["if", "and"], Languages.Spanish: ["si", "y"]])`: Initializes the `SentenceTokenizer` with a default set of tokens for English and Spanish. Custom tokens can be provided during initialization.

#### Methods
- `func tokenize(sentence: String, language: Languages = .English) throws -> [String]`: Tokenizes the provided sentence according to the specified language's keywords. Returns an array of tokenized strings or throws a `TokenizerError.unsupportedLanguage` error if the language is not supported.

#### Usage
An instance of `SentenceTokenizer` should be created and used by the `TokenizerViewModel` to perform sentence tokenization. It requires a sentence and a `Languages` value to perform its task.



## ViewModels

### TokenizerViewModel (`TokenizerViewModel.swift`)

#### Overview
`TokenizerViewModel` is responsible for managing the business logic associated with sentence tokenization. It interacts with the `SentenceTokenizer` model to process input sentences and provides a mechanism to update the view with the results.

#### Properties
- `private let tokenizer: SentenceTokenizer`: An instance of the `SentenceTokenizer` class that performs the actual tokenization of sentences.
- `var updateView: (([String]) -> Void)?`: A closure that is called to update the view with the tokenized sentences or error messages.
- `private var currentLanguage: Languages = .English`: Keeps track of the currently selected language for tokenization.

#### Initialization
- `init(tokenizer: SentenceTokenizer = SentenceTokenizer())`: Initializes the `TokenizerViewModel` with a `SentenceTokenizer`. The tokenizer is default initialized if not provided.

#### Methods
- `func tokenize(sentence: String)`: Tokenizes the provided sentence. If tokenization is successful, the `updateView` closure is called with the tokenized sentences. If an error occurs, the `updateView` closure is called with an appropriate error message.
- `func updateLanguage(to language: Languages) throws`: Updates the `currentLanguage` property. Throws an `unsupportedLanguage` error if the language is not supported by the app.

#### Usage
Instances of `TokenizerViewModel` should be created and used by the corresponding view controllers that require sentence tokenization functionality. The `updateView` closure should be set by the view controller to handle the tokenization results.

## Protocols

### UIViewControllerProtocol (`UIViewControllerProtocol.swift`)

#### Overview
`UIViewControllerProtocol` is a protocol that standardizes the setup of user interface and accessibility identifiers in ViewControllers within the TokenizerApp. It ensures consistency and enforces a structure for initializing UI components and setting up accessibility features.

#### Requirements
- `func setupUI()`: A method that should be implemented to set up the UI components of the ViewController. This includes layout, styling, and any initial state configuration.
- `func setupAccessibilityIdentifier()`: A method that should be implemented to set up accessibility identifiers for UI components. This is crucial for making the app more accessible and for UI testing.

#### Usage
Any ViewController in the TokenizerApp that needs a standardized method of setting up its UI or accessibility features should conform to this protocol. By conforming to `UIViewControllerProtocol`, a ViewController is required to implement both `setupUI` and `setupAccessibilityIdentifier` methods, ensuring that these essential steps are not overlooked.

Example Implementation:
```swift
class SomeViewController: UIViewController, UIViewControllerProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAccessibilityIdentifier()
    }

    func setupUI() {
        // Implement UI setup here
    }

    func setupAccessibilityIdentifier() {
        // Implement accessibility identifier setup here
    }
}
```
## Services and Utilities

In this section, we document the utility extensions and services provided within the application. These extensions add functionality to existing Swift classes.

### String Extensions (`String+Utilities.swift`)

#### Overview
Provides utility properties for language codes used within the app.

#### Properties
- `spanish`: Returns the string `"es"` for the Spanish language code.
- `english`: Returns the string `"en"` for the English language code.

### UIView Extensions (`UIView+Utilities.swift`)

#### Overview
Adds utility functions to the `UIView` class to enhance user interface elements with consistent styling across the app.

#### Methods
- `addShadow()`: Applies a shadow effect to a `UIView` with predefined properties such as color, offset, opacity, and radius. The shadow extends beyond the edges of the view as `masksToBounds` is set to `false`.


## Testing

### SplashViewControllerTests

- Tests the functionality of `SplashViewController`, ensuring language selection and UI setup behave as expected.

### TokenizerAppUITests

- UI tests for the app, verifying that the user interface works correctly with user interactions.
