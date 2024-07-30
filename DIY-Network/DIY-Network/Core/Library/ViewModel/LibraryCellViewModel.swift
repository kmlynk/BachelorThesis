//
//  LibraryCellViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 29.07.24.
//

import Firebase
import Foundation

@MainActor
class LibraryCellViewModel: ObservableObject {
  @Published var project: ProjectModel

  init(project: ProjectModel) {
    self.project = project
  }

  func fetchProject() async throws {
    do {
      self.project = try await LibraryService.fetchSingleProject(project: project)
    } catch {
      print("DEBUG: Project couldn't fetched with error \(error.localizedDescription)")
    }
  }
}
