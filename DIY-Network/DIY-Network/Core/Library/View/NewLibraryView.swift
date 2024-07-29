//
//  NewLibraryView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 29.07.24.
//

import SwiftUI

struct NewLibraryView: View {
  @StateObject var viewModel: LibraryViewModel
  @State private var showCreateProject = false
  @State private var showProgress = false

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: LibraryViewModel(user: user))
  }

  var body: some View {
    @State var projects = viewModel.projects

    NavigationStack {
      if showProgress {
        ProgressView("Loading...")
      } else if projects.count < 1 {
        VStack(alignment: .center) {
          VStack(spacing: 8) {
            Text("You have no projects at the moment")
              .font(.title3)
              .fontWeight(.bold)
            Text("Create a project")
              .font(.title3)
          }
          .foregroundColor(Color.gray)
        }
      } else {
        ScrollView {
          LazyVStack {
            ForEach(projects) { project in
              NavigationLink(value: project) {
                LibraryCell(viewModel: LibraryCellViewModel(project: project))
              }
            }
            .foregroundColor(Color.primary)
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
        .navigationDestination(
          for: ProjectModel.self,
          destination: { project in
            NewProjectView(project: project)
          }
        )
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem {
            Button {
              showCreateProject.toggle()
              print("DEBUG: Create New Project")
            } label: {
              Image(systemName: "plus")
                .imageScale(.large)
            }
          }
        }
        .scrollIndicators(.never)
        .refreshable {
          Task { try await viewModel.getUsersProjects() }
        }
        .fullScreenCover(
          isPresented: $showCreateProject,
          onDismiss: {
            Task {
              showProgress.toggle()
              try await viewModel.getUsersProjects()
              showProgress.toggle()
            }
          }
        ) {
          CreateProjectView(user: viewModel.user)
        }
      }
    }
  }
}

#Preview{
  NewLibraryView(user: UserModel.MOCK_USERS[0])
}
