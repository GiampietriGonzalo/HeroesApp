import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{

    @IBOutlet weak var myMapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialLocation()
        addAnnotation()
    }
    

    private func setInitialLocation(){
        
        let regionRadius: CLLocationDistance = 1000
        let initialLocation = CLLocation(latitude: -38.717392, longitude: -62.265564)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Agrega las custom annotation
    private func addAnnotation(){
        
        let kuroganeAnnotation = CustomAnnotation(title: "Kurogane Fanstrore", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.741895, longitude: -73.989308))
        let yokoAnnotation = CustomAnnotation(title: "Yoko Store", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: -38.7211738, longitude: -62.2589567))
        let trilogyAnnotation = CustomAnnotation(title: "Trilogy Games", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: -38.7211737, longitude: -62.2589569))
        let arcoIrisAnnotation = CustomAnnotation(title: "Arco Iris", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: -38.7182771, longitude: -62.261953))
        let donBoscoAnnotation = CustomAnnotation(title: "Don Bosco", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: -38.7191509, longitude: -62.269599))
        let donQuijoteAnnotation = CustomAnnotation(title: "Don Quijote", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: -38.7222883, longitude: -62.2646183))
        
        myMapView.addAnnotation(kuroganeAnnotation)
        myMapView.addAnnotation(yokoAnnotation)
        myMapView.addAnnotation(donQuijoteAnnotation)
        myMapView.addAnnotation(donBoscoAnnotation)
        myMapView.addAnnotation(arcoIrisAnnotation)
        myMapView.addAnnotation(trilogyAnnotation)
    }
}
    
    
extension MapViewController: MKMapViewDelegate {
    
        //ANNOTATION CLICKED
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            guard let myAnnotation = annotation as? CustomAnnotation else {
                return nil
            }
            
            var viewToReturn: MKAnnotationView
            
            if let dequeuedView = myMapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? MKMarkerAnnotationView {
                dequeuedView.annotation = myAnnotation
                viewToReturn = dequeuedView
            }
            else {
                viewToReturn = MKMarkerAnnotationView(annotation: myAnnotation, reuseIdentifier: "marker")
                viewToReturn.canShowCallout = true
                viewToReturn.calloutOffset = CGPoint(x: -5, y: 5)
                viewToReturn.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }

            return viewToReturn
        }

        //ANNOTATION REACTION
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            guard let myAnnotation = view.annotation else{
                return
            }
            
            let myGeocoder: CLGeocoder = CLGeocoder()
            //let location = CLLocation(latitude: myAnnotation.coordinate.latitude, longitude: myAnnotation.coordinate.longitude)
            
            myGeocoder.reverseGeocodeLocation(CLLocation(latitude:myAnnotation.coordinate.latitude, longitude: myAnnotation.coordinate.longitude), completionHandler: { (placemarks, error) in

                guard error == nil else {
                    return
                }

                let alertController = UIAlertController(title: myAnnotation.title!, message: "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                alertController.addAction(UIAlertAction(title: "Hey Ho Let's GO!!!!", style: .default, handler: { (action) in
                    
                    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                        
                        self.myMapView.showsUserLocation = true
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: myAnnotation.coordinate))
                        
                        if let titleAnnotation = myAnnotation.title {
                            mapItem.name = "\(titleAnnotation!)"
                        }
                        
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                    }
                    else{
                        self.locationManager.requestWhenInUseAuthorization()
                }
 
                }))

                self.present(alertController, animated: true, completion: nil) }
            )
        }
}




