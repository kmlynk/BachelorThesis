//
//  EditProfileViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Firebase
import Foundation
import PhotosUI
import SwiftUI

@MainActor
class EditProfileViewModel: ObservableObject {
  @Published var user: UserModel
  @Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
  }

  @Published var profileImage: Image?
  @Published var fullname = ""
  @Published var bio = ""

  private var uiImage: UIImage?

  init(user: UserModel) {
    self.user = user

    if let fullname = user.fullname {
      self.fullname = fullname
    }

    if let bio = user.bio {
      self.bio = bio
    }
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }
    print("DEBUG: Image data is \(data)")

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.profileImage = Image(uiImage: uiImage)
  }

  func updateUser() async throws {
    try await UserService.updateUserData(
      user: user,
      uiImage: uiImage,
      fullname: fullname,
      bio: bio
    )
  }
}
