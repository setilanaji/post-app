//
//  TextForm.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/24.
//

import UIKit

protocol TextViewCellDelegate {
    func updateCellHeight()
    func updateText(with value: String)
}

public class TextForm: NiblessTableViewCell {
    static let identifier = "TextFormCell"
    
    private let placeHolder = "Type something..."
    var delegate: TextViewCellDelegate?
    private var textValue = "" {
        didSet {
           setposition(with: textValue)
        }
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: contentView.bounds)
        textView.textColor = .label
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapTextView(_:))))
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = "NiblessTableViewCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        constructHirearchy()
        activateConstraints()
        
        setText(with: "")
    }
    
    func constructHirearchy() {
        [textView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true
            contentView.addSubview($0) }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func setposition(with value: String) {
        if value.isEmpty {
            textView.text = self.placeHolder
            textView.textColor = .tertiaryLabel
            textView.becomeFirstResponder()
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else {
            textView.text = value
            textView.textColor = .label
            textView.becomeFirstResponder()
        }
    }
    
    @objc
    private func onTapTextView(_ sender: Any) {
        setposition(with: textValue)
    }
}

extension TextForm {
    public func setText(with text: String) {
        textValue = text
    }
}

extension TextForm: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        let newText = textView.textColor == .tertiaryLabel && textView.text.contains(self.placeHolder) ? textView.text.replacingOccurrences(of: self.placeHolder, with: "") : textView.text
        
        delegate?.updateText(with: newText ?? "")
        setText(with: newText ?? "")
        delegate?.updateCellHeight()
    }
}
