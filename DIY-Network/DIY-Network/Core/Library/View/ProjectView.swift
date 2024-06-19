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

      if let steps = project.steps {
        ForEach(steps) { step in
          Text(step.name)
        }
      }
    }
    .navigationTitle(project.projectName)
  }
}

#Preview{
  ProjectView(project: ProjectModel.MOCK_PROJECTS[0])
}
