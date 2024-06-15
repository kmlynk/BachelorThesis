//
//  AuthViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

@MainActor
class AuthViewModel: ObservableObject {
  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: UserModel?
  
  init () {
    self.userSession = Auth.auth().currentUser
    Task { await fetchUser() }
  }
  
  func signIn(withEmail email: String, password: String) async throws {
    do {
      print("DEBUG: Signing in...")
      let result = try await Auth.auth().signIn(withEmail: email, password: password)
      self.userSession = result.user
      print("DEBUG: result.user -> \(result.user)")
      print("DEBUG: self.userSession -> \(String(describing: self.userSession))")
      await fetchUser()
      print("DEBUG: Signed in!")
    } catch {
      print("DEBUG: Failed to login user with error \(error.localizedDescription)")
    }
  }
  
  func createUser(withEmail email: String, password: String, username: String) async throws {
    do {
      print("DEBUG: Registering new account for \(username)...")
      let result = try await Auth.auth().createUser(withEmail: email, password: password)
      self.userSession = result.user
      print("DEBUG: User Session -> \(String(describing: userSession))")
      await uploadUserData(uid: result.user.uid, email: email, password: password, username: username)
      print("DEBUG: Registered!")
      await fetchUser()
    } catch {
      print("DEBUG: Failed to register user with error \(error.localizedDescription)")
    }
  }
  
  func signOut() {
    do {
      print("DEBUG: Signing out...")
      try Auth.auth().signOut()
      self.userSession = nil
      self.currentUser = nil
      print("DEBUG: Signed out!")
      print("DEBUG: userSession -> \(String(describing: self.userSession))")
      print("DEBUG: currentUser -> \(String(describing: self.currentUser))")
    } catch {
      print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
    }
  }
  
  func deleteAccount() {
    print("DEBUG: Deleting the account...")
    print("DEBUG: Account deleted!")
  }
  
  func uploadUserData(uid: String, email: String, password: String, username: String) async {
    do {
      print("DEBUG: Uploading user data to database...")
      let user = UserModel(id: uid, email: email, username: username)
      let encodedUser = try Firestore.Encoder().encode(user)
      try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    } catch {
      print("DEBUG: Failed to upload user data to database with error \(error.localizedDescription)")
    }
  }
  
  func fetchUser() async {
    print("DEBUG: Fetching user...")
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
    self.currentUser = try? snapshot.data(as: UserModel.self)
    print("DEBUG: User fetched!")
    print("DEBUG: Current user is \(String(describing: self.currentUser))")
  }
}
