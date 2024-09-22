//
//  DocDownloader.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 12.09.24.
//

import FirebaseStorage
import Foundation

struct DocDownloader {
  static func download(from url: URL) async throws -> Data? {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
}
