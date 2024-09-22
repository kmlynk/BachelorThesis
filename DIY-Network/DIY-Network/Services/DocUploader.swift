//
//  DocUploader.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 11.09.24.
//

import FirebaseStorage
import Foundation

struct DocUploader {
  static func uploadDocument(withURL docUrl: URL) async throws -> String? {
    let fileName = NSUUID().uuidString
    let ref = Storage.storage().reference().child("/docs/\(fileName)")
    
    do {
      let _ = try await ref.putFileAsync(from: docUrl)
      let url = try await ref.downloadURL()
      return url.absoluteString
    } catch {
      print("DEBUG: Failed to upload document with error \(error.localizedDescription)")
      return nil
    }
  }
}
