//
//  ProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 29.07.24.
//

import SwiftUI

struct NewProjectView: View {
  @Environment(\.dismiss) var dismiss
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
      ScrollView {
        VStack {
          ProjectHeaderView(project: viewModel.project)

          VStack(spacing: 16) {
            Text("Project has no steps at the moment")
              .fontWeight(.bold)
              .foregroundColor(Color.gray)
            Button {
              showCreateStep.toggle()
            } label: {
              VStack(spacing: 4) {
                Image(systemName: "plus.circle")
                  .imageScale(.large)
                Text("Create a step")
              }
              .foregroundColor(Color.blue)
            }
          }
          .font(.title3)
          .padding(.top, 32)

          Spacer()
        }
      }
      .navigationTitle("Project")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "chevron.left")
              .imageScale(.large)
              .foregroundColor(Color.primary)
          }
        }
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
    } else {
      ScrollView {
        VStack {
          ProjectHeaderView(project: viewModel.project)

          Divider()

          LazyVStack {
            ForEach(viewModel.steps) { step in
              NewStepCell(step: step, editable: true)
            }
          }

          VStack {
            Text("Pull to refresh")
              .font(.caption)
              .fontWeight(.thin)
            Image(systemName: "arrow.down")
              .imageScale(.small)
          }
          .padding(.top, 32)
          .foregroundColor(Color.gray)
        }
      }
      .navigationTitle("Project")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "chevron.left")
              .imageScale(.large)
              .foregroundColor(Color.primary)
          }
        }

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
