//
//  LibraryService.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Firebase

struct LibraryService {
  private static let projectDB = Firestore.firestore().collection("projects")

  // It gets projects steps and retuns as an array
  static func fetchProjectStepData(project: ProjectModel) async throws -> [ProjectStepModel] {
    do {
      print("DEBUG: Trying to reach to steps collection...")
      let snapshot = try await projectDB.document(project.id).collection("steps").getDocuments()
      print("DEBUG: Project ID: \(project.id)")
      print("DEBUG: Projects step data fetched!")
      return try snapshot.documents.compactMap({ try $0.data(as: ProjectStepModel.self) })
    } catch {
      print(
        "DEBUG: Failed to fetch step data from database with error \(error.localizedDescription)")
      return []
    }
  }

  // It gets users projects and returns as an array
  static func fetchUserProjects(ownerId: String) async throws -> [ProjectModel] {
    do {
      print("DEBUG: Fetching projects...")
      let snapshot = try await projectDB.whereField("ownerId", isEqualTo: ownerId).getDocuments()
      print("DEBUG: Projects fetched!")
      return try snapshot.documents.compactMap({ try $0.data(as: ProjectModel.self) })
    } catch {
      print("DEBUG: Failed to fetch users projects with error \(error.localizedDescription)")
      return []
    }
  }

  static func uploadProjectData(ownerId: String, projectName: String, projectDesc: String) async {
    do {
      let project = ProjectModel(
        id: NSUUID().uuidString,
        ownerId: ownerId,
        projectName: projectName,
        projectDesc: projectDesc
      )
      let encodedProject = try Firestore.Encoder().encode(project)
      try await projectDB.document(project.id).setData(encodedProject)
    } catch {
      print(
        "DEBUG: Failed to upload project data to database with error \(error.localizedDescription)")
    }
  }

  static func uploadProjectData(
    withImage imageUrl: String, ownerId: String, projectName: String, projectDesc: String
  ) async {
    do {
      let project = ProjectModel(
        id: NSUUID().uuidString,
        ownerId: ownerId,
        projectName: projectName,
        projectDesc: projectDesc,
        projectImageUrl: imageUrl
      )
      let encodedProject = try Firestore.Encoder().encode(project)
      try await projectDB.document(project.id).setData(encodedProject)
    } catch {
      print(
        "DEBUG: Failed to upload project data to database with error \(error.localizedDescription)")
    }
  }

  static func uploadProjectStepData(
    project: ProjectModel, stepNumber: Int, stepName: String, stepDesc: String
  ) async {
    do {
      let step = ProjectStepModel(
        id: NSUUID().uuidString,
        stepNumber: stepNumber,
        stepName: stepName,
        stepDesc: stepDesc
      )
      let encodedStep = try Firestore.Encoder().encode(step)
      try await projectDB.document(project.id).collection("steps").document(step.id).setData(
        encodedStep)
    } catch {
      print(
        "DEBUG: Failed to upload step data to database with error \(error.localizedDescription)")
    }
  }

  static func uploadProjectStepData(
    withImage imageUrl: String, project: ProjectModel, stepNumber: Int, stepName: String,
    stepDesc: String
  ) async {
    do {
      let step = ProjectStepModel(
        id: NSUUID().uuidString,
        stepNumber: stepNumber,
        stepName: stepName,
        stepDesc: stepDesc,
        stepImageUrl: imageUrl
      )
      let encodedStep = try Firestore.Encoder().encode(step)
      try await projectDB.document(project.id).collection("steps").document(step.id).setData(
        encodedStep)
    } catch {
      print(
        "DEBUG: Failed to upload step data to database with error \(error.localizedDescription)")
    }
  }

  static func mergeSort(arr: [ProjectStepModel]) -> [ProjectStepModel] {
    guard arr.count > 1 else { return arr }

    let leftArr = Array(arr[0..<arr.count / 2])
    let rightArr = Array(arr[arr.count / 2..<arr.count])

    return merge(left: mergeSort(arr: leftArr), right: mergeSort(arr: rightArr))
  }

  static func merge(left: [ProjectStepModel], right: [ProjectStepModel]) -> [ProjectStepModel] {
    var mergedArr = [ProjectStepModel]()
    var left = left
    var right = right

    while left.count > 0 && right.count > 0 {
      if left.first!.stepNumber < right.first!.stepNumber {
        mergedArr.append(left.removeFirst())
      } else {
        mergedArr.append(right.removeFirst())
      }
    }

    return mergedArr + left + right
  }
}
