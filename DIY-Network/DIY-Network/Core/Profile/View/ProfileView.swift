//
//  ProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct ProfileView: View {
  let user: UserModel

  var body: some View {
    ScrollView {
      VStack {
        Spacer()
        
        // Profile Header View
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
        
        VStack {
          Text("...POSTS...")
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
