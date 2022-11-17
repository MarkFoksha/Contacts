import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var storage: ContactStorageProtocol!
    
    private var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort(by: { $0.title < $1.title })
            storage.save(contacts: contacts)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
    }
    
    private func loadContacts() {
        contacts = storage.load()
    }
    
    @IBAction func showNewContactAlert() {
        let alert = UIAlertController(title: "Create new contact", message: "Enter name and phone number", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Phone number"
        }
        let createButton = UIAlertAction(title: "Create", style: .default) { _ in
            guard let name = alert.textFields?[0].text, let number = alert.textFields?[1].text else { return }
            let newContact = Contact(title: name, number: number)
            self.contacts.append(newContact)
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(createButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK: DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "contactCellIdentifier") {
            print("Reuse a cell with number = \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Create a new cell with number = \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "contactCellIdentifier")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].number
        cell.contentConfiguration = configuration
    }
}

//MARK: Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("Define allowed actions for row = \(indexPath.row)")
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.contacts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        return actions
    }
    
}
