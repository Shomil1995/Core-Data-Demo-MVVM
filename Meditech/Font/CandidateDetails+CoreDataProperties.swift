//
//  CandidateDetails+CoreDataProperties.swift
//  
//
//  Created by shomil on 25/08/22.
//
//

import Foundation
import CoreData


extension CandidateDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandidateDetails> {
        return NSFetchRequest<CandidateDetails>(entityName: "CandidateDetails")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var email: String?
    @NSManaged public var full_name: String?
    @NSManaged public var image: Data?
    @NSManaged public var phone: String?
    @NSManaged public var state: String?

}
