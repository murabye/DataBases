//
//  ViperModule.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//

import UIKit

//MARK: - Module View Types
public enum ViperViewType {
    case storyboard
    case nib
    case code
}

//MARK: - Viper Module Protocol
public protocol ViperModule {
    var viewType: ViperViewType { get }
    var viewName: String { get }
    func build(bundle: Bundle, deviceType: UIUserInterfaceIdiom?) -> BaseModule
}

public extension ViperModule where Self: RawRepresentable, Self.RawValue == String {
    var viewType: ViperViewType {
        return .storyboard
    }
    
    var viewName: String {
        return rawValue
    }
    
    func build(bundle: Bundle = Bundle.main, deviceType: UIUserInterfaceIdiom? = nil) -> BaseModule {
        return BaseModule.build(self, bundle: bundle, deviceType: deviceType)
    }
}
