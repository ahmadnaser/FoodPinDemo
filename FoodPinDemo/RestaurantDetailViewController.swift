//
//  RestaurantDetailViewController.swift
//  FoodPinDemo
//
//  Created by cyper on 28/10/2016.
//  Copyright © 2016 cyper tech. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //@IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //nameLabel.text = restaurant.name
        //typeLabel.text = restaurant.type
        //locationLabel.text = restaurant.location
        restaurantImageView.image = UIImage(data: restaurant.image as! Data)
        
        // set table view bg color
        tableView.backgroundColor = UIColor(white: 240.0/255, alpha: 0.2)
        // remove empty rows
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        //set separator color
        tableView.separatorColor = UIColor(white: 240.0/255, alpha: 0.8)
        
        title = restaurant.name
        
        // self sizing cells
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableViewAutomaticDimension // this is iOS10 default value
        
        // tap on static map view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let coordinate = placemarks?[0].location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.mapView.addAnnotation(annotation)
                
                // set the zoom level, 250 meters
                let region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250)
                self.mapView.setRegion(region, animated: true)
            }
            
        })
    }
    
    func showMap(){
        performSegue(withIdentifier: "showMap", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = restaurant.isVisited ? "Yes, I've been here before. \(restaurant.rating ?? "")" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let controller = segue.destination as! ReviewViewController
            controller.restaurant = self.restaurant
        } else if segue.identifier == "showMap" {
            let controller = segue.destination as! MapViewController
            controller.restaurant = self.restaurant
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }

    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            restaurant.isVisited = true
            
            switch rating {
            case "great":
                restaurant.rating = "Absolutely love it! Must try."
            case "good":
                restaurant.rating = "Pretty good."
            case "dislike":
                restaurant.rating = "I don't like it."
            default:
                break
            }
        }
        
        CD.save(restaurant)
        
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
