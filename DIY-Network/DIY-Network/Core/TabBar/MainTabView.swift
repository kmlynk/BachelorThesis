//
//  MainTabView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import SwiftUI

struct MainTabView: View {
  @State private var selectedTab = "Feed"

  var body: some View {
    TabView(selection: $selectedTab) {
      Text("Feed")
        .tabItem {
          Image(systemName: "house")
        }
        .tag("Feed")

      Text("Search")
        .tabItem {
          Image(systemName: "magnifyingglass")
        }
        .tag("Search")

      PostProjectView()
        .tabItem {
          Image(systemName: "plus.square")
        }
        .tag("Post")

      Text("Library")
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
  MainTabView()
}
