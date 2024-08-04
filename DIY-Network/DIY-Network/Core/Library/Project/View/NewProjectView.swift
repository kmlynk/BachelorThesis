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
          Text("Project has no steps at the moment")
            .fontWeight(.bold)
            .foregroundColor(Color.gray)
          Button {
            showCreateStep.toggle()
          } label: {
            VStack(spacing: 8) {
              Text("Create a step")
              Image(systemName: "plus.circle")
                .imageScale(.large)
            }
            .foregroundColor(Color.blue)
          }
        }
      }
      .font(.title3)
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
    } else {
      ScrollView {
        VStack {
          ProjectHeaderView(project: viewModel.project)

          LazyVStack {
            ForEach(viewModel.steps) { step in
              StepCell(step: step, editable: true)
            }
          }

          VStack {
            Text("Pull to refresh")
              .font(.caption)
              .fontWeight(.thin)
            Image(systemName: "arrow.down")
              .imageScale(.small)
          }
          .padding(.top, 48)
          .foregroundColor(Color.gray)
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
