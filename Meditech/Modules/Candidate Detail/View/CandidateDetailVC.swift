//
//  ViewController.swift
//  Meditech
//
//  Created by shomil on 23/08/22.
//

import UIKit

class CandidateDetailVC: UIViewController,MainStoryboarded {
    
    @IBOutlet weak var txtFullName: FloatLabelTextField!
    @IBOutlet weak var txtEmail: FloatLabelTextField!
    @IBOutlet weak var txtPhoneNo: PhoneNumberTextField!
    @IBOutlet weak var txtCountry: FloatLabelTextField!
    @IBOutlet weak var txtState: FloatLabelTextField!
    @IBOutlet weak var txtCity: FloatLabelTextField!
    @IBOutlet weak var vStateList: UIView!
    @IBOutlet weak var vCityList: UIView!
    @IBOutlet weak var vCountryList: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    var pickerCountry = UIPickerView()
    var pickerState = UIPickerView()
    var pickerCity = UIPickerView()
    var arrSelectAll  =  ["*"]
    var viewModel = CandidateDetailViewModel()
    var imgProfile: Data? = nil
    var objCandidateData :  CandidateData?
    var indexPath : Int?
    var isRegister = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vStateList.isUserInteractionEnabled = false
        vCityList.isUserInteractionEnabled = false
        if isRegister {
            txtFullName.text = objCandidateData?.full_name
            txtEmail.text = objCandidateData?.email
            txtPhoneNo.text = objCandidateData?.phone
            txtCountry.text = objCandidateData?.country
            txtState.text = objCandidateData?.state
            txtCity.text = objCandidateData?.city
            if let imageData = objCandidateData?.image {
                if let image = UIImage(data: imageData as Data) {
                    imgUserProfile.image = image
                }
            }
        }
        wsCountryList()
        setInitialViews()
        imgUserProfile.addTapGestureRecognizer { [weak self] in
            self?.takeAndChoosePhoto()
        }
    }
    
    func setInitialViews() {
        txtPhoneNo.withPrefix = true
        txtPhoneNo.withFlag = true
        txtPhoneNo.withExamplePlaceholder = true
        txtPhoneNo.withDefaultPickerUI = true
        
        pickerCountry.delegate = self
        pickerCountry.dataSource = self
        txtCountry.inputView = pickerCountry
        txtCountry.delegate = self
        
        pickerState.delegate = self
        pickerState.dataSource = self
        txtState.inputView = pickerState
        txtState.delegate = self
        
        pickerCity.delegate = self
        pickerCity.dataSource = self
        txtCity.inputView = pickerCity
        txtCity.delegate = self
    }
    
    func wsCountryList() {
        viewModel.getCountryList() { [weak self] error, stateList in
            if let _ = error { return }
        }
    }
    
    func wsStateList(country : String) {
        viewModel.getStateList( country: country) { [weak self] error, stateList in
            if let _ = error { return }
            self?.pickerState.reloadAllComponents()
        }
    }
    
    func wsCityList(country : String, state: String) {
        viewModel.getCityList( country: country, state: state) { [weak self] error, cityList in
            if let _ = error { return }
            self?.pickerCity.reloadAllComponents()
        }
        vCityList.isUserInteractionEnabled = true
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        if txtFullName.isEmpty {
            self.view.makeToast(AlertMessage.fullName)
        } else if txtEmail.isEmpty {
            self.view.makeToast(AlertMessage.email)
        } else if !(txtEmail.validateEmail()) {
            self.view.makeToast(AlertMessage.validEmail)
        } else if txtPhoneNo.isEmpty {
            self.view.makeToast(AlertMessage.phone)
        } else if !txtPhoneNo.isValidNumber {
            self.view.makeToast(AlertMessage.validphone)
        } else if txtCountry.isEmpty {
            self.view.makeToast(AlertMessage.country)
        } else if txtState.isEmpty {
            self.view.makeToast(AlertMessage.state)
        } else {
            if isRegister {
                viewModel.updateCandidateData(btnSave, fullName: txtFullName.text ?? "SP", email: txtEmail.text ?? "sp@gmail.com", phoneNo: txtPhoneNo.text ?? "+919876543210", country: txtCountry.text ?? "India", state: txtState.text ?? "Gujarat", city: txtCity.text ?? "Ahmedabad", image: imgProfile)
            } else {
                viewModel.setCandidateData(btnSave, fullName: txtFullName.text ?? "SP", email: txtEmail.text ?? "sp@gmail.com", phoneNo: txtPhoneNo.text ?? "+919876543210", country: txtCountry.text ?? "India", state: txtState.text ?? "Gujarat", city: txtCity.text ?? "Ahmedabad", image: imgProfile)
            }
            self.popVC()
        }
    }
}


extension CandidateDetailVC : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerCountry :
            return viewModel.objCountryDataList.value?.count ?? 0
        case pickerState :
            if viewModel.objStateDataList.value?.count == 0 {
                return 1
            } else {
                return viewModel.objStateDataList.value?.count ?? 0
            }
        case pickerCity :
            if viewModel.objCityDataList.value?.count == 0 || viewModel.objStateDataList.value?.count == 0 {
                return 1
            } else {
                return viewModel.objCityDataList.value?.count ?? 0
            }
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerCountry :
            return viewModel.objCountryDataList.value?[row].name
        case pickerState :
            if viewModel.objStateDataList.value?.count == 0 {
                return arrSelectAll[row]
            } else {
                return viewModel.objStateDataList.value?[row].name
            }
        case pickerCity :
            if viewModel.objCityDataList.value?.count == 0 || viewModel.objStateDataList.value?.count == 0 {
                return arrSelectAll[row]
            } else {
                return viewModel.objCityDataList.value?[row].name
            }
        default :
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerCountry :
            txtCountry.text = viewModel.objCountryDataList.value?[row].name
            viewModel.objStateDataList.accept([])
            wsStateList(country: viewModel.objCountryDataList.value?[row].iso2 ?? "IN")
            txtState.text = nil
            txtCity.text = nil
            vStateList.isUserInteractionEnabled = true
        case pickerState :
            if viewModel.objStateDataList.value?.count == 0 {
                txtState.text = arrSelectAll[row]
                vCityList.isUserInteractionEnabled = true
            } else {
                txtState.text = viewModel.objStateDataList.value?[row].name
                wsCityList(country: viewModel.objCountryDataList.value?[row].iso2 ?? "IN", state: viewModel.objStateDataList.value?[row].iso2 ?? "MH")
            }
            txtCity.text = nil
        case pickerCity :
            if viewModel.objCityDataList.value?.count == 0 || viewModel.objStateDataList.value?.count == 0 {
                txtCity.text = arrSelectAll[row]
            } else {
                txtCity.text = viewModel.objCityDataList.value?[row].name
            }
        default :
            break
        }
    }
}



extension CandidateDetailVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case txtCountry :
            return false
        case txtState :
            return false
        case txtCity :
            return false
        default:
            return true
        }
    }
    
}

extension CandidateDetailVC : ChoosePicture , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage : UIImage!
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            newImage = possibleImage
        }
        else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            newImage = possibleImage
        }
        guard newImage != nil else {
            picker.dismiss(animated: true)
            return
        }
        let orientationFixedImage = newImage.fixOrientation()
        
        imgUserProfile.image = orientationFixedImage
        imgUserProfile.contentMode = .scaleAspectFill
        
        guard let filePath = saveImage(data: orientationFixedImage.jpegData(compressionQuality: 0.5)!) else {
            picker.dismiss(animated: true)
            return
        }
        
        imgProfile = orientationFixedImage.jpegData(compressionQuality: 0.5)
        
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
