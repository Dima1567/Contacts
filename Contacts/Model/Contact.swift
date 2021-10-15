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

