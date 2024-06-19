//
//  ContentView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var authViewModel: AuthViewModel

  var body: some View {
    Group {
      if authViewModel.userSession == nil {
        LoginView()
      } else {
        if let user = authViewModel.currentUser {
          MainTabView(user: user)
        }
      }
    }
  }
}

#Preview{
  ContentView()
}
