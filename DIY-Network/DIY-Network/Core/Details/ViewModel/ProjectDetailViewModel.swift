//
//  ProjectDetailViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 04.08.24.
//

import Foundation

@MainActor
class ProjectDetailViewModel: ObservableObject {
  let user: UserModel
  var id: String
  @Published var project = ProjectModel.MOCK_PROJECTS[0]
  @Published var steps = [ProjectStepModel]()

  init(user: UserModel, id: String) {
    self.user = user
    self.id = id
    Task {
      await fetchProject()
    }
    print("DEBUG: Project Name: \([project.projectName])")
    print("DEBUG: Steps Count: \(steps.count)")
  }

  func fetchProject() async {
    do {
      try await getProject()
      try await getSteps()
    } catch {
      print("DEBUG: Failed to fetch project with error: \(error.localizedDescription)")
    }
  }

  func importProject() async {
    do {
      try await LibraryService.importProjectToUserLibrary(project: project, newOwner: user)
    } catch {
      print("DEBUG: Failed to import project with error: \(error.localizedDescription)")
    }
  }

  func getProject() async throws {
    self.project = try await LibraryService.fetchPostedProject(projectId: id)
  }

  func getSteps() async throws {
    self.steps = try await LibraryService.fetchPostedProjectStepData(project: project)
  }
}
