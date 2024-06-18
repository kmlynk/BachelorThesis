//
//  LibraryView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct LibraryView: View {
  let project: ProjectModel
  @State private var showCreateProject = false

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack {
          NavigationLink(value: project) {
            LibraryCell(project: project)
          }
          .foregroundColor(Color.primary)
        }
        .padding(.top, 20)
      }
      .navigationDestination(
        for: ProjectModel.self,
        destination: { project in
          ProjectView(project: project)
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
        CreateProjectView()
      }
    }
  }
}

#Preview{
  LibraryView(project: ProjectModel.MOCK_PROJECTS[0])
}
