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

  var body: some View {
    ScrollView {
      VStack {
        ProjectHeaderView(project: project)

        ProjectStepView(project: project)

        VStack {
          NavigationLink {
            AddProjectStepView(user: user, project: project)
          } label: {
            VStack(spacing: 5) {
              Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 30, height: 30)

              Text("Add a Step")
                .font(.callout)
                .fontWeight(.semibold)
            }
            .foregroundColor(Color.blue)
          }
        }
        .padding(.top, 5)
      }
    }
    .navigationTitle(project.projectName)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          // Edit Project
        } label: {
          Image(systemName: "pencil")
        }
      }
    }
  }
}

#Preview{
  ProjectView(user: UserModel.MOCK_USERS[0], project: ProjectModel.MOCK_PROJECTS[0])
}
