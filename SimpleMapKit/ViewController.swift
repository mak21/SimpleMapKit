//
//  ViewController.swift
//  SimpleMapKit
//
//  Created by mahmoud khudairi on 4/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let lat = 31.4
    let long = 41.8
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextAnnotation = MKPointAnnotation()
        nextAnnotation.title = "my place"
        nextAnnotation.subtitle = "Im here"
        nextAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        mapView.addAnnotation(nextAnnotation)
        mapView.delegate = self
        //seting the map to the current location
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: long), animated: true)
        
        //search based on keyword
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("KLCC") { (placemarks, error) in
            if let err = error{
                print("error\(err.localizedDescription)")
                return
            }
            if let places = placemarks{
                for place in places{
                    if let coord = place.location?.coordinate {
                    let annot = MKPointAnnotation()
                    annot.coordinate = coord
                    annot.title = place.name
                    annot.subtitle = place.locality
                        self.mapView.addAnnotation(annot)
                }
            }
        }
        }
    }

}
extension ViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let title = annotation.title else{return nil}
           if title == "my place"{
        let annotationView = MKAnnotationView()
        annotationView.image = UIImage(named:"loc")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
        }else{
           let pinAnnotationView = MKPinAnnotationView()
            pinAnnotationView.pinTintColor = UIColor.purple
            pinAnnotationView.canShowCallout = true
            return pinAnnotationView
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coord = view.annotation?.coordinate  else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
    }
}

