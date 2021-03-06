//
//  AppDelegate.swift
//  Morsing
//
//  Created by Paloma Bispo on 07/01/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .backgoundGray
        //setup coredata
        let isDataSetup = UserDefaults.standard.bool(forKey: "isDataSetup")
        if !isDataSetup{
            setupCoreData()
        }
        //setup configs
        let configUser = UserDefaults.standard.bool(forKey: "setupConfigUser")
        if !configUser{
            setupConfigUser()
        }
        //checking if launched before
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            let tabBarController = UITabBarController()
            tabBarController.setup()
            window?.rootViewController = tabBarController
        }else{
            let onboardingViewController = OnboardingViewController()
             let onboardingNavControler = UINavigationController.init(rootViewController: onboardingViewController)
            
            window?.rootViewController = onboardingNavControler
        }
        
        window?.makeKeyAndVisible()
        //setupCoreData()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: - Setups
    private func setupConfigUser(){
         UserDefaults.standard.set(true, forKey: "setupConfigUser")
        SettingManager.setSound(true)
        SettingManager.setVibrating(true)
    }
    
    private func setupCoreData(){
        //setting userDefaults
        UserDefaults.standard.set(true, forKey: "isDataSetup")
        //setting CoreData
        guard let letters = Item.letters(), let numbers = Item.numbers() else {return}
        for item in letters {
            let letter = Letters(context: CoreDataManager.shared.getContext())
            letter.done = false
            letter.letter = item.text
            do {
            letter.morse = try NSKeyedArchiver.archivedData(withRootObject: item.morse, requiringSecureCoding: false)
            }catch{
                print(error)
            }
            CoreDataManager.shared.saveContext()
        }
        for item in numbers{
            let number = Numbers(context: CoreDataManager.shared.getContext())
            number.done = false
            number.number = item.text
            do {
                number.morse = try NSKeyedArchiver.archivedData(withRootObject: item.morse, requiringSecureCoding: false)
            }catch{
                print(error)
            }
            CoreDataManager.shared.saveContext()
        }
    }
}

