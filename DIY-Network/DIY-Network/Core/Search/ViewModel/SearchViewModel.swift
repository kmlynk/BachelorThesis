//
//  SearchViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Foundation
import Firebase

@MainActor
class SearchViewModel: ObservableObject {
  @Published var users = [UserModel]()
  
  init() {
    Task { try await fetchSearchUsers() }
  }
  
  func fetchAllUsers() async throws -> [UserModel] {
    let snapshot = try await Firestore.firestore().collection("users").getDocuments()
    
    return snapshot.documents.compactMap({ try? $0.data(as: UserModel.self) })
  }
  
  func fetchSearchUsers() async throws {
    self.users = try await fetchAllUsers()
  }
}
