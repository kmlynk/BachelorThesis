//
//  SearchViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Firebase
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
  @Published var users = [UserModel]()

  init() {
    Task { try await fetchSearchUsers() }
  }

  func fetchSearchUsers() async throws {
    self.users = try await UserService.fetchAllUsers()
  }
}
