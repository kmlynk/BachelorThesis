//
//  LoginView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import SwiftUI

struct LoginView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @State private var email = ""
  @State private var password = ""

  var body: some View {
    NavigationStack {
      VStack {
        Spacer()

        Text("DIY Network")
          .font(.title)
          .fontWeight(.bold)

        Text("A Social Media Platform for DIY Enthusiasts")
          .font(.subheadline)
          .fontWeight(.semibold)
          .padding(.vertical, 1)

        VStack {
          TextField("E-Mail", text: $email)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .modifier(TextFieldModifier())

          SecureField("Password", text: $password)
            .autocorrectionDisabled()
            .modifier(TextFieldModifier())
        }
        .padding(.top, 15)

        Button {
          Task {
            try await authViewModel.signIn(withEmail: email, password: password)
          }
        } label: {
          Text("Login")
            .modifier(ButtonModifier())
        }
        .padding(.top)

        HStack {
          Rectangle()
            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 0.5)

          Text("OR")
            .font(.footnote)
            .fontWeight(.semibold)

          Rectangle()
            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 0.5)
        }
        .foregroundColor(.gray)
        .padding()

        Text("Login with ...")

        Spacer()

        Divider()

        NavigationLink {
          RegisterView()
            .navigationBarBackButtonHidden()
        } label: {
          HStack(spacing: 3) {
            Text("Are you new around here?")
              .font(.footnote)

            Text("Sign Up")
              .font(.footnote)
              .fontWeight(.semibold)
          }
          .padding(.vertical, 15)
        }
      }
    }
  }
}

#Preview{
  LoginView()
}
