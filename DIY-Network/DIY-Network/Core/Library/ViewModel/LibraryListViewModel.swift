//
//  LibraryListViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Firebase
import Foundation

@MainActor
class LibraryListViewModel: ObservableObject {
  private let user: UserModel
  @Published var projects = [ProjectModel]()

  init(user: UserModel) {
    self.user = user

    Task { try await fetchUserProjects() }
  }

  func fetchUserProjects() async throws {
    self.projects = try await LibraryService.fetchUserProjects(ownerId: user.id)
    print("DEBUG: \(self.projects)")
  }
}
