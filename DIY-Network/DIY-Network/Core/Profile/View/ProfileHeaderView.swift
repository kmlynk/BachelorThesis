//
//  ProfileHeaderView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 01.07.24.
//

import SwiftUI

struct ProfileHeaderView: View {
  let user: UserModel

  var body: some View {
    VStack(spacing: 10) {
      HStack {
        CircularProfileImageView(size: 80, imageUrl: user.profileImageUrl ?? "")
      }
      .padding(.top, 10)

      VStack(spacing: 5) {
        if let fullname = user.fullname {
          Text(fullname)
            .font(.footnote)
            .fontWeight(.semibold)
        }

        if let bio = user.bio {
          Text(bio)
            .font(.footnote)
        }
      }
      .frame(maxWidth: .infinity)
      .multilineTextAlignment(.center)
      .padding(.horizontal)
    }
  }
}

#Preview{
  ProfileHeaderView(user: UserModel.MOCK_USERS[0])
}
