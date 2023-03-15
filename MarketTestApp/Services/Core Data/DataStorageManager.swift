import Foundation
import CoreData

enum CoreDataError:Error {
    case error(errorText:String)
}

final class DataStorageManager {
    
    static let shared = DataStorageManager()
    
    private lazy var viewContext:NSManagedObjectContext = {
        self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: Resources.CoreData.coreDataName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("\(error) \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    private func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                throw CoreDataError.error(errorText: "Unresolver error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    public func loadLocalUsers() throws -> [User] {
        let fetchRequest = User.fetchRequest()
        var fetchedUsers:[User] = []
        do {
            fetchedUsers = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            throw CoreDataError.error(errorText: "Error loading users: \(error.localizedDescription)")
        }
        return fetchedUsers
    }
    
    public func createUser(email:String, firstName:String, secondName:String) throws {
        let newUser = User(context: persistentContainer.viewContext)
        newUser.email = email
        newUser.firstName = firstName
        newUser.secondName = secondName
        do {
            var localUsers = try self.loadLocalUsers()
            localUsers.append(newUser)
            try self.saveContext()
        } catch let error {
            throw CoreDataError.error(errorText: "Failed to save user: \(error.localizedDescription)")
        }
    }
}
