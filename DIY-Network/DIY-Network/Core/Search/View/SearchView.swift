//
//  SearchView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct SearchView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel = SearchViewModel()
  @State private var searchTerm = ""

  var filteredUsers: [UserModel] {
    guard !searchTerm.isEmpty else { return viewModel.users }
    return viewModel.users.filter {
      $0.username.description.localizedStandardContains(searchTerm)
    }
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 15) {
          ForEach(filteredUsers, id: \.self) { user in
            HStack {
              NavigationLink(value: user) {
                CircularProfileImageView(size: 40, imageUrl: user.profileImageUrl ?? "")

                VStack(alignment: .leading) {
                  Text(user.username)
                    .fontWeight(.semibold)

                  if let fullname = user.fullname {
                    Text(fullname)
                  }
                }

                Spacer()
              }
            }
            .foregroundColor(Color.primary)
            .padding(.horizontal, 10)
          }
        }
        .padding(.top, 8)
        .searchable(text: $searchTerm, prompt: "Search for a username...")
      }
      .navigationDestination(
        for: UserModel.self,
        destination: { user in
          ProfileView(user: user)
        }
      )
      .navigationTitle("User Search")
      .navigationBarTitleDisplayMode(.automatic)
      .refreshable {
        try? await viewModel.fetchSearchUsers()
      }
    }
  }
}

#Preview{
  SearchView()
}
