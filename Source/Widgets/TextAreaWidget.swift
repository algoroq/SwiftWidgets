//
//  TextAreaWidget.swift
//  Example
//
//  Created by woko on 04/02/2020.
//

import Foundation
import UIKit

open class TextAreaWidget: Widget, WidgetInstantiable {
    public typealias Model = TextAreaWidgetModel
    
    public lazy var mainView: UIView = {
        return UIView()
    }()
    
    public lazy var textView: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        return view
    }()
    
    public lazy var placeholderLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    

    open override func build() {
        mainView.addSubview(textView)
        mainView.addSubview(placeholderLabel)
        mainView.layer.cornerRadius = 8
        
        textView.snp.makeConstraints {
            $0.centerY.equalTo(mainView)
            $0.height.equalTo(20)
        }
        
        textView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 21).isActive = true
        textView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 21).isActive = true
        
        backgroundColor = .systemPink

        placeholderLabel.snp.makeConstraints {
            $0.top.bottom.centerY.equalTo(mainView)
        }
        
        placeholderLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 21).isActive = true
        
        addContentView(mainView)
        mainView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
  
        mainView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        mainView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        textView.isEditable = true
        textView.isSelectable = true
        textView.delegate = self
        
        forceInteractible = true
    }
    
    open override func load() {
        super.load()
        
        
        TextAreaComponent().setup(target: textView, model: model.textInput, widgetModel: model)
        LabelComponent().setup(target: placeholderLabel, model: model.placeholder, widgetModel: model)
        
        if let text = model.textInput.text, !text.isEmpty {
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
        
        if model.height != nil {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }
    }
}

extension TextAreaWidget: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        placeholderLabel.isHidden = !text.isEmpty
        model.textInput.textChanged?(self, text)
        updateHeight()
    }
}

open class TextAreaWidgetModel: WidgetModel {
    public var textInput = TextFieldComponentModel()
    public var placeholder = LabelComponentModel()
    public var innerEdgesHorizontal: Float = 0
    public var innerEdgesVertical: Float = 0
    
    open override func afterInit() {
        placeholder.color = Settings.Color.darkGray
        innerEdgesHorizontal = Settings.Offset.basic
        innerEdgesVertical = Settings.Offset.basic
    }
}
