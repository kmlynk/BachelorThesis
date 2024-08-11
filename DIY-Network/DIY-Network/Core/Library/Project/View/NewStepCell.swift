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
        }
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
              }
            }

            Divider()

            VStack {
              if let imageUrl = viewModel.step.stepImageUrl {
                ProjectImageView(width: 200, height: 260, imageUrl: imageUrl)
              }

              Text(viewModel.step.stepDesc)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            }
          }
        }
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
