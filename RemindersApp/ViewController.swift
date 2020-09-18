//
//  ViewController.swift
//  RemindersApp
//
//  Created by user on 2020-08-08.
//  Copyright © 2020 user. All rights reserved.
//
import UserNotifications //schedules notifications and takes authorization from the user to schedule notifications
import UIKit

class ViewController: UIViewController {
    //for the user to be able to see a list of their scheduled reminders, we need a table view.
    @IBOutlet var table: UITableView!
    
    
    //this array will hold the reminders
    
    
    var models = [MyReminder]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func didTapAdd(){
        //show add VC
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else{
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title,body,date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title=title
                content.sound = .default
                content.body = body
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "some_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapTest(){
        //test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound], completionHandler: {success, error in
            if success{
                //schedule test
                self.scheduleTest()
            }
            else if error != nil{
                print("error occured")
            }
        })
    }
    func scheduleTest(){
        //a notification has three main pieces, request,content parameter and trigger
        let content = UNMutableNotificationContent()
        content.title="Hello World"
        content.sound = .default
        content.body = "iOS Development is great and a little complicated to learn sometimes but fun."
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd,YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
}

//to hold array objects:
struct MyReminder{
    let title: String
    let date: Date
    let identifier: String
}
























