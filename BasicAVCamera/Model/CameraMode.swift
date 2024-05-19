//
//  CameraMode.swift
//  BasicAVCamera
//
//  Created by Itsuki on 2024/05/19.
//

import Foundation

enum CameraMode {
    case video
    case photo
}


extension CameraMode {
    mutating func toggle() {
        if self == .photo {
            self = .video
        } else {
            self = .photo
        }
    }
}
