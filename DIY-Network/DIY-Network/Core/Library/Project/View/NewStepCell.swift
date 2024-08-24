//
//  NewStepCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 06.08.24.
//

import SwiftUI

struct NewStepCell: View {
  @StateObject var viewModel: StepCellViewModel
  let editable: Bool
  @State private var isExpanded = false
  @State private var showSheet = false
  @State private var showProgress = false

  init(step: ProjectStepModel, editable: Bool) {
    self._viewModel = StateObject(wrappedValue: StepCellViewModel(step: step))
    self.editable = editable
  }

  var body: some View {
    VStack {
      if !isExpanded {
        GroupBox {
          VStack(alignment: .leading, spacing: 16) {
            HStack {
              if editable {
                Toggle(isOn: $viewModel.step.isCompleted.animation(.spring)) {
                  Text("Step Number \(viewModel.step.stepNumber)")
                    .fontWeight(.semibold)
                }
                .toggleStyle(CheckboxToggleStyle())
                .onChange(of: viewModel.step.isCompleted) { _ in
                  viewModel.toggleComplete()
                }
              } else {
                Text("Step Number \(viewModel.step.stepNumber)")
                  .fontWeight(.semibold)
              }
            }

            Divider()

            HStack {
              if let imageUrl = viewModel.step.stepImageUrls?.first {
                ProjectImageView(width: 100, height: 80, imageUrl: imageUrl)
              }

              Text(viewModel.step.stepName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            }
          }
        }
        .shadow(color: Color.secondary, radius: 2)
        .padding(.horizontal)
      } else {
        GroupBox {
          VStack(spacing: 16) {
            HStack {
              if editable {
                Text("\(viewModel.step.stepNumber). \(viewModel.step.stepName)")
                  .font(.footnote)
                  .lineLimit(2)

                Spacer()

                Button {
                  showSheet.toggle()
                } label: {
                  Image(systemName: "ellipsis")
                    .imageScale(.large)
                }
              } else {
                Text("\(viewModel.step.stepNumber). \(viewModel.step.stepName)")
                  .font(.footnote)
                  .lineLimit(2)
              }
            }

            Divider()

            VStack {
              if let imageUrls = viewModel.step.stepImageUrls {
                ScrollView(.horizontal) {
                  HStack {
                    ForEach(imageUrls, id: \.self) { imageUrl in
                      ProjectImageView(width: 320, height: 250, imageUrl: imageUrl)
                    }
                  }
                }
              }

              Text(viewModel.step.stepDesc)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            }
          }
        }
        .shadow(color: Color.secondary, radius: 2)
        .padding(.horizontal)
      }
    }
    .onTapGesture {
      isExpanded.toggle()
    }
    .sheet(
      isPresented: $showSheet,
      onDismiss: {
        Task {
          try await viewModel.getStep()
        }
      }
    ) {
      StepBottomSheet(step: viewModel.step)
        .presentationDetents([.height(150)])
    }
  }
}

#Preview{
  NewStepCell(step: ProjectStepModel.MOCK_STEPS[0], editable: true)
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

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      configuration.label
      Spacer()
      Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
        .resizable()
        .frame(width: 24, height: 24)
        .onTapGesture { configuration.isOn.toggle() }
    }
  }
}
