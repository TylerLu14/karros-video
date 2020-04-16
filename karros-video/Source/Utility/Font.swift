//
//  Font.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import UIKit

public struct Font {
    
    public static let system = System()
    public static let helvetica = Helvetica()
    
    fileprivate static let standardScreenWidth: CGFloat = 375
    
}

public protocol FontFactory {
    
    var normalName: String { get }
    var lightName: String { get }
    var boldName: String { get }
    var italicName: String {get}
    func normal(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool) -> UIFont
    func light(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool) -> UIFont
    func bold(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool) -> UIFont
    func italic(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool) -> UIFont
}

extension FontFactory {
    
    public func normal(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont(name: normalName, size: shouldScale ? calculateFontSize(size) : size)!
    }
    
    public func light(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont(name: lightName, size: shouldScale ? calculateFontSize(size) : size)!
    }
    
    public func bold(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont(name: boldName, size: shouldScale ? calculateFontSize(size) : size)!
    }
    
    public func italic(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont(name: italicName, size: shouldScale ? calculateFontSize(size) : size)!
    }
    
    fileprivate func loadFontWith(name: String) {
        guard let type = type(of: self) as? AnyClass else {
            NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            return
        }
        let frameworkBundle = Bundle(for: type)
        let pathForResourceString = frameworkBundle.path(forResource: name, ofType: "otf")
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil
        
        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
    
    fileprivate func calculateFontSize(_ standardSize: CGFloat) -> CGFloat {
        let maxSize = standardSize + (standardSize*0.15)
        let minSize = standardSize - (standardSize*0.15)
        
        let bounds = UIScreen.main.bounds
        let ratio = bounds.width/Font.standardScreenWidth
        
        var fontSize = standardSize*ratio
        
        if fontSize > maxSize {
            fontSize = maxSize
        }
        
        if fontSize < minSize {
            fontSize = minSize
        }
        
        return fontSize
    }
}

public struct System: FontFactory {
    
    public var normalName: String {
        return ""
    }
    public var lightName: String {
        return ""
    }
    public var boldName: String {
        return ""
    }
    public var italicName: String {
        return ""
    }
    
    public func normal(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont.systemFont(ofSize:  shouldScale ? calculateFontSize(size) : size)
    }
    
    public func light(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont.systemFont(ofSize:  shouldScale ? calculateFontSize(size) : size, weight: UIFont.Weight.light)
    }
    
    public func bold(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont.boldSystemFont(ofSize:  shouldScale ? calculateFontSize(size) : size)
    }
}

public class Helvetica: FontFactory {
    
    public var normalName: String {
        return "Helvetica"
    }
    public var lightName: String {
        return "Helvetica-Light"
    }
    public var boldName: String {
        return "Helvetica-Bold"
    }
    
    public var italicName: String {
        return "Helvetica-Italic"
    }
    
}

