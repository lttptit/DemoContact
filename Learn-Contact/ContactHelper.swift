//
//  ContactHelper.swift
//  Learn-Contact
//
//  Created by Le Tuan on 29/04/2021.
//

import Foundation
import Contacts
import UIKit

class ContactHelper {
    
    public static let shared = ContactHelper()
    var store = CNContactStore()
    
    func checkFirstPermission() -> Bool {
        var returnFlag = false
        store.requestAccess(for: .contacts) { success, error  in
            if success {
                returnFlag = true
            }
            else {
                returnFlag = false
            }
        }
        return returnFlag
    }
    
    func checkPermission() -> Bool {
        if checkFirstPermission() {
            return true
        }
        showAlertAccessContact()
        return false
    }
    
    func showAlertAccessContact() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to Send top-up.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        UIApplication.getTopViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func addContact(contact: CNMutableContact, completion: @escaping (_ success: Bool, _ error: Error?)->Void) {
        if checkPermission() {
            let request = CNSaveRequest()
            request.add(contact, toContainerWithIdentifier: nil)
            do {
                try store.execute(request)
                completion(true, nil)
            } catch let err {
                completion(false, err)
            }
        }
    }
    
    func getAllContact() -> [CNContact]? {
        if checkPermission() {
            var contacts = [CNContact]()
            let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey
            ] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
            do {
                try store.enumerateContacts(with: request) {
                    (contact, stop) in
                    contacts.append(contact)
                }
            }
            catch {
                print("unable to fetch contacts")
            }
            return contacts
        }
        return nil
    }
    
    func getContact(id: String) {
        if checkPermission() {
            OperationQueue().addOperation{[unowned store] in
                let id = "\(id)"
                let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
                do{
                    let contact = try store.unifiedContact(withIdentifier: id,
                                                           keysToFetch: toFetch as [CNKeyDescriptor])
                    
                } catch let err{
                    print(err)
                }
            }
        }
    }
    
    func updateContact(id: String) {
        if checkPermission() {

        }
    }
    
    func deleteContact(id: String) {
        if checkPermission() {
            OperationQueue().addOperation{[unowned store] in
                let id = "\(id)"
                let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
                do{
                    let contact = try store.unifiedContact(withIdentifier: id,
                                                           keysToFetch: toFetch as [CNKeyDescriptor])
                    
                    let req = CNSaveRequest()
                    let mutableContact = contact.mutableCopy() as! CNMutableContact
                    req.delete(mutableContact)
                    
                    do{
                        try store.execute(req)
                        print("Successfully deleted the user")
                        
                    } catch let e{
                        print("Error = \(e)")
                    }
                    
                } catch let err{
                    print(err)
                }
            }
        }
    }
    
    func deleteAllContact() {
        if checkPermission() {
            
        }
    }
    
    func getNamePhoneNumberContact(contact: CNContact) -> (name: String, phoneNumber: String) {
        for phoneNumber in contact.phoneNumbers {
            if let number = phoneNumber.value as? CNPhoneNumber {
                return ("\(contact.familyName) \(contact.middleName) \(contact.givenName)", "\(number.stringValue.removeWhitespace())")
            }
        }
        return ("", "")
    }
    
}
