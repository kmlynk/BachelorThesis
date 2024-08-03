//
//  LibraryService.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Firebase

struct LibraryService {
  private static let projectDB = Firestore.firestore().collection("projects")
  private static let postDB = Firestore.firestore().collection("posts")
  private static let postedProjectDB = Firestore.firestore().collection("posted-projects")

  static func fetchSingleProject(withId projectId: String) async throws -> ProjectModel {
    print("DEBUG: Trying to reach to steps collection...")
    let snapshot = try await projectDB.document(projectId).getDocument()
    print("DEBUG: Project data fetched!")
    return try snapshot.data(as: ProjectModel.self)
  }

  static func fetchSingleProject(project: ProjectModel) async throws -> ProjectModel {
    print("DEBUG: Trying to reach to steps collection...")
    let snapshot = try await projectDB.document(project.id).getDocument()
    print("DEBUG: Project data fetched!")
    return try snapshot.data(as: ProjectModel.self)
  }

  static func fetchPostedProject(projectId: String) async throws -> ProjectModel {
    print("DEBUG: Trying to reach to steps collection...")
    let snapshot = try await postedProjectDB.document(projectId).getDocument()
    print("DEBUG: Project data fetched!")
    return try snapshot.data(as: ProjectModel.self)

  }

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

  static func fetchPostedProjectStepData(project: ProjectModel) async throws -> [ProjectStepModel] {
    do {
      print("DEBUG: Trying to reach to steps collection...")
      let snapshot = try await postedProjectDB.document(project.id).collection("steps")
        .getDocuments()
      print("DEBUG: Project ID: \(project.id)")
      print("DEBUG: Projects step data fetched!")
      return try snapshot.documents.compactMap({ try $0.data(as: ProjectStepModel.self) })
    } catch {
      print(
        "DEBUG: Failed to fetch step data from database with error \(error.localizedDescription)")
      return []
    }
  }

  static func fetchSingleStepData(step: ProjectStepModel) async throws -> ProjectStepModel {
    let snapshot = try await projectDB.document(step.projectId).collection("steps").document(
      step.id
    ).getDocument()
    return try snapshot.data(as: ProjectStepModel.self)
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

  static func uploadProjectData(
    ownerId: String, projectName: String, projectDesc: String, imageUrl: String?
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

  static func uploadPostedProjectData(project: ProjectModel) async throws -> String {
    do {
      let id = NSUUID().uuidString
      let project = ProjectModel(
        id: id,
        ownerId: project.ownerId,
        projectName: project.projectName,
        projectDesc: project.projectDesc,
        projectImageUrl: project.projectImageUrl
      )
      let encodedProject = try Firestore.Encoder().encode(project)
      try await postedProjectDB.document(id).setData(encodedProject)
      return id
    } catch {
      print(
        "DEBUG: Failed to upload posted project data to database with error \(error.localizedDescription)"
      )
      return ""
    }
  }

  static func uploadProjectStepData(
    project: ProjectModel, stepNumber: Int, stepName: String, stepDesc: String, imageUrl: String?
  ) async {
    do {
      let step = ProjectStepModel(
        id: NSUUID().uuidString,
        projectId: project.id,
        stepNumber: stepNumber,
        stepName: stepName,
        stepDesc: stepDesc,
        stepImageUrl: imageUrl,
        isCompleted: false
      )
      let encodedStep = try Firestore.Encoder().encode(step)
      try await projectDB.document(project.id).collection("steps").document(step.id).setData(
        encodedStep)
    } catch {
      print(
        "DEBUG: Failed to upload step data to database with error \(error.localizedDescription)")
    }
  }

  static func uploadPostedProjectStepData(
    projectId: String, stepNumber: Int, stepName: String, stepDesc: String, imageUrl: String?
  ) async {
    do {
      let step = ProjectStepModel(
        id: NSUUID().uuidString,
        projectId: projectId,
        stepNumber: stepNumber,
        stepName: stepName,
        stepDesc: stepDesc,
        stepImageUrl: imageUrl,
        isCompleted: false
      )
      let encodedStep = try Firestore.Encoder().encode(step)
      try await postedProjectDB.document(projectId).collection("steps").document(step.id).setData(
        encodedStep)
    } catch {
      print(
        "DEBUG: Failed to upload posted step data to database with error \(error.localizedDescription)"
      )
    }
  }

  static func updateProjectData(
    project: ProjectModel, uiImage: UIImage?, name: String, desc: String
  ) async throws {
    var data = [String: Any]()

    if let uiImage = uiImage {
      let imageUrl = try await ImageUploader.uploadImage(withData: uiImage)
      data["projectImageUrl"] = imageUrl
    }

    if !name.isEmpty && project.projectName != name {
      data["projectName"] = name
    }

    if !desc.isEmpty && project.projectDesc != desc {
      data["projectDesc"] = desc
    }

    if !data.isEmpty {
      do {
        try await projectDB.document(project.id).updateData(data)
      } catch {
        print(
          "DEBUG: Failed to update project data in database with error \(error.localizedDescription)"
        )
      }
    }
  }

  static func updateStepData(
    step: ProjectStepModel, uiImage: UIImage?, number: Int, name: String, desc: String
  ) async throws {
    var data = [String: Any]()

    if let uiImage = uiImage {
      let imageUrl = try await ImageUploader.uploadImage(withData: uiImage)
      data["stepImageUrl"] = imageUrl
    }

    if step.stepNumber != number {
      data["stepNumber"] = number
    }

    if !name.isEmpty && step.stepName != name {
      data["stepName"] = name
    }

    if !desc.isEmpty && step.stepDesc != desc {
      data["stepDesc"] = desc
    }

    if !data.isEmpty {
      do {
        try await projectDB.document(step.projectId).collection("steps").document(step.id)
          .updateData(data)
      } catch {
        print(
          "DEBUG: Failed to update step data in database with error \(error.localizedDescription)")
      }
    }
  }

  static func handleCompletion(step: ProjectStepModel) async throws {
    let snapshot = try await projectDB.document(step.projectId).collection("steps").document(
      step.id
    ).getDocument()
    var stepData = try snapshot.data(as: ProjectStepModel.self)
    stepData.isCompleted.toggle()

    let data: [String: Bool] = [
      "isCompleted": stepData.isCompleted
    ]

    do {
      try await projectDB.document(step.projectId).collection("steps").document(step.id).updateData(
        data)
    } catch {
      print(
        "DEBUG: Failed to handle completion in database with error \(error.localizedDescription)")
    }
  }

  static func importProjectToUserLibrary(post: PostModel, newOwner: UserModel)
    async throws
  {
    do {
      let originProject = try await fetchPostedProject(projectId: post.projectId)
      let originSteps = try await fetchPostedProjectStepData(project: originProject)

      var newProject = originProject
      newProject.id = NSUUID().uuidString
      newProject.ownerId = newOwner.id

      let encodedProject = try Firestore.Encoder().encode(newProject)
      try await projectDB.document(newProject.id).setData(encodedProject)

      for step in originSteps {
        if let imageUrl = step.stepImageUrl {
          await uploadProjectStepData(
            project: newProject,
            stepNumber: step.stepNumber,
            stepName: step.stepName,
            stepDesc: step.stepDesc,
            imageUrl: imageUrl
          )
        } else {
          await uploadProjectStepData(
            project: newProject,
            stepNumber: step.stepNumber,
            stepName: step.stepName,
            stepDesc: step.stepDesc,
            imageUrl: nil
          )
        }
      }
    } catch {
      print(
        "DEBUG: Failed to import project to users library with error \(error.localizedDescription)")
    }
  }

  static func calcCompletionRate(project: ProjectModel) async throws -> CGFloat {
    let steps = try await fetchProjectStepData(project: project)
    var completedSteps = 0
    if steps.count == 0 {
      return 0
    } else {
      for step in steps {
        if step.isCompleted {
          completedSteps += 1
        }
      }
      return (CGFloat(completedSteps) / CGFloat(steps.count)) * 100
    }
  }

  static func deleteProjectData(project: ProjectModel) async {
    do {
      let steps = try await fetchProjectStepData(project: project)
      for step in steps {
        await deleteStepData(step: step)
      }
      try await projectDB.document(project.id).delete()
    } catch {
      print(
        "DEBUG: Failed to delete project data from database with error \(error.localizedDescription)"
      )
    }
  }

  static func deleteStepData(step: ProjectStepModel) async {
    do {
      try await projectDB.document(step.projectId).collection("steps").document(step.id).delete()
    } catch {
      print(
        "DEBUG: Failed to delete step data from database with error \(error.localizedDescription)")
    }
  }

  /*
   Sorting algorithm for steps
   */
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
