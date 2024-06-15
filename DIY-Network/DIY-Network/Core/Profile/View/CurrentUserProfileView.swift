//
//  CurrentUserProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import SwiftUI

struct CurrentUserProfileView: View {
  @EnvironmentObject var authViewModel: AuthViewModel

  var body: some View {
    if let user = authViewModel.currentUser {
      NavigationStack {
        VStack(spacing: 10) {
          Text("Username: \(user.username)")

          Text("E-Mail: \(user.email)")

          Text("ID: \(user.id)")
            .font(.footnote)

          CircularProfileImageView(size: 150, imageUrl: user.profileImageUrl ?? "")
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              authViewModel.signOut()
            } label: {
              Image(systemName: "gearshape.fill")
                .foregroundColor(Color.primary)
            }
          }
        }
      }
    } else {
      NavigationStack {
        VStack {
          Text("OPPSS!!")
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              authViewModel.signOut()
            } label: {
              Image(systemName: "gearshape.fill")
                .foregroundColor(Color.primary)
            }
          }
        }

      }
    }
  }
}

#Preview{
  CurrentUserProfileView()
}
