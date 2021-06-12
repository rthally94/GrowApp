//
//  AnyModelStore.swift
//  Sprout
//
//  Created by Ryan Thally on 6/10/21.
//

import Foundation

protocol ModelStore {
    associatedtype Model: Identifiable
    func fetchByID(_ id: Model.ID) -> Model
}

class AnyModelStore<Model: Identifiable>: ModelStore {
    private var models = [Model.ID: Model]()

    init(_ models: [Model]) {
        self.models = models.groupingByUniqueID()
    }

    func fetchByID(_ id: Model.ID) -> Model {
        return self.models[id]!
    }
}

extension Sequence where Element: Identifiable {
    func groupingByID() -> [Element.ID: [Element]] {
        return Dictionary(grouping: self, by: { $0.id })
    }

    func groupingByUniqueID() -> [Element.ID: Element] {
        return Dictionary(uniqueKeysWithValues: self.map { ($0.id, $0) })
    }
}