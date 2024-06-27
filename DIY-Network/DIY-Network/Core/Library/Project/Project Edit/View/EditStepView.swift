//
//  EditStepView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 24.06.24.
//

import PhotosUI
import SwiftUI

struct EditStepView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: EditStepViewModel
  @State private var showProgressView = false
  
  init(step: ProjectStepModel) {
    self._viewModel = StateObject(wrappedValue: EditStepViewModel(step: step))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          ProjectDividerView(minusWidth: 0, height: 2)

          PhotosPicker(selection: $viewModel.selectedImage) {
            VStack {
              if let image = viewModel.stepImage {
                image
                  .resizable()
                  .clipShape(Rectangle())
                  .frame(width: 180, height: 120)
              } else {
                ProjectImageView(
                  width: 180, height: 120, imageUrl: viewModel.step.stepImageUrl ?? "")
              }

              Text("Select a step image")
                .font(.footnote)
                .fontWeight(.semibold)
            }
          }
          .padding(.vertical)

          VStack {
            EditStepRowView(
              title: "Step Number", placeholder: "Number", text: $viewModel.number)

            EditStepRowView(title: "Step Name", placeholder: "Name", text: $viewModel.name)

            EditStepRowView(
              title: "Step Description", placeholder: "Description", text: $viewModel.desc)

            Button {
              Task {
                showProgressView.toggle()
                try await viewModel.updateStep()
                dismiss()
              }
            } label: {
              Text("Save the changes")
            }
            .modifier(InAppButtonModifier(width: 160, height: 50, radius: 30))
            .padding(.vertical)
          }
          .padding()
        }
        .scrollIndicators(.never)
        .navigationTitle("Edit Step")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark")
                .imageScale(.large)
            }
            .foregroundColor(Color.primary)
          }
        }
      }
    } else {
      ProgressView("Saving the changes...")
    }
  }
}

struct EditStepRowView: View {
  @Environment(\.colorScheme) var currentMode
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
    ZStack {
      VStack {
        HStack {
          Text(title)
            .font(.headline)
            .fontWeight(.semibold)

          Spacer()
        }

        HStack {
          TextField(placeholder, text: $text, axis: .vertical)
            .multilineTextAlignment(.leading)
        }
        .font(.subheadline)

        Divider()
      }
      .padding()
    }
    .mask {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
    }
    .background(currentMode == .dark ? Color.black : Color.white)
    .cornerRadius(20)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
  }
}

#Preview{
  EditStepView(step: ProjectStepModel.MOCK_STEPS[0])
}
