//
//  MapView.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 25/3/2567 BE.
//

import SwiftUI
import MapKit
import CoreLocation

struct IdentifiableAnnotation: Identifiable {
    let id = UUID()
    let annotation: MKPointAnnotation
}

struct MapView: View {
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.8479, longitude: 100.5693), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)) // Default center location to Bangkok, Thailand
    @State private var identifiablePlaces: [IdentifiableAnnotation] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: identifiablePlaces) { identifiablePlace in
                    MapPin(coordinate: identifiablePlace.annotation.coordinate, tint: .blue)
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    // Set initial user location and search for fitness places
                    setUserLocation()
                    searchForFitnessPlaces {
                        print("places", identifiablePlaces)
                    }
                }
                VStack {
                    Text("Gym Map")
                        .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                        .font(.system(size: 24, weight: .heavy))
                    Spacer()
                }
            }
        }
    }
    
    private func setUserLocation() {
        // Request location authorization
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        // Fetch user's current location
        if let location = locationManager.location {
            userLocation = location.coordinate
            region.center = userLocation! // Update region to center on user's location
        }
    }
    
    private func searchForFitnessPlaces(completion: @escaping () -> Void) {
        guard let userLocation = userLocation else { return }
        
        // Clear previous results
        identifiablePlaces.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "fitness"
        request.region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error searching for fitness places: \(error.localizedDescription)")
                } else {
                    print("Unknown error searching for fitness places")
                }
                completion() // Call completion handler even in case of error
                return
            }
            
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name ?? "Fitness Place"
                let identifiableAnnotation = IdentifiableAnnotation(annotation: annotation)
                self.identifiablePlaces.append(identifiableAnnotation)
            }
            
            // Update the map's region to fit the annotations
            if let firstPlace = self.identifiablePlaces.first?.annotation {
                self.region = MKCoordinateRegion(center: firstPlace.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
            
            completion() // Call completion handler after places are populated
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
