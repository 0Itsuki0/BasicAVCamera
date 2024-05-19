//
//  SaveVideoView.swift
//  BasicAVCamera
//
//  Created by Itsuki on 2024/05/19.
//

import SwiftUI
import AVKit

struct SaveVideoView: View {
    @EnvironmentObject var model: CameraModel
    
    @State private var saved = false
    
    private let headerHeight: CGFloat = 90.0

    var body: some View {
        if let url = model.movieFileUrl {
            VideoPlayer(player: AVPlayer(url: url))
                .padding(.top, headerHeight)
                    .overlay(alignment: .top) {
                        buttonsView()
                            .frame(height: headerHeight)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.gray.opacity(0.4))
                    }
                .padding(.bottom, 16)
                .background(Color.black)
                .onAppear {
                    print(url)
                }
                .onDisappear {
                    Task {
                        try? FileManager().removeItem(at: url)
                    }
                }
        }
    }
    
    private func buttonsView() -> some View {
        HStack {
            Button {
                model.movieFileUrl = nil
            } label: {
                Image(systemName: "arrowshape.backward.fill") // camera.fill
            }

            Spacer()

            Button {
                guard let url = model.movieFileUrl else { return }
                Task {
                    await model.photoLibraryManager?.saveVideo(fileUrl:url)
                    
                    withAnimation {
                        self.saved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.saved = false
                        })
                    }
                }

            } label: {
                Image(systemName: saved ? "checkmark" : "square.and.arrow.down")
            }

        }
        .font(.system(size: 24, weight: .bold))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 32)
        .padding(.top, 32)

    }
}
