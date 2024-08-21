//
//  ImageUploader.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import FirebaseStorage
import Foundation
import PhotosUI

struct ImageUploader {
  static func uploadImage(withData image: UIImage) async throws -> String? {
    guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
    let fileName = NSUUID().uuidString
    let fileRef = Storage.storage().reference().child("/images/\(fileName)")

    do {
      let _ = try await fileRef.putDataAsync(imageData)
      let url = try await fileRef.downloadURL()
      return url.absoluteString
    } catch {
      print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
      return nil
    }
  }

  static func uploadImages(withData images: [UIImage]) async throws -> [String] {
    var uploadedURLs = [String]()

    for image in images {
      if let url = try await uploadImage(withData: image) {
        uploadedURLs.append(url)
      }
    }

    return uploadedURLs
  }
}
