//
//  LoginViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import Foundation

class LoginViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var username = ""
}
