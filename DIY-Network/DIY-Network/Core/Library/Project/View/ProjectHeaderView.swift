//
//  ProjectHeaderView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import SwiftUI
import YouTubePlayerKit

struct ProjectHeaderView: View {
  let project: ProjectModel
  @State private var showVideo = false

  var body: some View {
    VStack(spacing: 8) {
      if let imageUrl = project.projectImageUrl {
        ProjectImageView(width: 320, height: 320, imageUrl: imageUrl)
      }

      Text(project.projectDesc)
        .font(.footnote)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)

      if let url = project.videoUrl {
        if showVideo {
          Button {
            showVideo.toggle()
          } label: {
            Text("Hide Video")
              .font(.footnote)
              .fontWeight(.bold)
              .foregroundColor(Color.blue)
          }

          YouTubePlayerView(
            YouTubePlayer(
              source: .url(url),
              configuration: YouTubePlayer.Configuration(
                fullscreenMode: .system,
                autoPlay: false,
                loopEnabled: false
              )
            )
          ) { state in
            switch state {
            case .idle:
              ProgressView()
            case .ready:
              EmptyView()
            case .error(let error):
              Text(error.localizedDescription)
            }
          }
          .frame(width: UIScreen.main.bounds.width - 60, height: 200)
          .contentShape(Rectangle())
          .padding(.vertical, 16)
        } else {
          Button {
            showVideo.toggle()
          } label: {
            Text("Show Video")
              .font(.footnote)
              .fontWeight(.bold)
              .foregroundColor(Color.blue)
          }
        }
      }

      ProjectDividerView(minusWidth: 35, height: 0.1)
    }
  }
}

#Preview{
  ProjectHeaderView(project: ProjectModel.MOCK_PROJECTS[0])
}
