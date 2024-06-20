//
//  LibraryView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct LibraryView: View {
  let user: UserModel
  @State private var showCreateProject = false

  var body: some View {
    NavigationStack {
      LibraryListView(user: user)
        .navigationDestination(
          for: ProjectModel.self,
          destination: { project in
            ProjectView(user: user, project: project)
          }
        )
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              showCreateProject.toggle()
              print("DEBUG: Create New Project")
            } label: {
              Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(Color.primary)
            }
          }
        }
        .fullScreenCover(isPresented: $showCreateProject) {
          CreateProjectView(user: user)
        }
    }
  }
}

#Preview{
  LibraryView(user: UserModel.MOCK_USERS[0])
}
