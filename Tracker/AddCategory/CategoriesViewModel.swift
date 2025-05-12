//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Николай Жирнов on 10.05.2025.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoriesViewModel {
    
    var allCategoriesBinding: Binding<[TrackerCategory]>?
    
    weak var delegate: BaseAddTrackerViewController?
    
    private(set) var allCategories: [TrackerCategory] = [] {
        didSet {
            allCategoriesBinding?(allCategories)
        }
    }
    
    private let store = TrackerCategoryStore()
    
    init() {
        store.delegate = self
    }
    
    func addCategory(header: String) {
        store.addCategory(with: header)
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        return store.fetchAllCategories()
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func updateCategories() {
        allCategories = fetchAllCategories()
    }
}
