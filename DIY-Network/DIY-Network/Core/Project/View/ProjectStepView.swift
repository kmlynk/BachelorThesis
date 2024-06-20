//
//  ProjectStepView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import SwiftUI

struct ProjectStepView: View {
  @StateObject var viewModel: ProjectStepViewModel

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: ProjectStepViewModel(project: project))
  }

  var body: some View {
    VStack {
      ForEach(viewModel.sortedSteps) { step in
        Text("Name: \(step.stepName)")

        Text("Decription: \(step.stepDesc)")
      }
    }
  }
}

#Preview{
  ProjectStepView(project: ProjectModel.MOCK_PROJECTS[0])
}
