//
//  CandidateListViewModel.swift
//  Meditech
//
//  Created by shomil on 24/08/22.
//

import Foundation
import CoreData

class CandidateDetailViewModel {
    var objCountryDataList: BehaviorRelay<[CountryListData]?> = .init(value: nil)
    var objStateDataList: BehaviorRelay<[CountryListData]?> = .init(value: nil)
    var objCityDataList: BehaviorRelay<[CountryListData]?> = .init(value: nil)
    var stateUrl: String = ""
}

//MARK: Public methods
extension CandidateDetailViewModel {
    func getCountryList(_ loaderInView: UIView? = nil, completion: @escaping (_ error: String?, _ stateList : [CountryListData]?) -> ()) {
        
        ApiCall().dataRequest(with: WebServiceURL.countryList, objectType: [CountryListData].self) { [weak self] (result: Result) in
            switch result {
            case .success(let object):
                self?.objCountryDataList.accept(object)
                print(object)
            case .failure(let error):
                print(error)
            case .error(let error):
                print(error)
            }
        }
    }
    
    func getStateList(_ loaderInView: UIView? = nil,country: String, completion: @escaping (_ error: String?, _ stateList : [CountryListData]?) -> ()) {
          
         stateUrl = "/" + country + "/states"
        ApiCall().dataRequest(with: WebServiceURL.countryList + stateUrl, objectType: [CountryListData].self) { [weak self] (result: Result) in
            switch result {
            case .success(let object):
                self?.objStateDataList.accept(object)
                print(object)
            case .failure(let error):
                print(error)
            case .error(let error):
                print(error)
            }
        }
    }

    func getCityList(_ loaderInView: UIView? = nil,country: String,state: String, completion: @escaping (_ error: String?, _ stateList : [String]?) -> ()) {

        let cityUrl = stateUrl + "/" + state + "/cities"
        ApiCall().dataRequest(with: WebServiceURL.countryList + cityUrl, objectType: [CountryListData].self) { [weak self] (result: Result) in
            switch result {
            case .success(let object):
                self?.objCityDataList.accept(object)
                print(object)
            case .failure(let error):
                print(error)
            case .error(let error):
                print(error)
            }
        }
    }
    
    func setCandidateData(_ loaderInView: UIView? = nil, fullName: String, email: String, phoneNo: String, country: String, state: String, city: String, image: Data? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "CandidateDetails", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(fullName, forKey: WebServiceParameter.fullName)
        user.setValue(email, forKey: WebServiceParameter.email)
        user.setValue(phoneNo, forKey: WebServiceParameter.phone)
        user.setValue(country, forKey: WebServiceParameter.country)
        user.setValue(state, forKey: WebServiceParameter.state)
        user.setValue(city, forKey: WebServiceParameter.city)
        user.setValue(image, forKey: WebServiceParameter.image)

        do {
            try managedContext.save()
            print("Data saved sucessfully")
        } catch let error as Error {
            UIApplication.topViewController()?.view.makeToast(error.localizedDescription)
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func updateCandidateData(_ loaderInView: UIView? = nil, fullName: String, email: String, phoneNo: String, country: String, state: String, city: String, image: Data? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "CandidateDetails", in : managedContext)
            let request = NSFetchRequest < NSFetchRequestResult > ()
            request.entity = entity
            let predicate = NSPredicate(format: "(\(WebServiceParameter.email) = %@)", email)
            request.predicate = predicate
            do {
                let results =
                    try managedContext.fetch(request)
                let user = results[0] as!NSManagedObject
                user.setValue(fullName, forKey: WebServiceParameter.fullName)
                user.setValue(email, forKey: WebServiceParameter.email)
                user.setValue(phoneNo, forKey: WebServiceParameter.phone)
                user.setValue(country, forKey: WebServiceParameter.country)
                user.setValue(state, forKey: WebServiceParameter.state)
                user.setValue(city, forKey: WebServiceParameter.city)
                user.setValue(image, forKey: WebServiceParameter.image)
                do {
                    try managedContext.save()
                    print("Record Updated!")
                } catch
                let error as NSError {
                    UIApplication.topViewController()?.view.makeToast(error.localizedDescription)
                }
            } catch
            let error as NSError {
                UIApplication.topViewController()?.view.makeToast(error.localizedDescription)
            }
    }
}
