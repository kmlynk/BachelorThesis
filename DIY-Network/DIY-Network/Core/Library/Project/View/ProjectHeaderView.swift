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
    VStack {
      GroupBox {
        Divider()

        if let imageUrl = project.projectImageUrl {
          ProjectImageView(width: 300, height: 300, imageUrl: imageUrl)
        }

        GroupBox {
          Text(project.projectDesc)
            .font(.footnote)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 8)

          if let url = project.videoUrl {
            if showVideo {
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
              .frame(width: 300, height: 200)
              .contentShape(Rectangle())
              .padding(.vertical, 16)

              Button {
                showVideo.toggle()
              } label: {
                Text("Hide Video")
                  .font(.caption)
                  .fontWeight(.bold)
                  .foregroundColor(Color.blue)
              }
            } else {
              Button {
                showVideo.toggle()
              } label: {
                Text("Show Video")
                  .font(.caption)
                  .fontWeight(.bold)
                  .foregroundColor(Color.blue)
              }
            }
          }
        }
      } label: {
        Text(project.projectName)
      }
      .groupBoxStyle(.projectHeader)
      .frame(width: UIScreen.main.bounds.width)
    }
  }
}

#Preview{
  ProjectHeaderView(project: ProjectModel.MOCK_PROJECTS[0])
}

extension GroupBoxStyle where Self == ProjectHeaderBoxStyle {
  static var projectHeader: ProjectHeaderBoxStyle { .init() }
}

struct ProjectHeaderBoxStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    VStack(alignment: .center) {
      configuration.label
        .font(.callout)
        .fontWeight(.bold)
      configuration.content
    }
    .padding()
    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
  }
}
