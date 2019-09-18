//
//  VideoListScreen.swift
//  AlamofireExample2Table
//
//  Created by camilo andres ibarra yepes on 9/18/19.
//  Copyright © 2019 camilo andres ibarra yepes. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VideoListScreen: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createArray()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    func createArray() {
        
        DispatchQueue.main.async {
            Alamofire.request("https://api.myjson.com/bins/icmr9").responseJSON(completionHandler: {(response) in switch response.result {
                case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                print(data)
                data["users"].array?.forEach({(user) in
                    
                    let urlImage = user["imageProfile"].stringValue
                    print(urlImage)
                    
                    let videoItem = Video(image: user["imageProfile"].stringValue, title: user["name"].stringValue)
                    //let video1 = Video(image: #imageLiteral(resourceName: "image3"), title: "Your First App")
                    //let videoItem = Video(name: user["name"].stringValue, email: user["email"].stringValue)
                    self.videos.append(videoItem)
                })
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                }
            })
        }
    }
    
}

extension VideoListScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.videoTitleLabel.text = self.videos[indexPath.row].title
        let data = NSData(contentsOf: NSURL(string: self.videos[indexPath.row].image)! as URL)
        cell.videoImageView.image = UIImage(data: data! as Data)
        
        return cell
    }
}
    

