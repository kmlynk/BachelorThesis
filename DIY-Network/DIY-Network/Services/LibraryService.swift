//
//  LibraryService.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Firebase

struct LibraryService {
  private static let db = Firestore.firestore().collection("projects")

  static func uploadProjectData(ownerId: String, projectName: String, projectDesc: String) async {
    do {
      let project = ProjectModel(
        id: NSUUID().uuidString,
        ownerId: ownerId,
        projectName: projectName,
        projectDesc: projectDesc
      )

      let encodedProject = try Firestore.Encoder().encode(project)
      try await db.document(project.id).setData(encodedProject)
    } catch {
      print(
        "DEBUG: Failed to upload project data to database with error \(error.localizedDescription)")
    }
  }
  
  static func uploadProjectData(withImage imageUrl: String, ownerId: String, projectName: String, projectDesc: String) async {
    do {
      let project = ProjectModel(
        id: NSUUID().uuidString,
        ownerId: ownerId,
        projectName: projectName,
        projectDesc: projectDesc,
        projectImageUrl: imageUrl
      )

      let encodedProject = try Firestore.Encoder().encode(project)
      try await db.document(project.id).setData(encodedProject)
    } catch {
      print(
        "DEBUG: Failed to upload project data to database with error \(error.localizedDescription)")
    }
  }

  static func fetchUserProjects(ownerId: String) async throws -> [ProjectModel] {
    do {
      print("DEBUG: Fetching projects...")
      let snapshot = try await db.whereField("ownerId", isEqualTo: ownerId).getDocuments()
      print("DEBUG: Projects fetched!")
      return try snapshot.documents.compactMap({ try $0.data(as: ProjectModel.self) })
    } catch {
      print("DEBUG: Failed to fetch users projects with error \(error.localizedDescription)")
      return []
    }
  }
}
