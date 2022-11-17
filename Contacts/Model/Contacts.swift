import Foundation
protocol ContactProtocol {
    var title: String {get set}
    var number: String {get set}
}

struct Contact: ContactProtocol {
    var title: String
    var number: String
}

protocol ContactStorageProtocol {
    func load() -> [ContactProtocol]
    func save(contacts: [ContactProtocol])
}

class ContactStorage: ContactStorageProtocol {
    private var storage = UserDefaults.standard
    private var storageKey = "contacts"
    
    private enum ContactKey: String {
        case title
        case number
    }
    
    func load() -> [ContactProtocol] {
        var resultContacts = [ContactProtocol]()
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String : String]] ?? []
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let number = contact[ContactKey.number.rawValue] else { continue }
            resultContacts.append(Contact(title: title, number: number))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage = [[String : String]]()
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.number.rawValue] = contact.number
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
