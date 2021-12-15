//
//  AppDelegate.swift
//  MyApp
//
//  Created by Fernando Farias on 22/10/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    /* func completionHandler: ([Track]?, Error?) -> Void {
        print("hola")
    } */

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /* let api = APIManager()
        api.getMusic(completion: { (_, error) in
            if error == nil {
                print("tracklist fetch complete")
            } else {
                print(error!)
            }
        }) */
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory,
                                                                   in: .userDomainMask).last ?? "Not Found")

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         /* Called when the user discards a scene session.
         If any sessions were discarded while the application was not running, this will be called shortly
         after application:didFinishLaunchingWithOptions.
          Use this method to release any resources that were specific to the discarded scenes,
          as they will not return. */
    }

    // MARK: - COREDATA STUFF
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Fatal error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Error: \(nsError), \(nsError.userInfo)")
            }
        }
    }

    lazy var applicationDocumentsDirectory: NSURL = {
        /* The directory the application uses to store the Core Data store file.
         This code uses a directory in the application’s documents Application Support directory. */
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
      }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        /* The managed object model for the application. This property is not optional.
         It is a fatal error for the application not to be able to find and load its model. */
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel:
                                                                                        self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Model.sqlite")
        var error: NSError?
        var failureReason = "There was an error creating or loading the application’s saved data."
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                              NSInferMappingModelAutomaticallyOption: true]
        do {
          try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType,
                                              configurationName: nil, at: url, options: mOptions)
        } catch {
        }
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        /* Returns the managed object context for the application (which is already bound to the persistent
         store coordinator for the application.). This property is optional since there are
         legitimate error conditions that could cause the creation of the context to fail. */
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
          return nil
        }
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

}
