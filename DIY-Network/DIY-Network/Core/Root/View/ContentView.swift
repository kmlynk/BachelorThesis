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
      if authViewModel.userSession != nil {
        MainTabView()
      } else {
        LoginView()
      }
    }
  }
}

#Preview{
  ContentView()
}
