//
//  ProjectDetailView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 04.08.24.
//

import SwiftUI

struct ProjectDetailView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: ProjectDetailViewModel
  @State private var showProgress = false
  @State private var showAlert = false

  var body: some View {
    if !showProgress {
      NavigationStack {
        ScrollView {
          ProjectHeaderView(project: viewModel.project)
          
          LazyVStack {
            ForEach(viewModel.steps) { step in
              StepCell(step: step, editable: false)
            }
          }
        }
        .navigationTitle("Project Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              Task {
                showProgress.toggle()
                await viewModel.importProject()
                showProgress.toggle()
                showAlert.toggle()
              }
            } label: {
              Image(systemName: "folder.badge.plus")
                .imageScale(.large)
                .foregroundColor(Color.primary)
            }
          }
        }
      }
      .alert(isPresented: $showAlert) {
        Alert(title: Text("Project is successfully imported"))
      }
    } else {
      ProgressView("Importing...")
    }
  }
}

#Preview{
  ProjectDetailView(
    viewModel: ProjectDetailViewModel(
      user: UserModel.MOCK_USERS[0], id: PostModel.MOCK_POSTS[0].projectId))
}
