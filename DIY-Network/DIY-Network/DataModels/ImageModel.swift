//
//  ImageModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import Foundation

// This class is only for Development/Debug
struct ImageModel: Identifiable, Decodable {
  let imageUrl: String
  var id: String {
    return NSUUID().uuidString
  }
}
