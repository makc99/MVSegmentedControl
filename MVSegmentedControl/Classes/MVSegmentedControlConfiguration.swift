//
//  MVSegmentedControlConfiguration.swift
//
//  Copyright (c) 2016-2020 MVSegmentedControl (https://github.com/makc99/MVSegmentedControl)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public struct MVSegmentedControlConfiguration {
    public var cornerRadius: CGFloat
    public var borderWidth: CGFloat
    public var borderColor: UIColor
    
    public var separatorWidth: CGFloat
    public var separatorColor: UIColor?
    public var separatorOffset: CGFloat
    
    public var selectionOffset: CGFloat
    public var selectionCornerRadius: CGFloat
    public var selectionBackgroundColor: UIColor?
    
    public var selectionLabelConfiguration: MVLabelConfiguration
    public var labelConfiguration: MVLabelConfiguration
    
    public init(cornerRadius: CGFloat = 0,
         borderWidth: CGFloat = 0,
         borderColor: UIColor = .clear,
         separatorWidth: CGFloat = 0,
         separatorColor: UIColor? = nil,
         separatorOffset: CGFloat = 0,
         selectionOffset: CGFloat = 0,
         selectionCornerRadius: CGFloat = 0,
         selectionBackgroundColor: UIColor? = nil,
         selectionLabelConfiguration: MVLabelConfiguration,
         labelConfiguration: MVLabelConfiguration) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.separatorWidth = separatorWidth
        self.separatorColor = separatorColor
        self.separatorOffset = separatorOffset
        self.selectionOffset = selectionOffset
        self.selectionCornerRadius = selectionCornerRadius
        self.selectionBackgroundColor = selectionBackgroundColor
        self.selectionLabelConfiguration = selectionLabelConfiguration
        self.labelConfiguration = labelConfiguration
    }
    
    public init() {
        self.init(cornerRadius: 0,
        borderWidth: 0,
        borderColor: .clear,
        separatorWidth: 0,
        separatorColor: nil,
        separatorOffset: 0,
        selectionOffset: 0,
        selectionCornerRadius: 0,
        selectionBackgroundColor: nil,
        selectionLabelConfiguration: MVLabelConfiguration(),
        labelConfiguration: MVLabelConfiguration())
    }
}
