//
//  StepCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 25.06.24.
//

import SwiftUI

struct StepCell: View {
  @Environment(\.colorScheme) var currentMode
  @StateObject var viewModel: StepCellViewModel
  let editable: Bool
  @State private var showSheet = false
  @State private var showProgress = false

  init(step: ProjectStepModel, editable: Bool) {
    self._viewModel = StateObject(wrappedValue: StepCellViewModel(step: step))
    self.editable = editable
  }

  var body: some View {
    ZStack {
      ExpandableView(
        thumbnail: ThumbnailView(content: {
          VStack {
            if editable {
              VStack {
                Toggle(isOn: $viewModel.step.isCompleted) {
                  Text("Step Number \(viewModel.step.stepNumber)")
                }
                .toggleStyle(CheckboxToggleStyle())
                .padding(.horizontal)
                .onChange(of: viewModel.step.isCompleted) { _ in
                  viewModel.toggleComplete()
                }
              }
              .padding(.bottom, 5)
            } else {
              Text("Step Number \(viewModel.step.stepNumber)")
            }

            ProjectDividerView(minusWidth: 60, height: 0.8)

            HStack {
              if let imageUrl = viewModel.step.stepImageUrl {
                ProjectImageView(width: 100, height: 80, imageUrl: imageUrl)
              }

              Text(viewModel.step.stepName)
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
          if showProgress {
            ProgressView("Loading...")
          } else {
            VStack {
              if editable {
                HStack {
                  Text("\(viewModel.step.stepNumber). \(viewModel.step.stepName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .lineLimit(2)

                  Button {
                    showSheet.toggle()
                  } label: {
                    Image(systemName: "ellipsis")
                      .imageScale(.large)
                  }
                }
              } else {
                Text("\(viewModel.step.stepNumber). \(viewModel.step.stepName)")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .font(.footnote)
                  .lineLimit(2)
              }

              ProjectDividerView(minusWidth: 60, height: 0.8)

              VStack {
                if let imageUrl = viewModel.step.stepImageUrl {
                  ProjectImageView(width: 200, height: 260, imageUrl: imageUrl)
                    .padding(.vertical)
                }

                Text(viewModel.step.stepDesc)
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
            .sheet(
              isPresented: $showSheet,
              onDismiss: {
                Task {
                  showProgress.toggle()
                  try await viewModel.getStep()
                  showProgress.toggle()
                }
              }
            ) {
              StepBottomSheet(step: viewModel.step)
                .presentationDetents([.height(150)])
            }
          }
        }),
        color: currentMode == .dark ? Color.black : Color.white
      )
    }
  }
}

// TODO: Implement ObservedObject StepCellViewModel
struct StepBottomSheet: View {
  @Environment(\.dismiss) var dismiss
  var step: ProjectStepModel
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
            Text("Edit Step")
          }
          .foregroundColor(Color.blue)
        }

        Button {
          Task {
            print("DEBUG: Deleting Step...")
            print("DEBUG: Step Name: \(step.stepName)")
            print("DEBUG: Project ID: \(step.projectId)")
            showProgressView.toggle()
            await LibraryService.deleteStepData(step: step)
            dismiss()
          }
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "trash.fill")
              .imageScale(.large)
            Text("Delete Step")
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
        EditStepView(step: step)
      }
    } else {
      ProgressView("Deleting Step...")
    }
  }
}

#Preview{
  StepCell(step: ProjectStepModel.MOCK_STEPS[0], editable: false)
}
