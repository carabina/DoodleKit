//
//  UIImage+DoodleKit.swift
//  Pods
//
//  Created by Kyle Zaragoza on 6/2/17.
//
//

import UIKit

internal extension UIImage {
    internal class func imageWithColor(_ color: UIColor, ofSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            assertionFailure("Unable to grab image context.")
            return nil
        }
        color.setFill()
        currentContext.fill(CGRect(origin: .zero, size: size))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
