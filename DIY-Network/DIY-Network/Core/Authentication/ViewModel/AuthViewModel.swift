//
//  AuthViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: UserModel?
  @Published var authError: String?

  init() {
    self.userSession = Auth.auth().currentUser
    Task { await fetchUser() }
  }

  func signIn(withEmail email: String, password: String) async throws {
    do {
      let result = try await Auth.auth().signIn(withEmail: email, password: password)
      self.userSession = result.user
      await fetchUser()
    } catch {
      self.authError = "Failed to login: \(error.localizedDescription)"
      throw error
    }
  }

  func createUser(withEmail email: String, password: String, username: String) async throws {
    do {
      let result = try await Auth.auth().createUser(withEmail: email, password: password)
      self.userSession = result.user
      await uploadUserData(
        uid: result.user.uid, email: email, password: password, username: username)
      await fetchUser()
    } catch {
      self.authError = "Failed to register: \(error.localizedDescription)"
      throw error
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
      print(
        "DEBUG: Failed to upload user data to database with error \(error.localizedDescription)")
    }
  }

  func fetchUser() async {
    print("DEBUG: Fetching user...")
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard
      let snapshot = try? await Firestore.firestore().collection("users").document(uid)
        .getDocument()
    else { return }
    self.currentUser = try? snapshot.data(as: UserModel.self)
    print("DEBUG: User fetched!")
    print("DEBUG: Current user is \(String(describing: self.currentUser))")
  }
}
