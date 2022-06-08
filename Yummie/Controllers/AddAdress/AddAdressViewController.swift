//
//  AddAdressViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 1.06.2022.
//

import UIKit
import MapKit
import CoreLocation

class AddAdressViewController: UIViewController,AlertProtocol {

    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bourhoodTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var homeNumberTextField: UITextField!
    @IBOutlet weak var floorNumberTextField: UITextField!
    @IBOutlet weak var apartNumberTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    //MARK: - Vars
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var choosenLatitude: Double = 0
    var choosenLongitude: Double = 0
    var adress: Adress?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
        
        createGestureRecognizer()
    }
    
    //MARK: - Create gesture recognizer for mapview annotation
    private func createGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            choosenLatitude = touchedCoordinate.latitude
            choosenLongitude = touchedCoordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            annotation.title = ""
            annotation.subtitle = ""
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //MARK: - Save adress button func
    @IBAction func saveBtnClicked(_ sender: Any) {
        if textFieldHaveText() {
            saveToFirebase()
            updateUserAdress()
        } else {
            alertMessage(titleInput: "Hata", messageInput: "Adres lokasyonu veya alanları boş olamaz")
        }
    }
    
    //MARK: - To save adress object to firebase
    private func saveToFirebase() {
        let adress = Adress(userId: User.currentId(), bourhood: bourhoodTextField.text!, street: streetTextField.text!, homeNumber: homeNumberTextField.text!, floorNumber: floorNumberTextField.text!, apartNumber: apartNumberTextField.text!, description: descriptionTextField.text!, latitude: "\(choosenLatitude)", longitude: "\(choosenLongitude)")
        saveAdressToFirebase(adress: adress)
    }
    
    //MARK: - To update the save address as the user address
    private func updateUserAdress() {
        let adress = "\(bourhoodTextField.text!), \(streetTextField.text!), No:\(homeNumberTextField.text!) Kat:\(floorNumberTextField.text!) Daire:\(apartNumberTextField.text!)"
        let adressDict = [kFULLADRESS : adress] as [String:Any]
        
        updateUserAdressInFirebase(withValues: adressDict) { (error) in
            if error == nil {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func textFieldHaveText() -> Bool {
        return (bourhoodTextField.text != "" && streetTextField.text != "" && homeNumberTextField.text != "" && floorNumberTextField.text != "" && apartNumberTextField.text != "" && descriptionTextField.text != "" && choosenLatitude != 0 && choosenLongitude != 0)
    }
}

extension AddAdressViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}
