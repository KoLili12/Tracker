//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Николай Жирнов on 10.05.2025.
//

import Foundation

final class CategoryViewModel {
    private var header: String
    
    init(header: String) {
        self.header = header
    }
    
    var headerBinding: Binding<String>? {
        didSet {
            headerBinding?(header)
        }
    }
}
