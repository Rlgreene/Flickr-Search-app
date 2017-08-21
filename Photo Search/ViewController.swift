//
//  ViewController.swift
//  Photo Search
//
//  Created by Richard Greene on 8/18/17.
//  Copyright © 2017 Richard Greene. All rights reserved.
//

import UIKit
                                        //insert UISearchBarDelegate to define the optional methods thatll be used to make a search bar functional
class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrBy(" ")
    }
    func searchFlickrBy(_ searchString: String) {
        let manager = AFHTTPSessionManager()
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "8d1008621fa7378a2934205a2ba628dc",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchString,//so that any typing will overwrite the previous
                                             "extras": "url_m",
                                             "per_page": 5]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject {
                            print("Response: " + (responseObject as AnyObject).description)
                            if let photos = (responseObject as AnyObject)["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String:AnyObject]] {
                                    let imageWidth = self.view.frame.width //will be used to demonstrate all images' native sizes
                                    self.scrollView.contentSize = CGSize(width: imageWidth, height: imageWidth * CGFloat(photoArray.count)) //makes the images more dynamic and able to fit all screen sizes
                                    for (i,photoDictionary) in photoArray.enumerated() {
                                        if let imageURLString = photoDictionary["url_m"] as? String {
                                            let imageView = UIImageView(frame: CGRect(x: 0, y: 320*CGFloat(i), width: 320, height: 320))
                                                if let url = URL(string: imageURLString) {
                                                imageView.setImageWith(url)
                                                self.scrollView.addSubview(imageView)
                                                }
                                            }
                                    }
                            }
                }
 }
    }) { (operation:URLSessionDataTask?, error:Error) in
    print("Error: " + error.localizedDescription)
    }
        // Do any additional setup after loading the view, typically from a nib.
    }

    //this function calls the search bar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder() //this will make the keyboard disappear when tapping the 'Search' button
        if let searchText = searchBar.text {
            searchFlickrBy(searchText)//tells the app to use the search func for whatever is typed
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

