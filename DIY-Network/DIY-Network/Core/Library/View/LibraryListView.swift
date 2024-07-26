//
//  LibraryListView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import SwiftUI

struct LibraryListView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel: LibraryListViewModel

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: LibraryListViewModel(user: user))
  }

  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(viewModel.projects) { project in
          NavigationLink(value: project) {
            LibraryCell(project: project)
          }
          .foregroundColor(Color.primary)
        }
      }
      .padding(.top, 20)
    }
    .scrollIndicators(.never)
    .refreshable {
      Task { try await viewModel.fetchUserProjects() }
    }
  }
}

#Preview{
  LibraryListView(user: UserModel.MOCK_USERS[0])
}
