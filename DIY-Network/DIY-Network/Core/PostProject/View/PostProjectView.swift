//
//  PostProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import SwiftUI

struct PostProjectView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel: PostProjectViewModel
  @State private var showSheet = false
  @State private var showCreateProject = false
  @State private var showProgress = false

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: PostProjectViewModel(user: user))
  }

  var body: some View {
    NavigationStack {
      if showProgress {
        ProgressView("Loading...")
      } else if viewModel.projects.count < 1 {
        VStack(alignment: .center) {
          VStack(spacing: 8) {
            Text("You have no projects at the moment")
              .fontWeight(.bold)
              .foregroundColor(Color.gray)
            Button {
              showCreateProject.toggle()
            } label: {
              VStack(spacing: 8) {
                Text("Create a project")
                Image(systemName: "plus.circle")
                  .imageScale(.large)
              }
              .foregroundColor(Color.blue)
            }
          }
        }
        .font(.title3)
        .onAppear(perform: {
          Task {
            try await viewModel.fetchUserProjects()
          }
        })
        .fullScreenCover(
          isPresented: $showCreateProject,
          onDismiss: {
            Task {
              showProgress.toggle()
              try await viewModel.fetchUserProjects()
              showProgress.toggle()
            }
          }
        ) {
          CreateProjectView(user: authViewModel.currentUser!)
        }
        .navigationTitle("Choose a project to share")
        .navigationBarTitleDisplayMode(.inline)
      } else {
        ScrollView {
          LazyVStack {
            ForEach(viewModel.projects) { project in
              PostProjectCell(project: project)
            }
          }
        }
        .onAppear(perform: {
          Task { try await viewModel.fetchUserProjects() }
        })
        .scrollIndicators(.never)
        .navigationTitle("Choose a project to share")
        .navigationBarTitleDisplayMode(.inline)
      }
    }
  }
}

#Preview{
  PostProjectView(user: UserModel.MOCK_USERS[0])
}
