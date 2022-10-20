//
//  CandidateModel.swift
//  Meditech
//
//  Created by shomil on 25/08/22.
//

import Foundation


class CandidateData {

    var full_name: String
    var email: String
    var phone: String
    var country: String
    var state: String
    var city: String
    var image: Data
    

    init(entry: CandidateDetails) {
        full_name = entry.full_name ?? "abc"
        email = entry.email ?? "abc"
        phone = entry.phone ?? "abc"
        country = entry.country ?? "abc"
        state = entry.state ?? "abc"
        image = entry.image ?? Data()
        city = entry.city ?? "abc"
    }
}
