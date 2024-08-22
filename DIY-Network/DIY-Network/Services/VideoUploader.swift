//
//  VideoUploader.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 22.08.24.
//

import FirebaseStorage
import Foundation

struct VideoUploader {
  static func uploadVideo(withData videoData: Data) async throws -> String? {
    let fileName = NSUUID().uuidString
    let ref = Storage.storage().reference().child("/videos/\(fileName)")

    let metadata = StorageMetadata()
    metadata.contentType = "video/quicktime"

    do {
      let _ = try await ref.putDataAsync(videoData, metadata: metadata)
      let url = try await ref.downloadURL()
      return url.absoluteString
    } catch {
      print("DEBUG: Failed to upload video with error \(error.localizedDescription)")
      return nil
    }
  }
}
