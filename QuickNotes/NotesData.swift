//
//  NotesData.swift
//  QuickNotes
//
//  Created by Suruchi Sinha on 10/04/17.
//  Copyright © 2017 Suruchi Sinha. All rights reserved.
//

import UIKit
import CoreData


class NotesDataModel: NSManagedObject {
    
    let entityName = "Note"
    
    func fetchData() -> ([Dictionary<String, AnyObject>]?){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        var fetchedResults: [Note]
        var fetchedData = Array<Dictionary<String, AnyObject>>()
        let objectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            fetchedResults = try objectContext.fetch(fetchRequest) as! [Note]
            for result in fetchedResults {
                let dataObject = ["title" : result.value(forKey: "title"), "notesText" : result.value(forKey: "detailText"), "timeStamp" : result.value(forKey: "timestamp"), "favStatus" : result.value(forKey: "favoriteStatus")]
                fetchedData.append(dataObject as [String : AnyObject])
            }
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        return fetchedData
    }
    
    func insertData(title: String, description: String, timeStamp: Date, favoriteStatus: Bool) throws{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let objectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: objectContext)
        let entityObject = NSManagedObject(entity: entity!, insertInto: objectContext)
        entityObject.setValue(title, forKey: "title")
        entityObject.setValue(timeStamp, forKey: "timestamp")
        entityObject.setValue(description, forKey: "detailText")
        entityObject.setValue(favoriteStatus, forKey: "favoriteStatus")
        do {
            try objectContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteData(row: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let objectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fetchResults = try objectContext.fetch(fetchRequest) as! [Note]
            objectContext.delete(fetchResults[row])
            try objectContext.save()
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
