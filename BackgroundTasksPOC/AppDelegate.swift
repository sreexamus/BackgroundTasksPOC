//
//  AppDelegate.swift
//  BackgroundTasksPOC
//
//  Created by iragam reddy, sreekanth reddy on 11/22/20.
//

import UIKit
import BackgroundTasks

///  ********
/// use below command to test the background processing
/// after the task is submitted to the system then run below command to call the registered method
/// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.sree.epoc.processingTask"]
/// for ref  https://uynguyen.github.io/2020/09/26/Best-practice-iOS-background-processing-Background-App-Refresh-Task/
/// *********

let backgroundTaskName = "com.sree.epoc.processingTask"
let appRefreshTask = "com.sree.epoc.appRefreshTask"
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.setValue("false", forKey: "isAppRefreshTask")
        UserDefaults.standard.setValue("false", forKey: "isProcessingTask")
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskName, using: nil) { (task) in
            print("background task triggered")
            self.handleBGProcessingTask(task as! BGProcessingTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: appRefreshTask, using: nil) { (task) in
            print("background task triggered")
            self.handleBGAppRefreshTask(task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    func handleBGProcessingTask(_ task: BGProcessingTask) {
        task.expirationHandler = {
            // TODO
        }
        UserDefaults.standard.setValue("true", forKey: "isProcessingTask")
        print("background called")
        scheduleLocalNotification(name: "App Processing")
        task.setTaskCompleted(success: true)
    }
    
    func handleBGAppRefreshTask(_ task: BGAppRefreshTask) {
        task.expirationHandler = {
            // TODO
        }
        UserDefaults.standard.setValue("true", forKey: "isAppRefreshTask")
        print("background called")
        scheduleLocalNotification(name: "App Refresh")
        task.setTaskCompleted(success: true)
    }
    
    
    func startBGProcessingTask() {
        print("flushDataBackground called")
        let request = BGProcessingTaskRequest(identifier: backgroundTaskName)
        request.requiresNetworkConnectivity = false // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = true
        
        // request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // Featch Image Count after 1 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule image fetch: \(error)")
        }
        print("submitted request")
    }
    
    func startBGAppRefreshTask() {
        let appRefreshTaskReq = BGAppRefreshTaskRequest(identifier: appRefreshTask)
        // appRefreshTaskReq.earliestBeginDate = Date(timeIntervalSinceNow: 60)

        do {
          try BGTaskScheduler.shared.submit(appRefreshTaskReq)
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
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
    
    func scheduleLocalNotification(name: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification(name: name)
            }
        }
    }
    
    func fireNotification(name: String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "POC \(name)"
        notificationContent.body = "POC Background details"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }


}

