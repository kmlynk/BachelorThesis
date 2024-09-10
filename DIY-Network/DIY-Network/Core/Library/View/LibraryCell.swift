//
//  LibraryCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct LibraryCell: View {
  @Environment(\.colorScheme) var currentMode
  @ObservedObject var viewModel: LibraryCellViewModel
  @State private var showSheet = false
  @State private var showProgress = false
  @State private var perc: CGFloat = 0

  var body: some View {
    if showProgress {
      ProgressView("Loading...")
    } else {
      GroupBox {
        VStack {
          HStack {
            Spacer()

            Button {
              print("DEBUG: Show bottom sheet")
              showSheet.toggle()
            } label: {
              Image(systemName: "ellipsis")
                .imageScale(.large)
            }
            .padding(.trailing, 5)
          }

          HStack {
            ProjectImageView(
              width: 100,
              height: 100,
              imageUrl: viewModel.project.projectImageUrl ?? ""
            )

            Text(viewModel.project.projectName)
              .multilineTextAlignment(.leading)
              .fontWeight(.heavy)

            Spacer()
          }

          Divider()

          VStack {
            ProgressBar(
              width: 300, height: 20, percent: perc,
              color1: Color.secondary, color2: Color.primary
            )
            .animation(.bouncy)
            .onAppear(perform: {
              Task {
                perc = try await LibraryService.calcCompletionRate(project: viewModel.project)
              }
            })

            Text("\(Int(perc))% Completed")
              .font(.headline)
          }
        }
      }
      .cornerRadius(12)
      .shadow(color: Color.secondary, radius: 2)
      .frame(width: UIScreen.main.bounds.width - 30)
      .sheet(
        isPresented: $showSheet,
        onDismiss: {
          Task {
            showProgress.toggle()
            try await viewModel.fetchProject()
            showProgress.toggle()
          }
        }
      ) {
        ProjectBottomSheet(project: viewModel.project)
          .presentationDetents([.height(150)])
      }
    }
  }
}

struct ProjectBottomSheet: View {
  @Environment(\.dismiss) var dismiss
  var project: ProjectModel
  @State private var showEditView = false
  @State private var showProgressView = false

  var body: some View {
    if !showProgressView {
      List {
        Button {
          showEditView.toggle()
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "pencil")
              .imageScale(.large)
            Text("Edit Project")
          }
          .foregroundColor(Color.blue)
        }

        Button {
          Task {
            showProgressView.toggle()
            await LibraryService.deleteProjectData(project: project)
            dismiss()
          }
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "trash.fill")
              .imageScale(.large)
            Text("Delete Project")
          }
          .foregroundColor(Color.red)
        }
      }
      .fullScreenCover(
        isPresented: $showEditView,
        onDismiss: {
          dismiss()
        }
      ) {
        EditProjectView(project: project)
      }
    } else {
      ProgressView("Deleting Project...")
    }
  }
}

#Preview{
  LibraryCell(viewModel: LibraryCellViewModel(project: ProjectModel.MOCK_PROJECTS[0]))
}
