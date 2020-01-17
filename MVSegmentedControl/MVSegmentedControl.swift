//
//  MVSegmentedControl.swift
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

@IBDesignable
open class MVSegmentedControl: UIControl {
    private var segments: [String] = ["First", "Second"]
    
    private var configuration: MVSegmentedControlConfiguration = MVSegmentedControlConfiguration()
    
    private var selectionView: MVSelectionView!
    private var segmentsViews: [MVSegmentView]!
    private var separatorsViews: [MVSeparator]!
    
    private var centerXSelectedSegmentViewConstraint: NSLayoutConstraint?
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var panGestureAnchorPoint: CGPoint?
    
    private var selectedSegmentView: MVSegmentView { segmentsViews[selectedSegmentIndex] }
    private var font: UIFont? { UIFont(name: fontName, size: fontSize) }
    private var segmentViewWidth: CGFloat { segmentsViews.first!.frame.width }
    private var selectionViewCenter: CGPoint {
        CGPoint(x: selectionView.frame.origin.x + selectionView.frame.size.width / 2,
                y: selectionView.frame.origin.y + selectionView.frame.size.height / 2)
    }
    
    public var segmentsCount: Int { segments.count }
    open var selectedSegmentIndex: Int = 0 {
        didSet { selectSegmentAt(selectedSegmentIndex, unselectAt: oldValue) }
    }
    
    // MARK: - Interface Builder
    
    @IBInspectable
    public var selectionOffset: CGFloat {
        get { configuration.selectionOffset }
        set {
            configuration.selectionOffset = newValue
            updateSelectionOffset(newValue)
        }
    }
    
    @IBInspectable
    public var selectionBackgroundColor: UIColor? {
        get { configuration.selectionBackgroundColor }
        set {
            configuration.selectionBackgroundColor = newValue
            selectionView.backgroundColor = newValue
        }
    }
    
    @IBInspectable
    public var selectionCornerRadius: CGFloat {
        get { configuration.selectionCornerRadius }
        set {
            configuration.selectionCornerRadius = newValue
            selectionView.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get { configuration.cornerRadius }
        set {
            configuration.cornerRadius = newValue
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get { configuration.borderWidth }
        set {
            configuration.borderWidth = newValue
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor {
        get { configuration.borderColor }
        set {
            configuration.borderColor = newValue
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    public var separatorColor: UIColor? {
        get { configuration.separatorColor }
        set {
            configuration.separatorColor = newValue
            updateSeparatorsColor()
        }
    }
    
    @IBInspectable
    public var separatorWidth: CGFloat {
        get { configuration.separatorWidth }
        set {
            configuration.separatorWidth = newValue
            updateSeparatorsWidth(newValue)
        }
    }
    
    @IBInspectable
    public var separatorOffset: CGFloat {
        get { configuration.separatorOffset }
        set {
            configuration.separatorOffset = newValue
            updateSeparatorsOffset(newValue)
        }
    }
    
    @IBInspectable
    public var fontName: String {
        get { configuration.labelConfiguration.font?.fontName ?? "SFProText-Regular" }
        set {
            configuration.labelConfiguration.font = UIFont(name: newValue, size: fontSize)
            configureLabels()
        }
    }
    
    @IBInspectable
    public var selectionFontName: String {
        get { configuration.selectionLabelConfiguration.font?.fontName ?? "SFProText-Regular" }
        set {
            configuration.selectionLabelConfiguration.font = UIFont(name: newValue, size: fontSize)
            configureSelectionLabels()
        }
    }
    
    @IBInspectable
    public var fontSize: CGFloat {
        get { configuration.labelConfiguration.font?.pointSize ?? 13 }
        set {
            configuration.labelConfiguration.font = UIFont(name: fontName, size: newValue)
            configureLabels()
        }
    }
    
    @IBInspectable
    public var selectionFontSize: CGFloat {
        get { configuration.selectionLabelConfiguration.font?.pointSize ?? 13 }
        set {
            configuration.selectionLabelConfiguration.font = UIFont(name: fontName, size: newValue)
            configureSelectionLabels()
        }
    }
    
    @IBInspectable
    public var textColor: UIColor {
        get { configuration.labelConfiguration.textColor }
        set {
            configuration.labelConfiguration.textColor = newValue
            configureLabels()
        }
    }
    
    @IBInspectable
    public var selectionTextColor: UIColor {
        get { configuration.selectionLabelConfiguration.textColor }
        set {
            configuration.selectionLabelConfiguration.textColor = newValue
            configureSelectionLabels()
        }
    }
    
    // MARK: - Life Cycle
    
    public init(segments: [String], configuration: MVSegmentedControlConfiguration? = nil) {
        guard segments.count > 1 else { fatalError("Number of segments should be more 1.") }
        
        self.segments = segments
        
        if let configuration = configuration {
            self.configuration = configuration
        }
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateSelectionViewPosition()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupViews()
    }
}

// MARK: - Configuring Segments

public extension MVSegmentedControl {
    func configureSegments(_ segments: [String], configuration: MVSegmentedControlConfiguration? = nil) {
        guard segments.count > 1 else { fatalError("Number of segments should be more 1.") }
        
        self.segments = segments
        
        if let configuration = configuration {
            configure(configuration)
        }
        
        resetViews()
    }
    
    func configure(_ configuration: MVSegmentedControlConfiguration) {
        selectionOffset = configuration.selectionOffset
        selectionBackgroundColor = configuration.selectionBackgroundColor
        selectionCornerRadius = configuration.selectionCornerRadius
        cornerRadius = configuration.cornerRadius
        borderWidth = configuration.borderWidth
        borderColor = configuration.borderColor
        separatorColor = configuration.separatorColor
        separatorWidth = configuration.separatorWidth
        separatorOffset = configuration.separatorOffset
        fontName = configuration.labelConfiguration.font?.fontName ?? "SFProText-Regular"
        selectionFontName = configuration.selectionLabelConfiguration.font?.fontName ?? "SFProText-Regular"
        fontSize = configuration.labelConfiguration.font?.pointSize ?? 13
        selectionFontSize = configuration.selectionLabelConfiguration.font?.pointSize ?? 13
        textColor = configuration.labelConfiguration.textColor
        selectionTextColor = configuration.selectionLabelConfiguration.textColor
    }
}

// MARK: - Setup Views

private extension MVSegmentedControl {
    func resetViews() {
        subviews.forEach({ $0.removeFromSuperview() })
        
        setupViews()
    }
    
    func setupViews() {
        if panGestureRecognizer == nil {
            panGestureRecognizer = createPanGestureRecognizer()
            self.addGestureRecognizer(panGestureRecognizer!)
        }
        
        self.clipsToBounds = true
        
        createViews()
        
        setupSegmentViews()
        setupSelectionView()
    }
    
    func setupSegmentViews() {
        for index in 0 ..< segmentsCount {
            let segmentView = segmentsViews[index]
            
            addSubview(segmentView)
            segmentView.translatesAutoresizingMaskIntoConstraints = false
            segmentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            segmentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            if index == 0 {
                segmentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            }
            
            if index == segmentsCount - 1 {
                segmentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            }
            
            if index > 0 {
                let previousSegmentView = segmentsViews[index - 1]
                let separator = separatorsViews[index - 1]
                
                addSubview(separator)
                
                setupConstraintsOfSeparator(separator, leftView: previousSegmentView, rightView: segmentView)
            }
        }
    }
    
    func setupSelectionView() {
        selectionView.clipsToBounds = true
        
        addSubview(selectionView)
        
        setupConstraintsOfSelectionView()
        selectionView.configureLabelsPositionsBy(segmentsViews.map({ $0.titleLabel }))
    }
}

// MARK: - Updating Views

private extension MVSegmentedControl {
    func updateSelectionViewPosition() {
        centerXSelectedSegmentViewConstraint?.constant = CGFloat(selectedSegmentIndex) * segmentViewWidth + (2 * separatorOffset + separatorWidth) * CGFloat(selectedSegmentIndex)
    }
    
    func updateSelectionViewPositionAt(_ index: Int) {
        centerXSelectedSegmentViewConstraint?.constant = CGFloat(index) * segmentViewWidth + (2 * separatorOffset + separatorWidth) * CGFloat(selectedSegmentIndex)
    }
    
    func updateSeparatorsWidth(_ width: CGFloat) {
        subviews.filter({ $0 is MVSeparator }).forEach({ separator in
            guard let constraintWidth = separator.constraints.first(where: { $0.firstAttribute == .width }) else { return }
            
            constraintWidth.constant = width
        })
    }
    
    func updateSeparatorsOffset(_ offset: CGFloat) {
        constraints.filter({ $0.firstAttribute == .leading && $0.firstItem is MVSeparator }).forEach({ $0.constant = offset })
        constraints.filter({ $0.firstAttribute == .trailing && $0.firstItem is MVSeparator }).forEach({ $0.constant = -offset })
    }
    
    func updateSeparatorsColor() {
        subviews.filter({ $0 is MVSeparator }).forEach({ $0.backgroundColor = separatorColor})
    }
    
    func updateSelectionOffset(_ offset: CGFloat) {
        constraints.first(where: { $0.firstItem is MVSelectionView && $0.firstAttribute == .width })?.constant = -offset
        constraints.first(where: { $0.firstItem is MVSelectionView && $0.firstAttribute == .height })?.constant = offset
    }
    
    func configureLabels() {
        for segmentView in segmentsViews {
            segmentView.configureLabel(configuration.labelConfiguration)
        }
    }
    
    func configureSelectionLabels() {
        selectionView.configureLabels(configuration.selectionLabelConfiguration)
    }
}

// MARK: - Creating Views

private extension MVSegmentedControl {
    func createViews() {
        separatorsViews = createSeparatorViews()
        segmentsViews = createSegmentViews()
        selectionView = createSelectionView()
    }
    
    func createSegmentViews() -> [MVSegmentView] {
        var segmentViews: [MVSegmentView] = []
        for index in 0 ..< segmentsCount {
            let segmentView = MVSegmentView(labelConfiguration: configuration.labelConfiguration,
                                          textLabel: segments[index],
                                          isSelected: selectedSegmentIndex == index)
            segmentView.addGestureRecognizer(createTapGestureRecognizer())
            segmentViews.append(segmentView)
        }
        
        return segmentViews
    }
    
    func createSeparatorViews() -> [MVSeparator] {
        var separatorViews: [MVSeparator] = []
        for _ in 0 ..< segmentsCount - 1 {
            separatorViews.append(MVSeparator())
        }
        
        return separatorViews
    }
    
    func createSelectionLabels() -> [UILabel] {
        var labels: [UILabel] = []
        for index in 0 ..< segmentsCount {
            let selectionLabel = createSelectionLabel(with: segments[index])
            
            labels.append(selectionLabel)
        }
        
        return labels
    }
    
    func createSelectionLabel(with text: String) -> UILabel {
        let selectionLabel = UILabel()
        selectionLabel.text = text
        selectionLabel.configure(MVLabelConfiguration(textAligment: .center, textColor: selectionTextColor, font: font))
        
        return selectionLabel
    }
    
    func createSeparator() -> MVSeparator {
        let separator = MVSeparator()
        separator.backgroundColor = separatorColor
        
        return separator
    }
    
    func createSelectionView() -> MVSelectionView {
        let selectionView = MVSelectionView(titles: segments, configuration: configuration.selectionLabelConfiguration)
        
        return selectionView
    }
}

// MARK: - Setup Constraints

private extension MVSegmentedControl {
    func setupConstraintsOfSelectionView() {
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.widthAnchor.constraint(equalTo: segmentsViews.first!.widthAnchor, constant: -selectionOffset).isActive = true
        selectionView.heightAnchor.constraint(equalTo: segmentsViews.first!.heightAnchor, constant: -selectionOffset).isActive = true
        selectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        centerXSelectedSegmentViewConstraint = selectionView.centerXAnchor.constraint(equalTo: segmentsViews.first!.centerXAnchor)
        centerXSelectedSegmentViewConstraint?.isActive = true
    }
    
    func setupConstraintsOfSeparator(_ separator: UIView, leftView: UIView, rightView: UIView) {
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: separatorWidth).isActive = true
        separator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: separatorOffset).isActive = true
        separator.trailingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: -separatorOffset).isActive = true
        leftView.widthAnchor.constraint(equalTo: rightView.widthAnchor).isActive = true
    }
}

// MARK: - Recognizers

private extension MVSegmentedControl {

    // MARK: - Creating
    
    func createPanGestureRecognizer() -> UIPanGestureRecognizer {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        
        return panGestureRecognizer
    }
    
    func createTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        return tapGestureRecognizer
    }
    
    // MARK: - Handling
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let gesturePoint = gestureRecognizer.location(in: self)
        
        switch gestureRecognizer.state {
        case .began:
            guard panGestureAnchorPoint == nil else { fatalError("panGestureAnchorPoint is not nil") }
            panGestureAnchorPoint = gestureRecognizer.location(in: self)
        case .changed:
            guard let panGestureAnchorPoint = panGestureAnchorPoint else { fatalError("panGestureAnchorPoint is nil") }
            
            moveSelectionViewFromPoint(panGestureAnchorPoint, toPoint: gesturePoint)
        case .ended:
            defer { panGestureAnchorPoint = nil }
            guard let segmentView = segmentViewByPoint(selectionViewCenter) else {
                updateSelectionViewPositionAt(selectedSegmentIndex)
                return
            }

            selectSegmentView(segmentView)
        case .cancelled:
            updateSelectionViewPositionAt(selectedSegmentIndex)
            panGestureAnchorPoint = nil
        default:
            break
        }
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if let segmentView = gestureRecognizer.view as? MVSegmentView {
            selectSegmentView(segmentView)
        }
    }
    
    func selectSegmentView(_ segmentView: MVSegmentView) {
        if let segmentIndex = segmentsViews.firstIndex(of: segmentView) {
            selectedSegmentIndex = segmentIndex
        }
    }
    
    func selectSegmentAt(_ index: Int, unselectAt unselectIndex: Int) {
        defer { updateSelectionViewPositionAt(index) }
        guard unselectIndex != index else { return }
        
        segmentsViews[unselectIndex].setSelected(false)
        segmentsViews[index].setSelected(true)
        
        sendActions(for: .valueChanged)
    }
    
    func moveSelectionViewFromPoint(_ from: CGPoint, toPoint to: CGPoint) {
        if selectedSegmentIndex == 0, from.x > to.x { return }
        if selectedSegmentIndex == segmentsCount - 1, from.x < to.x { return }
        
        let centerXConstant = CGFloat(selectedSegmentIndex) * segmentViewWidth + to.x - from.x
        if centerXConstant < 0, to.x - from.x < 0 {
            centerXSelectedSegmentViewConstraint?.constant = 0
        } else if centerXConstant > (segmentsViews.last?.frame.origin.x ?? 0 + segmentViewWidth / 2), to.x - from.x > 0 {
            centerXSelectedSegmentViewConstraint?.constant = CGFloat(segmentsCount - 1) * segmentViewWidth
        } else {
            centerXSelectedSegmentViewConstraint?.constant = centerXConstant
        }
    }
    
    func segmentViewByPoint(_ point: CGPoint) -> MVSegmentView? {
        let view = segmentsViews.first { $0.point(inside: convert(point, to: $0), with: nil) }
        return view
    }
}

// MARK: - UILabel Extensions

extension UILabel {
    func configure(_ configuration: MVLabelConfiguration) {
        textAlignment = configuration.textAligment
        textColor = configuration.textColor
        
        if let font = configuration.font {
            self.font = font
        }
    }
}
