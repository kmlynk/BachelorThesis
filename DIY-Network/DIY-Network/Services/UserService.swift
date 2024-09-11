//
//  UserService.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 25.07.24.
//

import Firebase
import Foundation

struct UserService {
  private static let db = Firestore.firestore().collection("users")

  static func fetchUser(withId id: String) async throws -> UserModel {
    let snapshot = try await db.document(id).getDocument()
    return try snapshot.data(as: UserModel.self)
  }

  static func fetchAllUsers() async throws -> [UserModel] {
    let snapshot = try await db.getDocuments()

    return snapshot.documents.compactMap({ try? $0.data(as: UserModel.self) })
  }

  static func updateUserData(user: UserModel, uiImage: UIImage?, fullname: String, bio: String)
    async throws
  {
    var data = [String: Any]()

    if let uiImage = uiImage {
      let imageUrl = try await ImageUploader.uploadImage(withData: uiImage)
      data["profileImageUrl"] = imageUrl
    }

    data["fullname"] = fullname
    data["bio"] = bio

    if !data.isEmpty {
      try await Firestore.firestore().collection("users").document(user.id).updateData(data)
    }
  }
  
  static func deleteUserData(user: UserModel) async throws {
    try await db.document(user.id).delete()
  }

  static func isUsernameUnique(username: String) async throws -> Bool {
    let snapshot = try await db.whereField("username", isEqualTo: username).getDocuments()

    if !snapshot.isEmpty {
      return false
    }
    return true
  }
}
