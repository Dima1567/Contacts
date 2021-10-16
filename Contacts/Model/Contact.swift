//
//  Contact.swift
//  Contacts
//
//  Created by Dima Savitskiy on 15.10.21.
//

import Foundation

protocol ContactProtocol {
    var title: String {get set}
    var phone: String {get set}
}

struct Contact: ContactProtocol {
    var title: String
    var phone: String
}

protocol ContactStorageProtocol {
    func load() -> [ContactProtocol]
    func save(contact: [ContactProtocol])
    }
class ContactStorege: ContactStorageProtocol {
    private var storage = UserDefaults.standard
    private var storageKey = "contacts"
    
    private enum ContactKey: String {
        case title
        case phone
    }
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    func save(contact: [ContactProtocol]) {
        var arrayForStorage: [[String:String]] = []
        contact.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}

