//
//  CreateProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 17.06.24.
//

import SwiftUI
import PhotosUI

struct CreateProjectView: View {
  @Environment(\.dismiss) var dismiss
  @State private var showProgressView = false
  @State var selectedImage: PhotosPickerItem?
  @State var projectName = ""
  @State var projectDesc = ""
  
  var body: some View {
    if showProgressView {
      ProgressView("Creating Project...")
    } else {
      ScrollView {
        VStack {
          HStack {
            Button("Cancel") {
              dismiss()
            }
            
            Spacer()
            
            Text("Create a Project")
              .font(.subheadline)
              .fontWeight(.semibold)
            
            Spacer()
            
            Button("Done") {
              print("DEBUG: Creating project...")
            }
            .font(.subheadline)
            .fontWeight(.bold)
          }
          .padding(.horizontal)
        }
        .padding(.vertical)
        
        Divider()
        
        PhotosPicker(selection: $selectedImage) {
          VStack {
            CircularProfileImageView(size: 80, imageUrl: "")
            
            Text("Add a Project Picture")
              .font(.footnote)
              .fontWeight(.semibold)
          }
        }
        .padding(.vertical, 10)
        
        VStack(spacing: 10) {
          CreateProjectRowView(title: "Project Name", placeholder: "Name", text: $projectName)
          
          CreateProjectRowView(title: "Project Describtion", placeholder: "Describtion", text: $projectDesc)
        }
      }
    }
  }
}

struct CreateProjectRowView: View {
  let title: String
  let placeholder: String
  @Binding var text: String
  
  var body: some View {
    VStack(spacing: 10) {
      HStack {
        Text(title)
          .fontWeight(.semibold)
        
        Spacer()
      }
      .padding(.leading, 10)
      
      VStack {
        HStack {
          TextField(placeholder, text: $text)
            .multilineTextAlignment(.leading)
        }
        .padding(.leading, 10)

        Divider()
      }
    }
    .font(.subheadline)
    .padding()
  }
}

#Preview{
  CreateProjectView()
}
