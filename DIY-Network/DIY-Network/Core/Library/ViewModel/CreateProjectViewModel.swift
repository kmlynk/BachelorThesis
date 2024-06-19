//
//  CreateProjectViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class CreateProjectViewModel: ObservableObject {
  private let user: UserModel
  @Published var projectName = ""
  @Published var projectDesc = ""

  init(user: UserModel) {
    self.user = user
  }

  func createNewProject() async throws {
    await LibraryService.uploadProjectData(
      ownerId: user.id,
      projectName: projectName,
      projectDesc: projectDesc
    )
  }
}
