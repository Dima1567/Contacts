//
//  ViewController.swift
//  Contacts
//
//  Created by Dima Savitskiy on 15.10.21.
//

import UIKit

class ViewController: UIViewController {
    
   
    private var contacts = [ContactProtocol]()
    
    private func loadContacts() {
        contacts.append(
            Contact(title: "Саня Техосмотр", phone: "+375251112233"))
        contacts.append(
            Contact(title: "Владимир Анатольевич", phone: "+375259990002"))
        contacts.append(
            Contact(title: "Сильвестр", phone: "+375254325500"))
        contacts.sort{ $0.title < $1.title }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
