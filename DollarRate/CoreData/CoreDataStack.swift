//
//  CoreDataStack.swift
//  DollarRate
//
//  Created by Кирилл Тила on 25.06.2021.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack {
    
    weak var delegate: RateViewControllerDelegate?
    
    private(set) lazy var persistnentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RateData")
        container.loadPersistentStores { storeDesription, error in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistnentContainer.viewContext
    }

    
    func fetchRate() -> [RateDataModel]? {
        let request: NSFetchRequest<RateDataModel> = RateDataModel.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("Данные получить не удалось.")
        }
    }
    
    func setRate(content: Rate) {
        let context = persistnentContainer.viewContext
        let currentRate = fetchRate()
        if let currentRate = currentRate  {
            updateRate(context: context, content: content, currentRate: currentRate)
        } else {
            addNewRate(context: context, content: content)
        }

    }
    
    private func addNewRate(context: NSManagedObjectContext, content: Rate) {
        let newRate = RateDataModel(context: context)
        context.perform {
            newRate.date = content.date
            newRate.value = content.value
            
            self.save(context: context)
        }
    }
    
    private func updateRate(context: NSManagedObjectContext, content: Rate, currentRate: [RateDataModel]) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(RateDataModel.value), currentRate[0].value)
        let request: NSFetchRequest<RateDataModel> = RateDataModel.fetchRequest()
        request.predicate = predicate
        context.perform {
            do {
                let results = try context.fetch(request)
                let result = results[0]
                guard currentRate != results else { return }
                if content.value > result.value {
                    self.delegate?.updateValueAlert(oldValue: result.value, newValue: content.value)
                }
                result.setValue(content.value, forKey: #keyPath(RateDataModel.value))
            
            } catch {
                print(error)
            }
            do {
                try context.save()
            } catch {
                print("Сохранить данные не удалось\(error)")
            }
        }

    }
    
    
    private func save(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print(error)
            
        }
    }
        
}




