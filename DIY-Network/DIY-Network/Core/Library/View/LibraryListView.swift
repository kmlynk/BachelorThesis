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
    if viewModel.projects.count == 0 {
      GeometryReader { geometry in
        ScrollView {
          VStack(alignment: .center) {
            VStack(spacing: 8) {
              Text("You have no projects at the moment")
                .font(.title3)
                .fontWeight(.bold)
              Text("Create a project")
                .font(.title3)
            }

            VStack {
              Text("Pull to refresh")
                .font(.caption)
                .fontWeight(.thin)
              Image(systemName: "arrow.down")
                .imageScale(.small)
            }
            .padding(.top, 48)
            .foregroundColor(Color.gray)
          }
          .frame(width: geometry.size.width)
          .frame(minHeight: geometry.size.height)
        }
        .refreshable {
          Task { try await viewModel.fetchUserProjects() }
        }
      }
    } else {
      ScrollView {
        LazyVStack {
          ForEach(viewModel.projects) { project in
            NavigationLink(value: project) {
              LibraryCell(project: project)
            }
            .foregroundColor(Color.primary)
          }
        }
        .padding(.top, 16)

        VStack {
          Text("Pull to refresh")
            .font(.caption)
            .fontWeight(.thin)
          Image(systemName: "arrow.down")
            .imageScale(.small)
        }
        .padding(.top, 48)
        .foregroundColor(Color.gray)
      }
      .scrollIndicators(.never)
      .refreshable {
        Task { try await viewModel.fetchUserProjects() }
      }
    }
  }
}

#Preview{
  LibraryListView(user: UserModel.MOCK_USERS[0])
}
