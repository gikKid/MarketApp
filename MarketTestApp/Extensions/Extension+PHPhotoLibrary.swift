import UIKit
import PhotosUI
import AVFoundation

extension PHPhotoLibrary {
    static func execute(controller:UIViewController,
                        onAccessHasBeenGranted: @escaping () -> Void,
                        onAccessHasBeenDenied: (() -> Void)? = nil) {
        let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
            let alert = UIAlertController(title: "We were unable to load your album groups. Sorry!", message: "You can enable access in Privacy Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel))
            alert.addAction(UIAlertAction(title: Resources.Titles.settings, style: .default,handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
            controller.present(alert, animated: true)
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            DispatchQueue.main.async {onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)}
        case .denied, .restricted:
            DispatchQueue.main.async {onDeniedOrRestricted()}
        case .authorized:
            DispatchQueue.main.async {onAccessHasBeenGranted()}
        case .limited:
            DispatchQueue.main.async {onAccessHasBeenGranted()}
        @unknown default:
            fatalError("PHPhotoLibrary::execute - Unknown case")
        }
    }
}

private func onNotDetermined(_ onDeniedOrRestricted: @escaping (() -> Void),_ onAuthorized: @escaping (() -> Void) ) {
    PHPhotoLibrary.requestAuthorization({ status in
        switch status {
        case .notDetermined:
            DispatchQueue.main.async {onNotDetermined(onDeniedOrRestricted, onAuthorized)}
        case .denied,.restricted:
            DispatchQueue.main.async {onDeniedOrRestricted()}
        case .authorized:
            DispatchQueue.main.async {onAuthorized()}
        case .limited:
            DispatchQueue.main.async {onAuthorized()}
        @unknown default:
            fatalError("PHPhotoLibrary::execute - Unknown case")
        }
    })
}

func checkCameraAccess(controller:UIViewController,onAccessCompletion: @escaping () -> Void) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .denied, .restricted:
        presentCameraSettings(controller)
    case .authorized:
        DispatchQueue.main.async {onAccessCompletion()}
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { success in
            if success {
                DispatchQueue.main.async {onAccessCompletion()}
            }
        })
    @unknown default:
        fatalError("AVCaptureDevice::execute - Unknown case")
    }
}

private func presentCameraSettings(_ controller:UIViewController) {
    let alert = UIAlertController(title: Resources.Titles.error, message: "Camera access is denied", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel))
    alert.addAction(UIAlertAction(title: Resources.Titles.settings, style: .default,handler: { _ in
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }))
    controller.present(alert, animated: true)
}
