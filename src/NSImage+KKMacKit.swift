//
//  NSImage+LFS.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/27.
//

import Foundation

public extension NSImage {
    var kk_pixelSize: CGSize? {
        get {
            guard let rep = representations.first else {
                return nil
            }
            return CGSize(width: rep.pixelsWide, height: rep.pixelsHigh)
        }
    }
    
    func kk_scaledImage(maxSize: CGSize, contentMode: KKContentResizeMode) -> NSImage {
        let newSize = maxSize.kk_sizeWithContent(size, inset: NSEdgeInsetsZero, contentMode: contentMode)

        // Cast the NSImage to a CGImage
        var imageRect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let imageRef = cgImage(forProposedRect: &imageRect, context: nil, hints: nil)

        // Create NSImage from the CGImage using the new size
        let imageWithNewSize = NSImage(cgImage: imageRef!, size: newSize)
        return imageWithNewSize
    }
    
    /// 以 aspectFit 的策略在 toMaxSize 的容器限制下，生成新图片
    func kk_scaled(toMaxSize: NSSize) -> NSImage {
        var ratio: Float = 0.0
        let imageWidth = Float(size.width)
        let imageHeight = Float(size.height)
        let maxWidth = Float(toMaxSize.width)
        let maxHeight = Float(toMaxSize.height)

        // Get ratio (landscape or portrait)
        if imageWidth > imageHeight {
            // Landscape
            ratio = maxWidth / imageWidth
        } else {
            // Portrait
            ratio = maxHeight / imageHeight
        }

        // Calculate new size based on the ratio
        let newWidth = imageWidth * ratio
        let newHeight = imageHeight * ratio

        // Create a new NSSize object with the newly calculated size
        let newSize: NSSize = NSSize(width: Int(newWidth), height: Int(newHeight))

        // Cast the NSImage to a CGImage
        var imageRect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let imageRef = cgImage(forProposedRect: &imageRect, context: nil, hints: nil)

        // Create NSImage from the CGImage using the new size
        let imageWithNewSize = NSImage(cgImage: imageRef!, size: newSize)

        // Return the new image
        return imageWithNewSize
    }
    
    func kk_jpgImageData(compressionFactor: CGFloat) -> Data? {
        guard let tiffData = tiffRepresentation else {
            return nil
        }
        let rep = NSBitmapImageRep(data: tiffData)
        let jpgData = rep?.representation(using: .jpeg, properties: [.compressionFactor: compressionFactor])
        return jpgData
    }
}
