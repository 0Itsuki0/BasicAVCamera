//
//  SaveImageView.swift
//  BasicAVCamera
//
//  Created by Itsuki on 2024/05/19.
//

import SwiftUI

struct SaveImageView: View {
    @EnvironmentObject var model: CameraModel
    
    @State private var saved = false
    
    private let headerHeight: CGFloat = 90.0

    var body: some View {
            ImageView(image: model.photoToken?.image )
                .padding(.top, headerHeight)
                    .overlay(alignment: .top) {
                        buttonsView()
                            .frame(height: headerHeight)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.gray.opacity(0.4))
                    }
                .padding(.bottom, 16)
                .background(Color.black)
  
    }
    
    private func buttonsView() -> some View {
            HStack {
                Button {
                    model.photoToken = nil
                } label: {
                    Image(systemName: "arrowshape.backward.fill") // camera.fill
                }
                
                
                Spacer()

                Button {
                    guard let photoToken = model.photoToken else { return }
                    Task {
                        await model.photoLibraryManager?.savePhoto(imageData: photoToken.imageData)
                        
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

#Preview {
    @StateObject var model = CameraModel()
//    model.photoToken = Image(systemName: "checkmark")

//    CameraView()
    return SaveImageView()
        .environmentObject(model)
}
