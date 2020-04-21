//
//  ImageService.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import RxCocoa
import RxSwift

extension ImageDownloader {
    static var `default`: ImageDownloader = {
        let imgCache = AutoPurgingImageCache(
            memoryCapacity: 50_000_000,
            preferredMemoryUsageAfterPurge: 20_000_000
        )
        
        let diskCache =  URLCache(
            memoryCapacity: 0,
            diskCapacity: 100 * 1024 * 1024,
            diskPath: "alamofireimage_disk_cache"
        )
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = diskCache
        
        return ImageDownloader(
            configuration: configuration,
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 20,
            imageCache: imgCache
        )
    }()
}

extension UIImageView {
    private struct AssociatedKey {
        static var activeRequestReceipt = "UIImageView.ActiveRequestReceipt"
    }
    
    var currentRequestReceipt: RequestReceipt? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.activeRequestReceipt) as? RequestReceipt }
        set { objc_setAssociatedObject(self, &AssociatedKey.activeRequestReceipt, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func transition(_ imageTransition: ImageTransition, with image: Image?, contentMode: ContentMode) {
        self.contentMode = contentMode
        guard let image = image else {
            self.image = nil
            return
        }
        
        UIView.transition(
            with: self,
            duration: imageTransition.duration,
            options: imageTransition.animationOptions,
            animations: { imageTransition.animations(self, image) },
            completion: imageTransition.completion
        )
    }
}



public struct NetworkImage {
    fileprivate let imageDownloader = ImageDownloader.default
    fileprivate let url: URL?
    fileprivate let imageContentMode: UIView.ContentMode
    fileprivate let placeHolder: UIImage?
    fileprivate let placeHolderContentMode: UIView.ContentMode
    fileprivate let transition: UIImageView.ImageTransition?
    
    public init(_ url: URL?,
                placeholder: UIImage? = nil,
                transition: UIImageView.ImageTransition? = .crossDissolve(0.5),
                imageContentMode: UIView.ContentMode = .scaleAspectFill,
                placeHolderContentMode: UIView.ContentMode = .center) {
        self.url = url
        self.placeHolder = placeholder
        self.transition = transition
        self.imageContentMode = imageContentMode
        self.placeHolderContentMode = placeHolderContentMode
    }
}

public extension Reactive where Base: UIImageView {
    var networkImage: Binder<NetworkImage> {
        return Binder(self.base) { view, networkImage in
            guard let url = networkImage.url else {
                view.image = networkImage.placeHolder
                return
            }
            
            let request = URLRequest(url: url)
            
            if let currentReceipt = view.currentRequestReceipt {
                ImageDownloader.default.cancelRequest(with: currentReceipt)
                view.currentRequestReceipt = nil
            }
            
            if let image = ImageDownloader.default.imageCache?.image(for: request, withIdentifier: nil) {
                view.transition(.noTransition, with: image, contentMode: networkImage.imageContentMode)
                return
            }
            
            view.currentRequestReceipt = ImageDownloader.default.download(
                URLRequest(url: url), receiptID: UUID().uuidString, filter: nil, progress: nil,
                progressQueue: DispatchQueue.global(qos: .userInteractive),
                completion: { response in
                    switch response.result {
                    case .failure(let error):
                        view.transition(.crossDissolve(0.3), with: networkImage.placeHolder, contentMode: networkImage.placeHolderContentMode)
                        print(error)
                    case .success(let image):
                        view.transition(.crossDissolve(0.3), with: image, contentMode: networkImage.imageContentMode)
                    }
                    view.currentRequestReceipt = nil
                }
            )
        }
    }
}
