//
//  TaskCalendarFetchedResultsController.swift
//  GrowApp
//
//  Created by Ryan Thally on 3/31/21.
//

import UIKit
import CoreData

class TaskCalendarProvider: NSObject {
    let storage: StorageProvider
    fileprivate let fetchedResultsController: NSFetchedResultsController<GHTask>
    
    @Published var snapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>?
    
    init(storageProvider: StorageProvider) {
        self.storage = storageProvider
        
        let request: NSFetchRequest<GHTask> = GHTask.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GHTask.plant?.name, ascending: true)]
        
        // TODO: Add support to fetch for a specific day
        let intervalPredicate = GHTask.isDateInIntervalPredicate(Date())
        print(intervalPredicate.predicateFormat)
        request.predicate = NSPredicate(format: "SUBQUERY(interval, $x, \(intervalPredicate.predicateFormat)).@count > 0")
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: storageProvider.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    func object(at indexPath: IndexPath) -> GHTask {
        return fetchedResultsController.object(at: indexPath)
    }
}

extension TaskCalendarProvider: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        let idsToReload = newSnapshot.itemIdentifiers.filter({ identifier in
            guard let oldIndex = self.snapshot?.indexOfItem(identifier), let newIndex = newSnapshot.indexOfItem(identifier), oldIndex == newIndex else { return false}
            
            guard (try? controller.managedObjectContext.existingObject(with: identifier))?.isUpdated == true else { return false }
            
            return true
        })
        
        newSnapshot.reloadItems(idsToReload)
        
        self.snapshot = newSnapshot
    }
}