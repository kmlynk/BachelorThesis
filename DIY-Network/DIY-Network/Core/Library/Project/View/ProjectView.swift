//
//  ProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct ProjectView: View {
  let user: UserModel
  let project: ProjectModel
  @State private var showAddStep = false

  var body: some View {
    ScrollView {
      VStack {
        ProjectHeaderView(project: project)

        ProjectStepView(project: project)
          .padding(.horizontal)
      }
    }
    .scrollIndicators(.never)
    .navigationTitle(project.projectName)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem {
        Button {
          showAddStep.toggle()
        } label: {
          Image(systemName: "plus")
            .imageScale(.large)
            .foregroundColor(Color.primary)
        }
      }
    }
    .fullScreenCover(isPresented: $showAddStep) {
      AddProjectStepView(project: project)
    }
  }
}

#Preview{
  ProjectView(user: UserModel.MOCK_USERS[0], project: ProjectModel.MOCK_PROJECTS[0])
}
