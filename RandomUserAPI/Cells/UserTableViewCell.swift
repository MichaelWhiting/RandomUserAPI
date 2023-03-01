//
//  UserTableViewCell.swift
//  RandomUserAPI
//
//  Created by Michael Whiting on 2/27/23.
//

import UIKit

enum ImageRequestErrors: Error, LocalizedError {
    case httpRequestError, imageLoadingError
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var descriptionString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateInfo(with user: User) {
        let firstName = user.name!.first ?? ""
        let lastName = user.name!.last ?? ""
        nameLabel.text = "\(firstName) \(lastName) "

        if let gender = user.gender {
            descriptionString += "Gender: \(gender)\n"
        }
        
        if let location = user.location {
            descriptionString += "City: \(location.city ?? "")\n"
        }
        
        if let email = user.email {
            descriptionString += "\(email)\n"
        }
        
        if let login = user.login {
            descriptionString += "User: \(login.username ?? "")\n"
        }
        
        if let registered = user.registered {
            descriptionString += "Registered: \(registered.age ?? 0) years ago\n"
        }
        
        if let dob = user.dob {
            let dateFormatter = DateFormatter()
            let date = dateFormatter.date(from: dob.date!)
            dateFormatter.dateFormat = "MMMM d, y"
            descriptionString += "DOB: \(dateFormatter.string(from: date ?? Date()))\n"
        }
        
        if let phone = user.phone {
            descriptionString += "Phone: \(phone)\n"
        }
        
        if let cell = user.cell {
            descriptionString += "Cell: \(cell.description)\n"
        }
        
        if let id = user.id {
            descriptionString += "\(id.name ?? ""): \(id.value ?? "")\n"
        }
        
        if let nat = user.nat {
            descriptionString += "Nationality: \(nat)\n"
        }
        
        descriptionLabel.text = descriptionString
        descriptionString = ""
    }
}
