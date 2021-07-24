//
//  MapViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit
import RxCocoa
import RxSwift
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var map: GMSMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private var placesClient: GMSPlacesClient!
    private var preciseLocationZoomLevel: Float = 15.0
    private var approximateLocationZoomLevel: Float = 10.0
    
    // The currently selected place.
    private var selectedPlace: GMSPlace?
    
    // auto complete button
    private let autoCompleteButton: UIButton = UIButton()
    
    // view model
    private let searchPlaceViewMdeol = SearchPlaceViewModel()
    
    // RxSwift
    private let disposeBag = DisposeBag()
    
    // MARK: - Overrid Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocationInfo()
        makeButton()
        
        bindNetworkingState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigation = self.navigationController else { return }
        navigation.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let navigation = self.navigationController else { return }
        navigation.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Set Location
    private func setLocationInfo() {
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        map.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: 37.4980, longitude: 127.0271)
        
        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ?
            preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(
            withLatitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude,
            zoom: zoomLevel
        )
        
        map.camera = camera
        map.settings.myLocationButton = true
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        map.isHidden = true
        
        listLikelyPlaces()
    }
    
    // Populate the array with the list of likely places.
    private func listLikelyPlaces(completionHandler: @escaping (_ place: GMSPlace?) -> Void = { _ in }) {
        
        let placeFields: GMSPlaceField = [.name, .coordinate, .formattedAddress]
        placesClient.findPlaceLikelihoodsFromCurrentLocation(
            withPlaceFields: placeFields
        ) { (placeLikelihoods, error) in
            guard error == nil else {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            guard let placeLikelihoods = placeLikelihoods else {
                print("No places found.")
                return
            }
            
            let address = self.getAddress(place: placeLikelihoods.first?.place)
            self.autoCompleteButton.setTitle(address, for: .normal)
            
            self.selectedPlace = placeLikelihoods.first?.place
            completionHandler(self.selectedPlace)
        }
    }
    
    // MARK: - Set Auto Complete Button
    func makeButton() {
        autoCompleteButton.backgroundColor = .white
        autoCompleteButton.setTitleColor(.black, for: .normal)
        autoCompleteButton.addTarget(
            self,
            action: #selector(autocompleteClicked),
            for: .touchUpInside
        )
        
        self.view.addSubview(autoCompleteButton)
        
        autoCompleteButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-35)
        }
    }
    
      @objc func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(
            rawValue: UInt(GMSPlaceField.name.rawValue)
                | UInt(GMSPlaceField.placeID.rawValue)
                | UInt(GMSPlaceField.coordinate.rawValue)
                | UInt(GMSPlaceField.formattedAddress.rawValue)
        )
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        self.present(autocompleteController, animated: true)
      }
    
    private func getAddress(place: GMSPlace?) -> String {
        guard let formattedAddress = place?.formattedAddress else { return "" }
        let address = formattedAddress.components(separatedBy: " ")
        let result = address[address.count - 3] + " " + address[address.count - 2] + " " + address[address.count - 1]
        
        return result
    }
    
    // MARK: - Networking
    private func requestPlace(place: GMSPlace?) {
        guard let lat = place?.coordinate.latitude,
              let lng = place?.coordinate.longitude
        else {
            return
        }
        
        let parameters: [String: String] = [
            "key": "AIzaSyCcXxMzsdL1m2uPjZ6d9wGTiVDYm4srnHU",
            "location": "\(lat),\(lng)",
            "radius": "1000",
            "language": "ko",
            "type": "bar"
        ]
        
        searchPlaceViewMdeol.request(parameters: parameters)
    }
    
    private func bindNetworkingState() {
        searchPlaceViewMdeol.state.success
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive { placeData in
                self.setMarker(placeData: placeData)
            }.disposed(by: disposeBag)
        
        searchPlaceViewMdeol.state.fail
            .filter {$0 == true}
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive { _ in
                
            }.disposed(by: disposeBag)
    }
    
    private func setMarker(placeData: SearchPlace) {
        for place in placeData.results {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.geometry.location.lat,
                longitude: place.geometry.location.lng
            )
            marker.title = place.name
            marker.map = map
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ?
            preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoomLevel
        )
        
        if map.isHidden {
            map.isHidden = false
            map.camera = camera
        } else {
            map.animate(to: camera)
        }
        
        listLikelyPlaces { place in
            self.requestPlace(place: place)
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ?
            preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(
            withLatitude: place.coordinate.latitude,
            longitude: place.coordinate.longitude,
            zoom: zoomLevel
        )
        
        map.animate(to: camera)
        
        let address = getAddress(place: place)
        autoCompleteButton.setTitle(address, for: .normal)
        
        requestPlace(place: place)
        
        self.dismiss(animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true)
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let place = PlaceDetailViewController()
        self.present(place, animated: true)
        
        return true
    }
}
