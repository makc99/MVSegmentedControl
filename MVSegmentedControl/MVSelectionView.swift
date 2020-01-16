//
//  MVSelectionView.swift
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

class MVSelectionView: UIView {
    private var labels: [UILabel]
    private var labelsConfiguration: MVLabelConfiguration
    
    init(titles: [String], configuration: MVLabelConfiguration) {
        self.labels = []
        self.labelsConfiguration = configuration
        
        super.init(frame: .zero)
        
        titles.forEach { title in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.configure(configuration)
            labels.append(label)
            
            addSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabelsPositionsBy(_ labels: [UILabel]) {
        guard self.labels.count == labels.count else { fatalError("SelectionView: number of labels is not equal.") }
        
        for index in 0 ..< labels.count {
            setupConstraintsOfSelectionLabel(self.labels[index], for: labels[index])
        }
    }
    
    func configureLabels(_ configuration: MVLabelConfiguration) {
        labelsConfiguration = configuration
        
        labels.forEach({ $0.configure(labelsConfiguration) })
    }
    
    private func setupConstraintsOfSelectionLabel(_ selectionLabel: UILabel, for segmentLabel: UILabel) {
        selectionLabel.translatesAutoresizingMaskIntoConstraints = false
        selectionLabel.leadingAnchor.constraint(equalTo: segmentLabel.leadingAnchor).isActive = true
        selectionLabel.trailingAnchor.constraint(equalTo: segmentLabel.trailingAnchor).isActive = true
        selectionLabel.topAnchor.constraint(equalTo: segmentLabel.topAnchor).isActive = true
        selectionLabel.bottomAnchor.constraint(equalTo: segmentLabel.bottomAnchor).isActive = true
    }
}
