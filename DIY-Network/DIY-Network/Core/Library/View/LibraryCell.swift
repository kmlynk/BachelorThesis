//
//  LibraryCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct LibraryCell: View {
  @Environment(\.colorScheme) var currentMode
  let project: ProjectModel
  @State private var showSheet = false

  var body: some View {
    HStack {
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
            imageUrl: project.projectImageUrl ?? ""
          )

          Text(project.projectName)
            .multilineTextAlignment(.leading)
            .fontWeight(.heavy)

          Spacer()
        }
      }
    }
    .padding()
    .background(currentMode == .dark ? Color.black : Color.white)
    .cornerRadius(20)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
    .padding(.horizontal)
    .padding(.top)
    .sheet(isPresented: $showSheet) {
      ProjectBottomSheet(project: project)
        .presentationDetents([.height(150)])
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
      .fullScreenCover(isPresented: $showEditView) {
        EditProjectView(project: project)
      }
    } else {
      ProgressView("Deleting Project...")
    }
  }
}

#Preview{
  LibraryCell(project: ProjectModel.MOCK_PROJECTS[0])
}
