//
//  CountryListModel.swift
//  Meditech
//
//  Created by shomil on 23/08/22.
//


import Foundation

//struct CountryListModel: Codable {
//    let error: Bool?
//    let msg: String?
//    let data: [CountryData]?
//}
//struct StateListModel: Codable {
//    let error: Bool?
//    let msg: String?
//    let data: CountryData?
//}
//
//// MARK: - DataClass
//struct CountryData: Codable {
//    let name, iso3, iso2: String?
//    let states: [State]?
//}
//
//// MARK: - State
//struct State: Codable {
//    let name, stateCode: String?
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case stateCode = "state_code"
//    }
//}
//
//
//struct CityListModel: Codable {
//    let error: Bool?
//    let msg: String?
//    let data: [String]?
//}

struct CountryListData: Codable {
    let id: Int?
    let name, iso2: String?
}

