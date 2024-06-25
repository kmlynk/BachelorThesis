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
  @EnvironmentObject var authViewModel: AuthViewModel
  @State private var showProgressView = false
  @State var selectedImage: PhotosPickerItem?
  @State var name = ""
  @State var desc = ""

  var body: some View {
    if !showProgressView {
      ScrollView {
        HStack {
          Button {
            dismiss()
          } label: {
            Image(systemName: "chevron.left")
              .imageScale(.large)
              .foregroundColor(Color.primary)
          }

          Spacer()

          Text("Edit")
            .font(.headline)
            .fontWeight(.bold)

          Spacer()
        }
        .padding()

        ProjectDividerView(minusWidth: 0, height: 2)

        ZStack {
          VStack {
            PhotosPicker(selection: $selectedImage) {
              VStack {
                ProjectImageView(width: 100, height: 80, imageUrl: "")

                Text("Select a step image")
              }
            }
            .padding(.top)

            VStack {
              EditProjectRowView(title: "Step Name", placeholder: "Name", text: $name)

              EditProjectRowView(
                title: "Step Description", placeholder: "Description", text: $desc)
            }
            .padding()
          }
        }
        .frame(width: UIScreen.main.bounds.width - 10)

        VStack {
          Button {
            print("DEBUG: Saving the changes...")
          } label: {
            Text("Save the changes")
          }
          .modifier(InAppButtonModifier(width: 180, height: 50, radius: 30))
        }
      }
    } else {
      ProgressView("Deleting the project...")
    }
  }
}

struct EditStepRowView: View {
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
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
          .font(.subheadline)
      }

      ProjectDividerView(minusWidth: 30, height: 1)
    }
    .padding(.vertical, 10)
  }
}

#Preview{
  EditStepView()
}
