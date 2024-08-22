//
//  ProjectHeaderView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import AVKit
import AZVideoPlayer
import SwiftUI
import YouTubePlayerKit

struct ProjectHeaderView: View {
  let project: ProjectModel
  @State private var showVideo = false
  @State private var showYTVideo = false

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

          VStack {
            if let url = project.videoUrl {
              if !showVideo {
                Button {
                  showVideo.toggle()
                } label: {
                  Text("Show Video")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                }
              } else {
                AZVideoPlayer(player: AVPlayer(url: URL(string: url)!))
                  .aspectRatio(16 / 9, contentMode: .fit)

                Button {
                  showVideo.toggle()
                } label: {
                  Text("Hide Video")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                }
              }
            }
          }
          .padding(.bottom, 3)

          VStack {
            if let url = project.ytVideoUrl {
              if !showYTVideo {
                Button {
                  showYTVideo.toggle()
                } label: {
                  Text("Show YouTube Video")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                }
              } else {
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
                .frame(height: 200)
                .contentShape(Rectangle())
                .padding(.vertical, 16)

                Button {
                  showYTVideo.toggle()
                } label: {
                  Text("Hide Video")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                }
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
