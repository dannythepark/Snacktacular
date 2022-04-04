//
//  Spot.swift
//  Snacktacular
//
//  Created by Danny Park on 4/4/22.
//

import Foundation
import Firebase
import MapKit


class Spot: NSObject, MKAnnotation {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "latitude": latitude, "longitude": longitude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
    
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String){
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience override init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        var latitude = dictionary["latitude"] as! Double? ?? 0.0
        var longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, address: address, coordinate: CLLocationCoordinate2D(), averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
        
    }
    
    func saveData(completion: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print ("Error: Could not save data because we don'tr have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave){ error in
                guard error == nil else {
                    print ("Error")
                    return completion(false)
                }
            }
            self.documentID = ref!.documentID
            print("Added document: \(self.documentID)")
            completion(true)
        }
        else {
        let ref = db.collection("spots").document(self.documentID)
        ref.setData(dataToSave) { (error) in
            guard error == nil else {
                print ("Error")
                return completion(false)
            }
            print ("Updated document")
            return completion(true)
        }
    }
}
    
}
