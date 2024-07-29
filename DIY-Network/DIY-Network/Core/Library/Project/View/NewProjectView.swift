//
//  ProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 29.07.24.
//

import SwiftUI

struct NewProjectView: View {
  @StateObject var viewModel: ProjectViewModel
  @State private var showCreateStep = false
  @State private var showProgress = false

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: ProjectViewModel(project: project))
  }

  var body: some View {
    if showProgress {
      ProgressView("Loading...")
    } else if viewModel.steps.count < 1 {
      VStack(alignment: .center) {
        VStack(spacing: 8) {
          Text("This project has no steps at the moment")
            .font(.title3)
            .fontWeight(.bold)
          Text("Create a step")
            .font(.title3)
        }
        .foregroundColor(Color.gray)
      }
    } else {
      ScrollView {
        VStack {
          ProjectHeaderView(project: viewModel.project)

          LazyVStack {
            ForEach(viewModel.steps) { step in
              StepCell(step: step)
            }
          }
        }
      }
      .navigationTitle(viewModel.project.projectName)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            showCreateStep.toggle()
          } label: {
            Image(systemName: "plus")
              .imageScale(.large)
              .foregroundColor(Color.primary)
          }
        }
      }
      .scrollIndicators(.never)
      .refreshable {
        Task { try await viewModel.getProjectSteps() }
      }
      .fullScreenCover(
        isPresented: $showCreateStep,
        onDismiss: {
          Task {
            showProgress.toggle()
            try await viewModel.getProjectSteps()
            showProgress.toggle()
          }
        }
      ) {
        AddProjectStepView(project: viewModel.project)
      }
    }
  }
}

#Preview{
  NewProjectView(project: ProjectModel.MOCK_PROJECTS[0])
}
