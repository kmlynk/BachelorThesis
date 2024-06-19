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
      Text(project.projectName)
      
      Text(project.projectDesc)
      
      if let steps = project.steps {
        ForEach(steps) { step in
          Text(step.name)
        }
      }
    }
}

#Preview {
  ProjectView(project: ProjectModel.MOCK_PROJECTS[0])
}
