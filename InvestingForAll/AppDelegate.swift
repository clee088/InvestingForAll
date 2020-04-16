//
//  AppDelegate.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		self.preloadData()
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	func preloadData() {
		
		let preloadedDataKey: String = "didPreloadData"
		
		let userDefaults = UserDefaults.standard
		
		if userDefaults.bool(forKey: preloadedDataKey) == false {
			//Preload Data
			
//			guard let urlPath: URL = Bundle.main.url(forResource: "PreloadedData", withExtension: "plist") else {
//				return
//			}
			
			let backgroundContext: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
			self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
			
			backgroundContext.perform {
				
				do {
					let portfolio = Portfolio(context: backgroundContext)
					
					portfolio.id = UUID()
					portfolio.name = "Cash"
					portfolio.symbol = "Cash"
					portfolio.sharePricePurchased = 1
					portfolio.shares = 1000
					portfolio.valuePurchased = portfolio.shares * portfolio.sharePricePurchased
					try? portfolio.color = NSKeyedArchiver.archivedData(withRootObject: UIColor.systemGreen, requiringSecureCoding: false)
					
					try backgroundContext.save()
					
					userDefaults.set(true, forKey: preloadedDataKey)
				} catch {
					print(error.localizedDescription)
				}
				
			}
			
		}
		
	}
	
	
	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "InvestingForAll")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}

