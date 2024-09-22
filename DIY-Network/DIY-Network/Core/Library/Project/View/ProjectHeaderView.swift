//
//  ProjectHeaderView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import AVKit
import AZVideoPlayer
import SwiftUI
import UniformTypeIdentifiers
import YouTubePlayerKit

struct ProjectHeaderView: View {
  let project: ProjectModel
  @State private var showVideo = false
  @State private var showYTVideo = false
  @State private var exportDoc = false
  @State private var docData: Data? = nil

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

          if project.videoUrl != "" {
            let url = project.videoUrl
            VStack {
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
                AZVideoPlayer(player: AVPlayer(url: URL(string: url!)!))
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
            .padding(.top, 4)
          }

          if project.ytVideoUrl != "" {
            let url = project.ytVideoUrl
            VStack {
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
                    source: .url(url!),
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
            .padding(.top, 4)
          }

          if project.docUrl != "" {
            let url = project.docUrl
            Button {
              Task {
                docData = try await DocDownloader.download(from: URL(string: url!)!) ?? Data.empty
                if docData != nil {
                  exportDoc.toggle()
                }
              }
            } label: {
              HStack(spacing: 8) {
                Image(systemName: "arrow.down.doc")

                Text("Download PDF")
              }
            }
            .fileExporter(
              isPresented: $exportDoc,
              document: docData != nil
                ? DataFile(data: docData!) : nil,
              contentType: .pdf,  // Set the correct content type here
              defaultFilename: project.projectName
            ) { result in
              switch result {
              case .success(let url):
                print("File exported successfully: \(url)")
              case .failure(let error):
                print("File export failed: \(error.localizedDescription)")
              }
            }
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(Color.blue)
            .padding(.top, 4)
          }
        }
      } label: {
        Text(project.projectName)
          .font(.subheadline)
      }
      .frame(width: UIScreen.main.bounds.width - 30)
      .groupBoxStyle(.projectHeader)
    }
  }
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
