//
//  CandidateListVC.swift
//  Meditech
//
//  Created by shomil on 25/08/22.
//

import UIKit

class CandidateListVC: UIViewController,MainStoryboarded {
    
    @IBOutlet weak var tblCandidateList: UITableView!
    
    var viewModel = CandidateListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCandidateData()
        tblCandidateList.dataSource = self
        tblCandidateList.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCandidateData()
        tblCandidateList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        if !isBeingPresented && !isMovingToParent {
            self.tblCandidateList.reloadData()
        }
    }
    
    @IBAction func btnAddCandidateDetailAction(_ sender: Any) {
        let objCandidateDetailVC = CandidateDetailVC.instantiate()
        objCandidateDetailVC.isRegister = false
        self.navigationController?.pushViewController(objCandidateDetailVC)
    }
}


extension CandidateListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objCandidateList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCandidateList.dequeueReusableCell(withIdentifier: "CandidateListTblCell", for: indexPath) as! CandidateListTblCell
        let arrCandidateList = viewModel.objCandidateList.value
        cell.lblCandidateName.text = arrCandidateList?[indexPath.row].full_name
        cell.lblCandidateEmail.text = arrCandidateList?[indexPath.row].email
        cell.lblCandidatePhoneNo.text = arrCandidateList?[indexPath.row].phone
        if arrCandidateList?[indexPath.row].image.count == 0 {
            cell.imgCandidate.image = UIImage(named: "Profile")
        } else {
            if let imageData = arrCandidateList?[indexPath.row].image {
                if let image = UIImage(data:imageData as Data) {
                    cell.imgCandidate.image = image
                }
            }
        }
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objCandidateDetailVC = CandidateDetailVC.instantiate()
        objCandidateDetailVC.objCandidateData = viewModel.objCandidateList.value?[indexPath.row]
        objCandidateDetailVC.indexPath = indexPath.row
        objCandidateDetailVC.isRegister = true
        self.navigationController?.pushViewController(objCandidateDetailVC)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.deleteCandidateData(email: viewModel.objCandidateList.value?[indexPath.row].email ?? "abc")
            var arr = viewModel.objCandidateList.value
            arr?.remove(at: indexPath.row)
            viewModel.objCandidateList.accept(arr)
            tblCandidateList.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
