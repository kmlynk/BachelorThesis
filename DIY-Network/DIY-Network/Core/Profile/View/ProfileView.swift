//
//  ProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct ProfileView: View {
  let user: UserModel

  private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 5),
    .init(.flexible(), spacing: 5),
  ]

  var body: some View {
    ScrollView {
      VStack {
        Spacer()

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

        Divider()

        LazyVGrid(columns: gridItems, spacing: 5) {
          ForEach(0...3, id: \.self) { index in
            ProjectImageView(width: 190, height: 200, imageUrl: user.profileImageUrl ?? "")
          }
        }
        .padding(.top, 15)
      }
      .padding(.top, 20)
    }
    .navigationTitle(user.username)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview{
  ProfileView(user: UserModel.MOCK_USERS[0])
}
