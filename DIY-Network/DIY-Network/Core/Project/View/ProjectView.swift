//
//  ProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct ProjectView: View {
  let user: UserModel
  let project: ProjectModel
  @State private var showSheet = false

  var body: some View {
    ScrollView {
      VStack {
        ProjectHeaderView(project: project)

        ProjectStepView(project: project)

        VStack {
          NavigationLink {
            AddProjectStepView(user: user, project: project)
          } label: {
            VStack(spacing: 5) {
              Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 30, height: 30)

              Text("Add a Step")
                .font(.callout)
                .fontWeight(.semibold)
            }
            .foregroundColor(Color.blue)
          }
        }
        .padding(.top, 5)
      }
    }
    .scrollIndicators(.never)
    .sheet(isPresented: $showSheet) {
      ProjectBottomSheet(project: project)
        .presentationDetents([.height(150)])
    }
    .navigationTitle(project.projectName)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          showSheet.toggle()
        } label: {
          Image(systemName: "ellipsis")
            .imageScale(.large)
            .foregroundColor(Color.blue)
        }
      }
    }
  }
}

struct ProjectBottomSheet: View {
  @Environment(\.dismiss) var dismiss
  var project: ProjectModel
  @State private var showEditView = false

  var body: some View {
    List {
      Button {
        showEditView.toggle()
      } label: {
        HStack(spacing: 10) {
          Image(systemName: "pencil")
          Text("Edit Project")
        }
      }

      Button {
        print("DEBUG: Delete Project")
        dismiss()
      } label: {
        HStack(spacing: 10) {
          Image(systemName: "trash.fill")
          Text("Delete Project")
        }
        .foregroundColor(Color.red)
      }
    }
    .fullScreenCover(isPresented: $showEditView) {
      EditProjectView(project: project)
    }
  }
}

#Preview{
  ProjectView(user: UserModel.MOCK_USERS[0], project: ProjectModel.MOCK_PROJECTS[0])
}
