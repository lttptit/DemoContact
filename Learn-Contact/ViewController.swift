//
//  ViewController.swift
//  Learn-Contact
//
//  Created by Le Tuan on 29/04/2021.
//

import UIKit
import Contacts

class ViewController: UIViewController {

    @IBOutlet weak var tblContacts: UITableView!
    let CONTACT_CELL = "ContactCell"
    var contactHelper = ContactHelper.shared
    var dataContact: [CNContact]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupData() {
        dataContact = contactHelper.getAllContact()
        tblContacts.reloadData()
    }

    func setupUI() {
        view.backgroundColor = UIColor.init(hex: "E6E1C5")
        tblContacts.backgroundColor = UIColor.clear
        tblContacts.delegate = self
        tblContacts.dataSource = self
        tblContacts.register(UINib(nibName:CONTACT_CELL, bundle: nil), forCellReuseIdentifier: CONTACT_CELL)
    }
    

    
    @IBAction func actionAdd(_ sender: Any) {
        let vc = AddContactVCViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContact?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblContacts.dequeueReusableCell(withIdentifier: CONTACT_CELL) as? ContactCell
        if let dataContact = dataContact {
            cell?.lblName.text = contactHelper.getNamePhoneNumberContact(contact: dataContact[indexPath.row]).name
            cell?.lblNumber.text = contactHelper.getNamePhoneNumberContact(contact: dataContact[indexPath.row]).phoneNumber
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblContacts.frame.height/8
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contactHelper.deleteContact(id: dataContact![indexPath.row].identifier)
            setupData()
        }
    }
    
}

extension ViewController: DelegateBack {
    func back() {
        self.setupData()
    }
}

