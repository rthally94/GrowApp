//
//  PlantsProvider.swift
//  GrowApp
//
//  Created by Ryan Thally on 4/1/21.
//

import CoreData
import UIKit

class PlantsProvider: NSObject {
    typealias Section = String
    typealias Item = NSManagedObjectID
    
    let moc: NSManagedObjectContext
    fileprivate let fetchedResultsController: NSFetchedResultsController<SproutPlantMO>
    
    @Published var snapshot: NSDiffableDataSourceSnapshot<Section, Item>?

    init(managedObjectContext: NSManagedObjectContext) {
        self.moc = managedObjectContext
        
        let request: NSFetchRequest<SproutPlantMO> = SproutPlantMO.fetchRequest()
        let sortByNickname = NSSortDescriptor(keyPath: \SproutPlantMO.nickname, ascending: true)
        let sortByCommonName = NSSortDescriptor(keyPath: \SproutPlantMO.commonName, ascending: true)
        request.sortDescriptors = [sortByNickname, sortByCommonName]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    func object(at indexPath: IndexPath) -> SproutPlantMO {
        return fetchedResultsController.object(at: indexPath)
    }

    func object(withID id: NSManagedObjectID) -> SproutPlantMO? {
        return moc.object(with: id) as? SproutPlantMO
    }

    func reload() {
        try! fetchedResultsController.performFetch()
    }
}

extension PlantsProvider: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapshot = snapshot as NSDiffableDataSourceSnapshot<Section, Item>

        let idsToReload = newSnapshot.itemIdentifiers.filter { identifier in
            guard let oldIndex = self.snapshot?.indexOfItem(identifier),
                  let newIndex = newSnapshot.indexOfItem(identifier),
                  oldIndex != newIndex
            else { return false }

            guard (try? controller.managedObjectContext.existingObject(with: identifier))?.isUpdated == true else {
                return false
            }

            return true
        }

        newSnapshot.reloadItems(idsToReload)
        self.snapshot = newSnapshot
    }
}