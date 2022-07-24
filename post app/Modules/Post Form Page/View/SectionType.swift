//
//  SectionType.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/24.
//

import UIKit

public enum PostFormSectionType {
    case text(text: String)
    case image(image: UIImage?)
}

extension PostFormSectionType {
    var image: UIImage? {
        switch self {
        case .image(let image): return image
        default: return nil
        }
    }
    
    var text: String {
        switch self {
        case .text(let text): return text
        default: return ""
        }
    }
}
