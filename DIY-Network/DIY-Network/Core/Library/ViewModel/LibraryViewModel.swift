//
//  LibraryViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 29.07.24.
//

import Foundation

@MainActor
class LibraryViewModel: ObservableObject {
  let user: UserModel
  @Published var projects = [ProjectModel]()

  init(user: UserModel) {
    self.user = user

    Task { try await getUsersProjects() }
  }

  func getUsersProjects() async throws {
    do {
      self.projects = try await LibraryService.fetchUserProjects(ownerId: user.id)
    } catch {
      print("DEBUG: User's projects couldn't fetched with error: \(error.localizedDescription)")
    }
  }
}
