//
//  UserModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import Firebase
import Foundation

struct UserModel: Identifiable, Hashable, Codable {
  let id: String
  let email: String
  var username: String
  var profileImageUrl: String?
  var fullname: String?
  var bio: String?
}

extension UserModel {
  static var MOCK_USERS: [UserModel] = [
    .init(
      id: "h9FV9ysmbOff2ZefQJEhjVs3yXi1",
      email: "admin@grr.la",
      username: "theAdmin",
      profileImageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2FA1664A74-6211-4E23-8BCD-E05C56AA0893?alt=media&token=ba395989-4edb-4210-8384-cd746eefbfd8",
      fullname: "Admin Adminoglu",
      bio: "Admin since 3 weeks"
    ),

    .init(
      id: "EVihsvJEqsNADP3bU0RnFXKtHwO2",
      email: "testerOne@grr.la",
      username: "testerOne",
      profileImageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2FBE1D068B-AA9F-4A65-A313-A1629C8C0B99?alt=media&token=d540d39e-e3dc-4898-bfce-35e0b7a4716b",
      fullname: "Tester One",
      bio: "This is the Tester One"
    ),
  ]
}
