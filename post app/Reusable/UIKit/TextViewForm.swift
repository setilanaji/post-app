//
//  TextViewForm.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/24.
//

import UIKit

class TextViewForm: UITextView {
    var canResign: Bool = false
    override var canResignFirstResponder: Bool {
        return canResign
    }
}
