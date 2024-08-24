//
//  AuthValidator.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 24.08.24.
//

import Foundation

struct AuthValidator {
  static func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }

  static func isValidPassword(_ password: String) -> Bool {
    // Minimum 8 characters, at least 1 Uppercase, 1 Lowercase
    let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z]).{8,}$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: password)
  }

  static func isValidUsername(_ username: String) -> Bool {
    // Check if the username is not empty and at least 3 characters long
    return !username.isEmpty && username.count >= 3
  }
}
