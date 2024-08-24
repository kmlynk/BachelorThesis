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
  @State private var error = ""

  var body: some View {
    NavigationStack {
      VStack {
        Text("Create an account")
          .font(.title2)
          .fontWeight(.semibold)
          .padding(.top, 50)

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

        if !error.isEmpty {
          VStack {
            Text(error)
              .animation(.bouncy)
              .foregroundColor(.red)
              .font(.footnote)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
          }
        }

        Button {
          Task {
            error = await validateRegisterForm()
            if error.isEmpty {
              do {
                try await authViewModel.createUser(
                  withEmail: email, password: password, username: username)
              } catch {
                self.error = authViewModel.authError ?? "Unknown error"
              }
            }
          }
        } label: {
          Text("Register")
            .modifier(AuthButtonModifier())
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

  private func validateRegisterForm() async -> String {
    if email.isEmpty || password.isEmpty || username.isEmpty {
      return "All fields are required."
    }
    if !AuthValidator.isValidEmail(email) {
      return "Invalid email format."
    }
    if !AuthValidator.isValidPassword(password) {
      return
        "Password must be at least 8 characters long and contain both uppercase and lowercase letters."
    }
    if !AuthValidator.isValidUsername(username) {
      return "Username must be at least 3 characters long."
    }

    do {
      if try await !UserService.isUsernameUnique(username: username) {
        return "Username already exists."
      }
    } catch {
      return "Failed to check username availiblity: \(error.localizedDescription)"
    }

    return ""
  }
}

#Preview{
  RegisterView()
}
