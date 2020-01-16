//
//  ViewController.swift
//  MVSegmentedControl
//
//  Created by Maxim Matyukov on 01/15/2020.
//  Copyright (c) 2020 Maxim Matyukov. All rights reserved.
//

import UIKit
import MVSegmentedControl

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentedControl1 = MVSegmentedControl(segments: ["Segment1", "Segment2"])
        view.addSubview(segmentedControl1)
        segmentedControl1.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl1.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        if #available(iOS 11.0, *) {
            segmentedControl1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0).isActive = true
        } else {
            segmentedControl1.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0).isActive = true
        }
        segmentedControl1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if #available(iOS 13.0, *) {
            segmentedControl1.backgroundColor = .systemBackground
            segmentedControl1.selectionBackgroundColor = .systemGray2
        } else {
            segmentedControl1.backgroundColor = .lightGray
            segmentedControl1.selectionBackgroundColor = .gray
        }
        
        let segmentedControl2 = MVSegmentedControl(segments: ["One", "Two", "Three"])
        view.addSubview(segmentedControl2)
        segmentedControl2.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl2.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        segmentedControl2.topAnchor.constraint(equalTo: segmentedControl1.bottomAnchor, constant: 60.0).isActive = true
        segmentedControl2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if #available(iOS 13.0, *) {
            segmentedControl2.backgroundColor = .systemBackground
            segmentedControl2.borderColor = .systemGray2
            segmentedControl2.separatorColor = .systemGray2
            segmentedControl2.selectionBackgroundColor = .systemGray2
        } else {
            segmentedControl2.backgroundColor = .clear
            segmentedControl2.borderColor = .lightGray
            segmentedControl2.selectionBackgroundColor = .lightGray
            segmentedControl2.separatorColor = .lightGray
        }
        
        segmentedControl2.borderWidth = 2
        segmentedControl2.separatorWidth = 2
        segmentedControl2.cornerRadius = 10
    }
}
