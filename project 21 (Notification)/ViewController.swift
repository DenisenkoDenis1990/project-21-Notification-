//
//  ViewController.swift
//  project 21 (Notification)
//
//  Created by Denys Denysenko on 31.01.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yes")
            } else {
                print("No")
            }
        }
        
    }
    
    @objc func scheduleLocal() {
        
        registerCategory()
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        center.removeAllPendingNotificationRequests()
        content.title = "Late wake up call"
        content.body = "The early birds catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 13
        dateComponents.minute = 45
       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    func registerCategory () {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let remindMeLater = UNNotificationAction(identifier: "remind", title: "Remind Me Later", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
                print("Custom data received: \(customData)")

                switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    // the user swiped to unlock
                    let ac = UIAlertController(title: "Are you shure?", message: "", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    ac.addAction(action)
                    present(ac, animated: true)

                case "show":
                    // the user tapped our "show more info…" button
                    let ac = UIAlertController(title: "Are you shure?", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    ac.addAction(action)
                    present(ac, animated: true)
                    
                case "remind":
                    scheduleLocal()

                default:
                    break
                }
            }

            // you must call the completion handler when you're done
            completionHandler()
    }
}

