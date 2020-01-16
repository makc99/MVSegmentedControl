//
//  MVSegmentView.swift
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

class MVSegmentView: UIView {
    private(set) var titleLabel: UILabel = UILabel()
    
    private var isSelected: Bool
    private var labelConfiguration: MVLabelConfiguration
    
    // MARK: - Life cycle
    
    convenience init(isSelected: Bool = false) {
        self.init(labelConfiguration: MVLabelConfiguration(), isSelected: isSelected)
    }
    
    init(labelConfiguration: MVLabelConfiguration, textLabel: String? = nil, isSelected: Bool = false) {
        titleLabel.text = textLabel
        self.labelConfiguration = labelConfiguration
        self.isSelected = isSelected
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        titleLabel.configure(labelConfiguration)
    }
    
    // MARK: - Public Methods
    
    func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func configureLabel(_ configuration: MVLabelConfiguration) {
        labelConfiguration = configuration
        
        titleLabel.configure(configuration)
    }
}
