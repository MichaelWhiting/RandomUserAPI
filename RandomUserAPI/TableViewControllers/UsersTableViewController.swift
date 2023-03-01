//
//  UsersTableViewController.swift
//  RandomUserAPI
//
//  Created by Michael Whiting on 2/27/23.
//

import UIKit

class UsersTableViewController: UITableViewController {
    var users: [User] = []
    
    var generateUserLink: String
    
    init?(generateUserLink: String, coder: NSCoder) {
        self.generateUserLink = generateUserLink
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRequest()
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        userRequest()
    }
    
}

// MARK: Functions
extension UsersTableViewController {
    func userRequest() {
        let userRequest = UserAPIRequest(url: generateUserLink)
        
        Task {
            do {
                let info = try await sendRequest(userRequest)
                users = info.results
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ImageRequestErrors.httpRequestError
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageRequestErrors.imageLoadingError
        }
        
        return image
    }
}

// MARK: TableView DataSource
extension UsersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        let user = users[indexPath.row]
        
        cell.updateInfo(with: user)
        
        // Updating the photo inside of the cell
        Task {
            do {
                cell.photoImageView.image = try await fetchImage(from: URL(string: user.picture!.medium!)!)
            } catch {
                print(error)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
