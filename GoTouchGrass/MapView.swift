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
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 13.8479, longitude: 100.5693),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var identifiablePlaces: [IdentifiableAnnotation] = []
    private var locationManager = CLLocationManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(
                    coordinateRegion: $region,
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode,
                    annotationItems: identifiablePlaces
                ) { identifiablePlace in
                    MapMarker(
                        coordinate: identifiablePlace.annotation.coordinate,
                        tint: .blue
                    )
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    // Perform initial setup, like location request and data fetching
                    setUserLocation()
                    searchForFitnessPlaces()
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
        if let location = locationManager.location {
            userLocation = location.coordinate
            region.center = userLocation! // Update region to center on user's location
        } else {
            print("User location not available")
        }
    }
    
    private func searchForFitnessPlaces() {
        guard let userLocation = userLocation else {
            print("User location is nil.")
            return
        }

        identifiablePlaces.removeAll()

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "fitness"
        request.region = MKCoordinateRegion(
            center: userLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error searching for fitness places: \(error.localizedDescription)")
                return
            }

            guard let response = response else {
                print("No response from the search.")
                return
            }

            identifiablePlaces = response.mapItems.map { item in
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name ?? "Fitness Place"
                return IdentifiableAnnotation(annotation: annotation)
            }

            // If there are places, update the region to focus on them
            if let firstPlace = identifiablePlaces.first {
                region.center = firstPlace.annotation.coordinate
            }
        }
    }

}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
