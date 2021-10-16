//
//  ViewController.swift
//  Contacts
//
//  Created by Dima Savitskiy on 15.10.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBAction func showNewContactAllert() {
        let aletrController = UIAlertController(title: "Создать новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        aletrController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        aletrController.addTextField { textField in
            textField.placeholder = "Номер телефона"
        }
        let createButton = UIAlertAction(title: "Создать", style: .default) {
            _ in
            guard let contactName = aletrController.textFields?[0].text,
            let contactPhone = aletrController.textFields?[1].text else {
                return
            }
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        aletrController.addAction(cancelButton)
        aletrController.addAction(createButton)
        
        self.present(aletrController, animated: true, completion: nil)
        
    }
    
    
    private var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort{ $0.title < $1.title }
            storage.save(contact: contacts)
        }
    }
    
    private func loadContacts() {
        contacts = storage.load()
    }

    var storage: ContactStorageProtocol!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
        storage = ContactStorege()
        loadContacts()
    }
}

extension ViewController: UITableViewDataSource {
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPart: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") {_,_,_ in
            self.contacts.remove(at: indexPart.row)
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}
