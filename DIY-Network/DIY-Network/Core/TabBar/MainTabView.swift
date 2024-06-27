//
//  MainTabView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import SwiftUI

struct MainTabView: View {
  @State private var selectedTab = "Feed"
  let user: UserModel

  var body: some View {
    TabView(selection: $selectedTab) {
      TestView()
        .tabItem {
          Image(systemName: "house")
        }
        .tag("Feed")
      
      SearchView()
        .tabItem {
          Image(systemName: "magnifyingglass")
        }
        .tag("Search")

      Text("Post Project")
        .tabItem {
          Image(systemName: "plus.square")
        }
        .tag("Post")

      LibraryView(user: user)
        .tabItem {
          Image(systemName: "books.vertical")
        }
        .tag("Library")

      CurrentUserProfileView()
        .tabItem {
          Image(systemName: "person")
        }
        .tag("Profile")
    }
    .accentColor(Color.primary)
  }
}

#Preview{
  MainTabView(user: UserModel.MOCK_USERS[0])
}
