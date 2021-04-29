//
//  AddContactVCViewController.swift
//  Learn-Contact
//
//  Created by Le Tuan on 29/04/2021.
//

import UIKit
import Contacts

class AddContactVCViewController: UIViewController {
    
    @IBOutlet weak var viewAddContact: UIView!
    @IBOutlet weak var tftGivenName: UITextField!
    @IBOutlet weak var tftFamilyName: UITextField!
    @IBOutlet weak var tftMiddleName: UITextField!
    @IBOutlet weak var tftPhoneNumber: UITextField!
    var delegate:DelegateBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        viewAddContact.backgroundColor = UIColor(hex: "80A4ED")
        viewAddContact.layer.cornerRadius = 20
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlertError() {
        let alert = UIAlertController(title: "", message: "Invalid value", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.tftPhoneNumber.text?.removeAll()
            self.tftMiddleName.text?.removeAll()
            self.tftFamilyName.text?.removeAll()
            self.tftGivenName.text?.removeAll()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showWarningErorr(error: Error) {
        let alert = UIAlertController(title: "", message: "Invalid value", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.tftPhoneNumber.text?.removeAll()
            self.tftMiddleName.text?.removeAll()
            self.tftFamilyName.text?.removeAll()
            self.tftGivenName.text?.removeAll()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccess() {
        let alert = UIAlertController(title: "", message: "Add Success", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] action in
            delegate?.back()
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func checkException() -> Bool {
        if let givenName = tftGivenName.text, let familyName = tftFamilyName.text, let middleName = tftMiddleName.text, let phoneNumber = tftPhoneNumber.text {
            if phoneNumber.count < 10 {
                return false
            }
            return true
        }
        return false
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if checkException() {
            let contact = CNMutableContact()
            contact.middleName = tftMiddleName.text!
            contact.givenName = tftGivenName.text!
            contact.familyName = tftFamilyName.text!
            let homePhone = CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: tftPhoneNumber.text!))
            contact.phoneNumbers = [homePhone]
            ContactHelper.shared.addContact(contact: contact) { [self] success, error in
                if success {
                    showSuccess()
                }
                else {
                    showWarningErorr(error: error!)
                }
            }
        }
        else {
            showAlertError()
        }
    }
    
}

protocol DelegateBack {
    func back()
}
