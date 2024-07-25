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
}
