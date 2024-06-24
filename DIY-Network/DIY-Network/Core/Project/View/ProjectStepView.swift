//
//  ProjectStepView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import SwiftUI

struct ProjectStepView: View {
  @Environment(\.colorScheme) var currentMode
  @StateObject var viewModel: ProjectStepViewModel
  @State private var showSheet = false

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: ProjectStepViewModel(project: project))
  }

  var body: some View {
    LazyVStack {
      ForEach(viewModel.sortedSteps) { step in
        ExpandableView(
          thumbnail: ThumbnailView(content: {
            VStack {
              VStack {
                Text("Step Number \(step.stepNumber)")

                ProjectDividerView(minusWidth: 60, height: 0.8)
              }
              .padding(.bottom, 5)

              HStack {
                if let imageUrl = step.stepImageUrl {
                  ProjectImageView(width: 100, height: 80, imageUrl: imageUrl)

                  Spacer()
                }

                Text(step.stepName)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .font(.headline)
                  .fontWeight(.semibold)
                  .multilineTextAlignment(.leading)
              }
            }
            .padding()
            .background(currentMode == .dark ? Color.black : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.vertical, 5)
          }),
          expanded: ExpandedView(content: {
            VStack {
              HStack {
                Text("\(step.stepNumber). \(step.stepName)")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .font(.footnote)
                  .lineLimit(2)

                Button {
                  showSheet.toggle()
                } label: {
                  Image(systemName: "ellipsis")
                    .imageScale(.large)
                    .foregroundColor(Color.blue)
                }
              }

              ProjectDividerView(minusWidth: 60, height: 0.8)

              VStack {
                if let imageUrl = step.stepImageUrl {
                  ProjectImageView(width: 200, height: 260, imageUrl: imageUrl)
                    .padding(.vertical)
                }

                Text(step.stepDesc)
                  .font(.subheadline)
                  .fontWeight(.semibold)
                  .multilineTextAlignment(.leading)
              }
            }
            .padding()
            .background(currentMode == .dark ? Color.black : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.vertical, 5)
          }),
          color: currentMode == .dark ? Color.black : Color.white
        )
        .sheet(isPresented: $showSheet) {
          StepBottomSheet(step: step)
            .presentationDetents([.height(150)])
        }
      }
    }
    .onAppear(perform: {
      Task {
        try await viewModel.fetchProjectSteps()
      }
    })
  }
}

struct StepBottomSheet: View {
  @Environment(\.dismiss) var dismiss
  var step: ProjectStepModel
  @State private var showEditView = false

  var body: some View {
    List {
      Button {
        showEditView.toggle()
      } label: {
        HStack(spacing: 10) {
          Image(systemName: "pencil")
          Text("Edit Step")
        }
      }

      Button {
        print("DEBUG: Delete Step")
        dismiss()
      } label: {
        HStack(spacing: 10) {
          Image(systemName: "trash.fill")
          Text("Delete Step")
        }
        .foregroundColor(Color.red)
      }
    }
    .fullScreenCover(isPresented: $showEditView) {
      EditStepView()
    }
  }
}

#Preview{
  ProjectStepView(project: ProjectModel.MOCK_PROJECTS[0])
}
