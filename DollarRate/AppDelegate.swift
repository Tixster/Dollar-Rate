//
//  AppDelegate.swift
//  DollarRate
//
//  Created by Кирилл Тила on 24.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rateVC = RateViewController(stack: coreDataStack)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rateVC
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    private func saveContext() {
        let context = coreDataStack.persistnentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("\(nsError), \(nsError.userInfo)")
            }
        }
    }
 


}

