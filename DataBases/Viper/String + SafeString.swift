//
//  String + SafeString.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//

import Foundation

extension String {
    var first: String {
        return String(prefix(1))
    }
    var uppercasedFirst: String {
        return first.uppercased() + String(dropFirst())
    }
}

func safeString(_ value: Any?) -> String {
    guard let text = value else { return "" }
    return String(describing: text)
}
