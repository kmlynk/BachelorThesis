//
//  DIY_NetworkApp.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    print("DEBUG: Firebase Connected!")
    
    return true
  }
}

@main
struct DIY_NetworkApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var authViewModel = AuthViewModel()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(authViewModel)
    }
  }
}
