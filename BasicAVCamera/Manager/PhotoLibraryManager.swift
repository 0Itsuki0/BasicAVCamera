//
//  PhotoLibraryManager.swift
//  SwiftUIDemo2
//
//  Created by Itsuki on 2024/05/18.
//

import Foundation
import Photos


class PhotoLibraryManager {
    
    private var assetCollection: PHAssetCollection?
    private var smartAlbumType: PHAssetCollectionSubtype = .smartAlbumUserLibrary

    init() async {
        let isAuthorized = await checkAuthorization()
        if (!isAuthorized) {
            return
        }
        loadAsset()
    }
    
    private func loadAsset() {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: smartAlbumType, options: fetchOptions)
        self.assetCollection = collections.firstObject

    }

    private func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            print("Photo library access authorized.")
            return true
        case .notDetermined:
            print("Photo library access not determined.")
            return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .denied:
            print("Photo library access denied.")
            return false
        case .limited:
            print("Photo library access limited.")
            return false
        case .restricted:
            print("Photo library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
    
    func savePhoto(imageData: Data) async {
        let isAuthorized = await checkAuthorization()
        if (!isAuthorized) {
            return
        }
        
        if assetCollection == nil {
            loadAsset()
        }
        
        guard let assetCollection = self.assetCollection else {
            print("error saving image to photo")
            return
        }
        
        Task {
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    if let assetPlaceholder = creationRequest.placeholderForCreatedAsset {
                        creationRequest.addResource(with: .photo, data: imageData, options: nil)
                        
                        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection), assetCollection.canPerform(.addContent) {
                            let fastEnumeration = NSArray(array: [assetPlaceholder])
                            albumChangeRequest.addAssets(fastEnumeration)
                        }
                    }
                }
                    
                print("Added image data to photo collection.")
            } catch let error {
                print("Failed to add image to photo collection: \(error.localizedDescription)")
            }
        }
    }
    
    func saveVideo(fileUrl: URL) async {
        let isAuthorized = await checkAuthorization()
        if (!isAuthorized) {
            return
        }
        
        if assetCollection == nil {
            loadAsset()
        }
        
        guard let assetCollection = self.assetCollection else {
            print("error saving video to photo")
            return
        }
        
        Task {
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    if let assetPlaceholder = creationRequest.placeholderForCreatedAsset {
                        creationRequest.addResource(with: .video, fileURL: fileUrl, options: nil)
                        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection), assetCollection.canPerform(.addContent) {
                            let fastEnumeration = NSArray(array: [assetPlaceholder])
                            albumChangeRequest.addAssets(fastEnumeration)
                        }
                    }
                }
                    
                print("Added video to photo collection.")
            } catch let error {
                print("Failed to add video to photo collection: \(error.localizedDescription)")
            }
        }
    }
}
