//
//  ProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct ProjectView: View {
  let project: ProjectModel

  var body: some View {
    ScrollView {
      ProjectHeaderView(project: project)

      VStack(spacing: 15) {
        if let steps = project.steps {
          ForEach(steps) { step in
            Text(step.name)
          }
        }
      }
      .padding(.top, 10)
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
  ProjectView(project: ProjectModel.MOCK_PROJECTS[0])
}
