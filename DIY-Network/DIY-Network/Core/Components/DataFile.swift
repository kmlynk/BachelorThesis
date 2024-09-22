//
//  DataFile.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 12.09.24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DataFile: FileDocument {
  static var readableContentTypes: [UTType] { [.pdf] }

  var data: Data

  init(data: Data) {
    self.data = data
  }

  init(configuration: ReadConfiguration) throws {
    self.data = configuration.file.regularFileContents ?? Data()
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    return FileWrapper(regularFileWithContents: data)
  }
}
