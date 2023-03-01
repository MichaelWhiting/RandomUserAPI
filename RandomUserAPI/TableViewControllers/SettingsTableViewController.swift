//
//  SettingsTableViewController.swift
//  RandomUserAPI
//
//  Created by Michael Whiting on 2/27/23.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var userAmountLabel: UILabel!
    @IBOutlet weak var userAmountStepper: UIStepper!
    
    var settingsData: [Int: Bool] = [
        1: false,
        2: false,
        3: false,
        4: false,
        5: false,
        6: false,
        7: false,
        8: false,
        9: false,
        10: false
    ]
    
    let assignedSettings: [Int: String] = [
        1: "gender",
        2: "location",
        3: "email",
        4: "login",
        5: "registered",
        6: "dob",
        7: "phone",
        8: "cell",
        9: "id",
        10: "nat"
    ]
    
    var enabledSettings: [String] = []
    var linkToSend = "https://randomuser.me/api/?results=1&inc=name,picture"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        let key = sender.tag
        settingsData[key] = sender.isOn
        if let type = assignedSettings[key] {
            enabledSettings.contains(type) ? enabledSettings.removeAll(where: { $0 == type }) : enabledSettings.append(type)
        }
    }
    
    @IBAction func saveLinkButtonTapped(_ sender: Any) {
        linkToSend = "https://randomuser.me/api/?results=\(Int(userAmountStepper.value))&inc=name,picture"
        enabledSettings.forEach { linkToSend += ",\($0)"}
    }
    
    @IBAction func stepperChanged(_ sender: Any) {
        let amount = Int(userAmountStepper.value)
        userAmountLabel.text = "\(amount)"
    }
    
    @IBSegueAction func loadUsersSegue(_ coder: NSCoder) -> UsersTableViewController? {
        return UsersTableViewController(generateUserLink: linkToSend, coder: coder)
    }
}

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
