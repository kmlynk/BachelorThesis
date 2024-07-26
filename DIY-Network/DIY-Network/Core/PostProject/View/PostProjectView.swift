//
//  PostProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import SwiftUI

struct PostProjectView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel: PostProjectViewModel
  @State var showSheet = false

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: PostProjectViewModel(user: user))
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack {
          ForEach(viewModel.projects) { project in
            PostProjectCell(project: project)
          }
        }
      }
      .scrollIndicators(.never)
      .navigationTitle("Choose a project to post")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview{
  PostProjectView(user: UserModel.MOCK_USERS[0])
}
