//
//  CandidateListViewModel.swift
//  Meditech
//
//  Created by shomil on 25/08/22.
//

import Foundation
import CoreData
import UIKit

class CandidateListViewModel {
    var objCandidateList: BehaviorRelay<[CandidateData]?> = .init(value: nil)
    var objCandidate : [NSManagedObject] = []
}

//MARK: Public methods
extension CandidateListViewModel {
    
    func getCandidateData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<CandidateDetails> = CandidateDetails.fetchRequest()
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            objCandidateList.accept(result.map { CandidateData.init(entry: $0) })
            print(result.debugDescription)
        } catch let error {
            UIApplication.topViewController()?.view.makeToast(error.localizedDescription)
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func deleteCandidateData(email: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CandidateDetails>(entityName: "CandidateDetails")
        fetchRequest.predicate = NSPredicate(format: "\(WebServiceParameter.email) = %@", email)
        
        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            objCandidate = fetchResult as [CandidateDetails]
            for result in fetchResult {
                print(fetchResult.debugDescription)
                managedContext.delete(result)
            }
            do {
                try managedContext.save()
            } catch let error {
                UIApplication.topViewController()?.view.makeToast(error.localizedDescription)
                print("Could not save. \(error), \(error.localizedDescription)")
            }
        } catch let error {
            UIApplication.topViewController()?.view.makeToast(error.localizedDescription)
            print("Could not delete. \(error), \(error.localizedDescription)")
        }
    }
    
}
