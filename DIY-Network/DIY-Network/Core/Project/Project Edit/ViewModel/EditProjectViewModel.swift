//
//  EditProjectViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 23.06.24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class EditProjectViewModel: ObservableObject {
  private let project: ProjectModel
  @Published var name = ""
  @Published var desc = ""

  init(project: ProjectModel) {
    self.project = project
  }

  func deleteProject() async throws {
    // Delete Project
  }
}
