//
//  PlantIconPickerViewController+Delegates.swift
//  GrowApp
//
//  Created by Ryan Thally on 2/23/21.
//

import UIKit

extension PlantIconPickerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        dataSource?.itemIdentifier(for: indexPath)?.isTappable == true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource?.itemIdentifier(for: indexPath)?.tapAction?()
    }
}

extension PlantIconPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker(preferredType: UIImagePickerController.SourceType = .photoLibrary) {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]

        if UIImagePickerController.isSourceTypeAvailable(preferredType) {
            imagePicker.sourceType = preferredType
        } else {
            imagePicker.sourceType = .photoLibrary
        }

        if imagePicker.sourceType == .camera {
            imagePicker.cameraOverlayView = CameraOverlayView(frame: .zero)
        }

        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        if icon == nil {
            // If no icon exists, create a new icon
            icon = GHIcon(context: persistentContainer.viewContext)
        }

        // Apply the new selected image
        icon?.imageData = image.pngData()
        updateUI(animated: false)
        
        dismiss(animated: true)
    }
}
