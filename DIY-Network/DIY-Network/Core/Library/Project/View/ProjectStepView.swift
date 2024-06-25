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
    LazyVStack {
      ForEach(viewModel.sortedSteps) { step in
        ProjectStepCell(step: step)
      }
    }
    .onAppear(perform: {
      Task {
        try await viewModel.fetchProjectSteps()
      }
    })
  }
}

#Preview{
  ProjectStepView(project: ProjectModel.MOCK_PROJECTS[0])
}
