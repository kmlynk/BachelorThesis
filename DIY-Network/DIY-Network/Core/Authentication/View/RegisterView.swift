//
//  RegisterView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import SwiftUI

struct RegisterView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @Environment(\.dismiss) var dismiss
  @State private var email = ""
  @State private var password = ""
  @State private var username = ""

  var body: some View {
    NavigationStack {
      VStack {
        Text("Create an Account")
          .font(.title2)
          .fontWeight(.semibold)
          .padding(.top, 50)

        Text(
          "Password must be at least 8 characters long\n" + "Password also must include minimum\n"
            + "1 lowercase and 1 uppercase letter"
        )
        .font(.footnote)
        .fontWeight(.thin)
        .multilineTextAlignment(.center)
        .padding(.top, 10)

        VStack(spacing: 10) {
          TextField("E-Mail", text: $email)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .modifier(TextFieldModifier())

          TextField("Username", text: $username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .modifier(TextFieldModifier())

          SecureField("Password", text: $password)
            .autocorrectionDisabled()
            .modifier(TextFieldModifier())
        }
        .padding(.top, 10)

        Button {
          Task {
            try await authViewModel.createUser(
              withEmail: email, password: password, username: username)
          }
        } label: {
          Text("Register")
            .modifier(ButtonModifier())
        }
        .padding(.top)
      }
      .navigationTitle("Register")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Image(systemName: "chevron.left")
            .imageScale(.large)
            .onTapGesture {
              dismiss()
            }
        }
      }

      Spacer()
    }
  }
}

#Preview{
  RegisterView()
}
