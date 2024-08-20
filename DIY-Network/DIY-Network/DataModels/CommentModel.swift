//
//  CommentModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.08.24.
//

import Firebase
import Foundation

struct CommentModel: Identifiable, Hashable, Codable {
  let id: String
  let userName: String
  let userPic: String?
  let text: String
  let timestamp: Timestamp
}
