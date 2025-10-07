
//
//  ContentView.swift
//  Cam-ATX
//
//  Created by akhil kakarla on 6/4/25.
//

import Foundation
import SwiftUI
import MapKit

extension Notification.Name {
    static let mapInteractionHappened = Notification.Name("mapInteractionHappened")
}

struct ContentView: View {
    
        @State var austin = CLLocationCoordinate2D(latitude: 30.266666, longitude: -97.733330)
        
        @State private var showMenu = false
        @State private var camera: String = ""
        @State private var camObjs: [CameraObjects] = []
        @State private var showingInfo = false
        @State private var cameraViewID = UUID()

        var body: some View {
            TabView{
                
                        //HomeView() ----------------------
                        NavigationStack {
                            HomeView()
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbarBackground(.visible, for: .navigationBar)
                                .toolbarColorScheme(.dark, for: .navigationBar)
                                .toolbarBackground(Color(red: 86/255, green: 5/255, blue: 145/255), for: .navigationBar)
                                .toolbar{
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            self.showingInfo.toggle()
                                        } ,label: {
                                            Image(systemName: "info.circle")
                                        })
                                        .sheet(isPresented: $showingInfo) {
                                            InfoView()
                                        }
                                        
                                   }
                                }
                        }
                        .tabItem{
                            Label("Home", systemImage: "house")
                            Image(systemName: "photo")
                        }
                
                        .toolbarBackground(Color(red: 86/255, green: 5/255, blue: 145/255), for: .tabBar)
                        .toolbar(.visible, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarColorScheme(.dark, for: .tabBar)
                
                
                        Cameras()
                        .tabItem{
                            Label("Cameras", systemImage: "camera.circle")
                        }
                        .toolbar(.visible, for: .tabBar)
                        .toolbarBackground(Color(red: 86/255, green: 5/255, blue: 145/255), for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarColorScheme(.dark, for: .tabBar)
                    
                
                        
                        AIAnalytics()
                        .tabItem{
                            Label("AI Analytics", systemImage: "brain.head.profile.fill")
                        }
                        .toolbarBackground(Color(red: 86/255, green: 5/255, blue: 145/255), for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarColorScheme(.dark, for: .tabBar)

            }
        }

}

#Preview {
    ContentView()
}

struct InfoView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {

            Spacer()

            Image(uiImage: UIImage(named: "austin511_logo.webp")!)
                .resizable()
                .clipShape(.rect(cornerRadius: 25))
                .frame(width: 200, height: 200)
            
            Text("Cam-ATX")
                .font(.system(size: 40))
                .fontWeight(.bold)
                //.multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 86/255, green: 5/255, blue: 145/255))

            Text("Real-time CCTV images for city of Austin")
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                //.padding(.horizontal, 50)
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 86/255, green: 5/255, blue: 145/255))
            
            Spacer()
            
            VStack() {
                NavigationLink {
                    Cameras()
                } label: {
                    Image(systemName: "camera.circle.fill").foregroundStyle(.white, .green)
                    Text("CAMERAS").fontWeight(.bold).multilineTextAlignment(.leading)
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 86/255, green: 5/255, blue: 145/255))
                    Text("Real time CCTV images from cameras across Austin").multilineTextAlignment(.leading)
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 86/255, green: 5/255, blue: 145/255))
                    Text("\n")
                    
                }
            }
            
            Spacer()
            
            VStack{
                NavigationLink{
                    AIAnalytics()
                } label: {
                    Image(systemName: "brain.head.profile.fill")
                        .foregroundStyle(.white, .blue)
                    Text("AI ANALYTICS").fontWeight(.bold).multilineTextAlignment(.leading)
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 86/255, green: 5/255, blue: 145/255))
                    Text("Real time AI traffic predictions, weekend and weekday, for Austin").multilineTextAlignment(.leading)
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 86/255, green: 5/255, blue: 145/255))
                    Text("\n")
                }
            }
            Spacer()
         
        }
        .padding(.leading)
        //.foregroundColor(Color(red: 86/255, green: 5/255, blue: 145/255))
        .multilineTextAlignment(.leading)
    }
}


/*
struct Cameras: View{
    
    @State private var coordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431), // Example: Austin, TX
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    
    @State private var camObjs: [CameraObjects] = []
    
    @State private var mapSelection: MKMapItem?
    @State private var lockedMarkerData: [UUID: CameraObjects] = [:] // Cache to lock marker data
    @State private var lockedCameraData: [UUID: CameraObjects] = [:] // Cache to lock marker data
    @State private var csvURL: String = "https://data.austintexas.gov/api/views/b4k4-adkb/rows.csv?accessType=DOWNLOAD"
    @State private var lastSpan: MKCoordinateSpan?
    @StateObject private var zoomChecker = MapZoomChecker()
    let austin = CLLocationCoordinate2D(latitude: 30.266666, longitude: -97.733330)
    @State private var markersAreVisible = false
    // Example usage
    var body: some View{
        NavigationView{
            ZStack{
                Map(selection: $mapSelection)
                {
                    
                    /*
                    ForEach(camObjs) {obj in
                        
                        let locationArray: [Substring] = obj.coordinates.split(separator: " ")
                        let latitudeValue = locationArray[2].dropLast()
                        let longitudeValue = locationArray[1].dropFirst()
                        let latitude = Double((String(latitudeValue)))
                        let longitude = Double((String(longitudeValue)))
                        
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)) {
                            if let lockedData = lockedMarkerData[obj.id] {
                                // Use locked data
                                CamerasPopView(library: lockedData)
                            } else {
                                // Populate locked data and use it
                                CamerasPopView(library: obj)
                                    .onAppear {
                                        lockData(for: obj)
                                    }
                            }
                        }
                    }
                    */
                    
                    ForEach(camObjs) { obj in
                        
                        Annotation("", coordinate: obj.coordinate) {
                            if let lockedData = lockedMarkerData[obj.id] {
                                CamerasPopView(library: lockedData)
                            } else {
                                CamerasPopView(library: obj)
                                    .onAppear {
                                        lockData(for: obj)
                                    }
                            }
                        }
                    }
            
                }

                .task {
                    do {
                        let camObjs = try await fetchCameraData(urlString: csvURL)
                        self.camObjs = camObjs
                        print("Successfully loaded \(camObjs.count) camera objects.")
                        // Force map reload after data fetch
                        DispatchQueue.main.async {
                            mapSelection = nil // Reset map selection
                        }
                        markersAreVisible = true
                    } catch {
                        print("Failed to fetch camera data: \(error.localizedDescription)")
                    }
                                        
                }
                 .onAppear{
                     lockAllCameraData(camObjs)
                 }

            }
        }
    }

    
    // Function to fetch and parse CSV data
    func fetchCameraData(urlString: String) async throws -> [CameraObjects] {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let csvString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Failed to decode data", code: -2, userInfo: nil)
        }
        
        return try parseCSV(csvString: csvString)
    }
    
    // Helper function to parse CSV into a list of CameraObjects
    func parseCSV(csvString: String) throws -> [CameraObjects] {
        var cameras = [CameraObjects]()
        let rows = csvString.split(separator: "\n", omittingEmptySubsequences: false)
        
        guard rows.count > 1 else {
            throw NSError(domain: "No data found", code: -3, userInfo: nil)
        }
        
        let headers = rows[0].split(separator: ",", omittingEmptySubsequences: false)
        let headerCount = headers.count
        
        for row in rows.dropFirst() {
            let columns = row.split(separator: ",", omittingEmptySubsequences: false)
            if columns.count == headerCount {
                let camera = CameraObjects(
                    cameraid: String(columns[0]),
                    locationname: String(columns[1]),
                    camerastatus: String(columns[2]),
                    turnondate: String(columns[3]),
                    cameramanufacturer: String(columns[4]),
                    atdlocationid: String(columns[5]),
                    landmark: String(columns[6]),
                    signalengineerarea: String(columns[7]),
                    councildistrict: String(columns[8]),
                    jurisdiction: String(columns[9]),
                    locationtype: String(columns[10]),
                    primarystsegmentid: String(columns[11]),
                    crossstsegmentid: String(columns[12]),
                    primarystreetblock: String(columns[13]),
                    primarystreet: String(columns[14]),
                    primary_st_aka: String(columns[15]),
                    crossstreetblock: String(columns[16]),
                    crossstreet: String(columns[17]),
                    cross_st_aka: String(columns[18]),
                    coaintersectionid: String(columns[19]),
                    modifieddate: String(columns[20]),
                    publishedscreenshots: String(columns[21]),
                    screenshotaddress: String(columns[22]),
                    funding: String(columns[23]),
                    camid: String(columns[24]),
                    coordinates: String(columns[25])
                )
                cameras.append(camera)
            }
        }
        
        return cameras
    }
    
    
    private func lockData(for obj: CameraObjects) {
        DispatchQueue.main.async {
            // Lock data in the dictionary, preserving existing data
            if lockedMarkerData[obj.id] == nil {
                lockedMarkerData[obj.id] = obj
            }
        }
    }


    private func lockAllCameraData(_ camObjs: [CameraObjects]) {
        for obj in camObjs {
            lockedCameraData[obj.id] = obj
        }
    }
     
    private func getCoordinate(from obj: CameraObjects) -> CLLocationCoordinate2D {
            let locationArray = obj.coordinates.split(separator: " ")
            guard locationArray.count >= 2,
                  let latitude = Double(locationArray[2].dropLast()),
                  let longitude = Double(locationArray[1].dropFirst())
            else {
                return austin // Default to Austin if parsing fails
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    
    /*
    func isMarkerVisible(markerCoordinate: CLLocationCoordinate2D, region: MKCoordinateRegion) -> Bool {
        let latMin = region.center.latitude - (region.span.latitudeDelta / 2.0)
        let latMax = region.center.latitude + (region.span.latitudeDelta / 2.0)
        let lonMin = region.center.longitude - (region.span.longitudeDelta / 2.0)
        let lonMax = region.center.longitude + (region.span.longitudeDelta / 2.0)

        return markerCoordinate.latitude >= latMin &&
               markerCoordinate.latitude <= latMax &&
               markerCoordinate.longitude >= lonMin &&
               markerCoordinate.longitude <= lonMax
    }
    */
    
    func isMarkerVisible(markerCoordinate: CLLocationCoordinate2D, region: MKCoordinateRegion) -> Bool {
        let latDelta = region.span.latitudeDelta / 2.0
        let lonDelta = region.span.longitudeDelta / 2.0
        let minLat = region.center.latitude - latDelta
        let maxLat = region.center.latitude + latDelta
        let minLon = region.center.longitude - lonDelta
        let maxLon = region.center.longitude + lonDelta

        return (minLat...maxLat).contains(markerCoordinate.latitude) &&
               (minLon...maxLon).contains(markerCoordinate.longitude)
    }
    
    func updateMapSelection(camObjs: [CameraObjects], region: MKCoordinateRegion) {
        let anyMarkerVisible = camObjs.contains { obj in
            isMarkerVisible(markerCoordinate: getCoordinate(from: obj), region: region)
        }
        
        if !anyMarkerVisible {
            DispatchQueue.main.async {
                mapSelection = nil // Reset map selection
            }
        }
    }
}
*/


struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {

            Spacer()
            
            Text("CamATX")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 86/255, green: 5/255, blue: 145/255))
            
            /*
            Image(uiImage: UIImage(named: "austin511_logo.webp")!)
                .resizable() // Dynamic sizing
                .frame(width: 360, height: 360)
                .clipShape(.rect(cornerRadius: 25))
             */
            Image("austin511_logo")
                .resizable() // Dynamic sizing
                .frame(width: 360, height: 360)
                .clipShape(.rect(cornerRadius: 25))

            Spacer()
        }
    }
}

struct Cameras: View {
    @State private var camObjs: [CameraObjects] = []
    @State private var selectedCamera: CameraObjects? = nil
    @State private var searchCoord: CLLocationCoordinate2D? = nil
    
    let defaultRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    @State private var csvURL: String = "https://data.austintexas.gov/api/views/b4k4-adkb/rows.csv?accessType=DOWNLOAD"

    var body: some View {
        NavigationView {
            VStack {
                            MapSearchBar(coordinate: $searchCoord)
                                .padding(.horizontal)

                            UIKitMapView(cameras: $camObjs, selectedCamera: $selectedCamera, searchCoordinate: $searchCoord)
                                .edgesIgnoringSafeArea(.all)
                        }
            
            .sheet(item: $selectedCamera) { camera in
                            CamerasPopView(library: camera)
                        }
            
            .task {
                do {
                    let camObjs = try await fetchCameraData(urlString: csvURL)
                    self.camObjs = camObjs
                    
                } catch {
                    print("error: \(error)")
                }
            }
            
        }
    }

    // MARK: - CSV Parsing
    func fetchCameraData(urlString: String) async throws -> [CameraObjects] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let csvString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return try parseCSV(csvString: csvString)
    }

    func parseCSV(csvString: String) throws -> [CameraObjects] {
        var cameras = [CameraObjects]()
        let rows = csvString.split(separator: "\n", omittingEmptySubsequences: false)

        guard rows.count > 1 else { return [] }

        for row in rows.dropFirst() {
            let columns = row.split(separator: ",", omittingEmptySubsequences: false)
            guard columns.count >= 26 else { continue }

            let cam = CameraObjects(
                cameraid: String(columns[0]),
                locationname: String(columns[1]),
                camerastatus: String(columns[2]),
                turnondate: String(columns[3]),
                cameramanufacturer: String(columns[4]),
                atdlocationid: String(columns[5]),
                landmark: String(columns[6]),
                signalengineerarea: String(columns[7]),
                councildistrict: String(columns[8]),
                jurisdiction: String(columns[9]),
                locationtype: String(columns[10]),
                primarystsegmentid: String(columns[11]),
                crossstsegmentid: String(columns[12]),
                primarystreetblock: String(columns[13]),
                primarystreet: String(columns[14]),
                primary_st_aka: String(columns[15]),
                crossstreetblock: String(columns[16]),
                crossstreet: String(columns[17]),
                cross_st_aka: String(columns[18]),
                coaintersectionid: String(columns[19]),
                modifieddate: String(columns[20]),
                publishedscreenshots: String(columns[21]),
                screenshotaddress: String(columns[22]),
                funding: String(columns[23]),
                camid: String(columns[24]),
                coordinates: String(columns[25])
            )
            cameras.append(cam)
        }

        return cameras
    }
}


struct AIAnalytics: View{
    @State private var camObjs: [CameraObjects] = []
    @State private var selectedCamera: CameraObjects? = nil
    @State private var lockedMarkerData: [CameraObjects] = []
    @State private var searchCoord: CLLocationCoordinate2D? = nil
    
    let defaultRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    @State private var csvURL: String = "https://data.austintexas.gov/api/views/b4k4-adkb/rows.csv?accessType=DOWNLOAD"

    var body: some View {
        NavigationView {
            VStack {
                            MapSearchBar(coordinate: $searchCoord)
                                .padding(.horizontal)

                            UIKitMapView(cameras: $camObjs, selectedCamera: $selectedCamera, searchCoordinate: $searchCoord)
                                .edgesIgnoringSafeArea(.all)
                        }
            .sheet(item: $selectedCamera) { camera in
                AICamerasPopView(library: camera)
            }
            
            .task {
                do {
                    let camObjs = try await fetchCameraData(urlString: csvURL)
                    self.camObjs = camObjs
                    
                } catch {
                    print("error: \(error)")
                }
            }
        }
    }

    // Function to fetch and parse CSV data
    func fetchCameraData(urlString: String) async throws -> [CameraObjects] {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let csvString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Failed to decode data", code: -2, userInfo: nil)
        }

        return try parseCSV(csvString: csvString)
    }

    // Helper function to parse CSV into a list of CameraObjects
    func parseCSV(csvString: String) throws -> [CameraObjects] {
        var cameras = [CameraObjects]()
        let rows = csvString.split(separator: "\n", omittingEmptySubsequences: false)
        
        guard rows.count > 1 else {
            throw NSError(domain: "No data found", code: -3, userInfo: nil)
        }

        let headers = rows[0].split(separator: ",", omittingEmptySubsequences: false)
        let headerCount = headers.count

        for row in rows.dropFirst() {
            let columns = row.split(separator: ",", omittingEmptySubsequences: false)
            if columns.count == headerCount {
                let camera = CameraObjects(
                    cameraid: String(columns[0]),
                    locationname: String(columns[1]),
                    camerastatus: String(columns[2]),
                    turnondate: String(columns[3]),
                    cameramanufacturer: String(columns[4]),
                    atdlocationid: String(columns[5]),
                    landmark: String(columns[6]),
                    signalengineerarea: String(columns[7]),
                    councildistrict: String(columns[8]),
                    jurisdiction: String(columns[9]),
                    locationtype: String(columns[10]),
                    primarystsegmentid: String(columns[11]),
                    crossstsegmentid: String(columns[12]),
                    primarystreetblock: String(columns[13]),
                    primarystreet: String(columns[14]),
                    primary_st_aka: String(columns[15]),
                    crossstreetblock: String(columns[16]),
                    crossstreet: String(columns[17]),
                    cross_st_aka: String(columns[18]),
                    coaintersectionid: String(columns[19]),
                    modifieddate: String(columns[20]),
                    publishedscreenshots: String(columns[21]),
                    screenshotaddress: String(columns[22]),
                    funding: String(columns[23]),
                    camid: String(columns[24]),
                    coordinates: String(columns[25])
                )
                cameras.append(camera)
            }
        }
        
        return cameras
    }
    
    /*
    private func getCoordinate(from obj: CameraObjects) -> CLLocationCoordinate2D {
            let locationArray = obj.coordinates.split(separator: " ")
            guard locationArray.count >= 2,
                  let latitude = Double(locationArray[2].dropLast()),
                  let longitude = Double(locationArray[1].dropFirst())
            else {
                return austin // Default to Austin if parsing fails
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    
    */
    
    func getCoordinate(for cameraObj: CameraObjects) -> CLLocationCoordinate2D {
            let coordinates = cameraObj.coordinates.split(separator: ",")
            if let lat = Double(coordinates.first ?? ""), let lon = Double(coordinates.last ?? "") {
                return CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }
            return CLLocationCoordinate2D()
        }
}


struct CamerasPopView: View {
    @State var library: CameraObjects
    @State private var showCamerasPopover = false
    @State private var selectedCamera: CameraObjects? = nil
    
    var body: some View {
        Text("\n")
        /*
        Text("CCTV Screenshot Web address :")
            .font(.system(size: 15, design: .rounded))
            .fontWeight(.heavy)
        Text(library.screenshotaddress)
            .font(.system(size: 15, design: .rounded))
            .frame(alignment: .leading)
        */
        
        
        VStack {
            
            Text("Cross-Streets :")
                .font(.system(size: 15, design: .rounded))
                .fontWeight(.heavy)
            Text(library.locationname)
                .font(.system(size: 15, design: .rounded))
            
            Text("Location :")
                .font(.system(size: 15, design: .rounded))
                .fontWeight(.heavy)
            Text(library.coordinates)
                .font(.system(size: 15, design: .rounded))
            
            //ZoomableAsyncImage(imageURL: URL(string: library.screenshotaddress)!)

            /*
            if #available(iOS 17.0, *) {
                ZoomableAsyncImage(imageURL: URL(string: library.screenshotaddress)!)
            } else {
                AsyncImage(url: URL(string: library.screenshotaddress)) { image in
                    image.resizable()
                } placeholder: {
                    Color.blue
                }
                .frame(width: 350, height: 250, alignment: .topLeading)
                .clipShape(.rect(cornerRadius: 25))
                .frame(alignment: .leading)
            }
             */
            
        }.frame(alignment: .leading)
        
        
        AsyncImage(url: URL(string: library.screenshotaddress)) { image in
            image.resizable()
        } placeholder: {
            Color.blue
        }
        .frame(width: 350, height: 250, alignment: .topLeading)
        .clipShape(.rect(cornerRadius: 25))
        .frame(alignment: .leading)
         
        
        
        /*
        Image(systemName: "camera.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .onTapGesture {
                showCamerasPopover = true
            }
            .foregroundStyle(.white, .orange)
            
            .sheet(isPresented: $showCamerasPopover) {
                Text("\n")
                Text("CCTV Screenshot Web address :")
                    .font(.system(size: 15, design: .rounded))
                    .fontWeight(.heavy)
                Text(library.screenshotaddress)
                    .font(.system(size: 15, design: .rounded))
                    .frame(alignment: .leading)
                
                VStack {
                    Text("Location :")
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.heavy)
                    Text(library.coordinates)
                        .font(.system(size: 15, design: .rounded))

                    Text("Cross-Streets :")
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.heavy)
                    Text(library.locationname)
                        .font(.system(size: 15, design: .rounded))

                }.frame(alignment: .leading)
                
                AsyncImage(url: URL(string: library.screenshotaddress)) { image in
                    image.resizable()
                } placeholder: {
                    Color.blue
                }
                .frame(width: 350, height: 250, alignment: .topLeading)
                .clipShape(.rect(cornerRadius: 25))
                
            }.frame(alignment: .leading)
             */
    }
}

struct AICamerasPopView: View {
    @State var library: CameraObjects
    @State private var showAICamerasPopover = false
    @State private var hasImage = false
  
    var body: some View {
        Text("AI Analytics - Vehicle Count Per Hour")
            .font(.headline)
            .padding()
            .frame(alignment: .topLeading)
         
        
        VStack (alignment: .center){
            Text(library.locationname)
                .frame(alignment: .topLeading)
            Text(library.coordinates)
                .frame(alignment: .topLeading)
            ForEach(1...845, id: \.self) {i in
                if(Int(library.cameraid) == i){
                    //ZoomableAsyncImage(imageURL: URL(string: library.screenshotaddress)!)
                    Image("\(i)")
                        .resizable()
                        .frame(width: 350, height: 350, alignment: .topLeading)
                        .clipShape(.rect(cornerRadius: 25))
                        .onAppear{
                            hasImage = true
                        }
                }
            }
        }.frame(alignment: .topLeading)
        
        
        if(hasImage == false){
            Text("\t\tCould not generate AI analytics")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}


struct CameraObjects: Identifiable {
    var id = UUID()
    let cameraid: String!
    let locationname: String!
    let camerastatus: String!
    let turnondate: String!
    let cameramanufacturer: String!
    let atdlocationid: String!
    let landmark: String!
    let signalengineerarea: String!
    let councildistrict: String!
    let jurisdiction: String!
    let locationtype: String!
    let primarystsegmentid: String!
    let crossstsegmentid: String!
    let primarystreetblock: String!
    let primarystreet: String!
    let primary_st_aka: String!
    let crossstreetblock: String!
    let crossstreet: String!
    let cross_st_aka: String!
    let coaintersectionid: String!
    let modifieddate: String!
    let publishedscreenshots: String!
    let screenshotaddress: String!
    let funding: String!
    let camid: String!
    let coordinates: String!
    let coordinate: CLLocationCoordinate2D
    
    init(
            cameraid: String,
             locationname: String,
             camerastatus: String,
             turnondate: String,
             cameramanufacturer: String,
             atdlocationid: String,
             landmark: String,
             signalengineerarea: String,
             councildistrict: String,
             jurisdiction: String,
             locationtype: String,
             primarystsegmentid: String,
             crossstsegmentid: String,
             primarystreetblock: String,
             primarystreet: String,
             primary_st_aka: String,
             crossstreetblock: String,
             crossstreet: String,
             cross_st_aka: String,
             coaintersectionid: String,
             modifieddate: String,
             publishedscreenshots: String,
             screenshotaddress: String,
             funding: String,
             camid: String,
             coordinates: String) {
            
            self.cameraid = cameraid
            self.locationname = locationname
            self.camerastatus = camerastatus
            self.turnondate = turnondate
            self.cameramanufacturer = cameramanufacturer
            self.atdlocationid = atdlocationid
            self.landmark = landmark
            self.signalengineerarea = signalengineerarea
            self.councildistrict = councildistrict
            self.jurisdiction = jurisdiction
            self.locationtype = locationtype
            self.primarystsegmentid = primarystsegmentid
            self.crossstsegmentid = crossstsegmentid
            self.primarystreetblock = primarystreetblock
            self.primarystreet = primarystreet
            self.primary_st_aka = primary_st_aka
            self.crossstreetblock = crossstreetblock
            self.crossstreet = crossstreet
            self.cross_st_aka = cross_st_aka
            self.coaintersectionid = coaintersectionid
            self.modifieddate = modifieddate
            self.publishedscreenshots = publishedscreenshots
            self.screenshotaddress = screenshotaddress
            self.funding = funding
            self.camid = camid
            self.coordinates = coordinates
            self.coordinate = CameraObjects.parseCoordinate(coordinates)
        }

        static func parseCoordinate(_ coord: String) -> CLLocationCoordinate2D {
            // Expecting format: "POINT (-97.693171 30.164182)"
            let trimmed = coord
                .replacingOccurrences(of: "POINT", with: "")
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .trimmingCharacters(in: .whitespaces)

            let parts = trimmed.split(separator: " ")
            guard parts.count == 2,
                  let lon = Double(parts[0]),
                  let lat = Double(parts[1]) else {
                print("Invalid coordinate format: \(coord)")
                return CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431) // Fallback: Austin
            }

            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
}


struct UIKitMapView: UIViewRepresentable {
    @Binding var cameras: [CameraObjects]
    @Binding var selectedCamera: CameraObjects?
    static var didSetInitialRegion = false
    @State private var hasSetInitialRegion = false
    @State private var hasSetRegion = false
    @Binding var searchCoordinate: CLLocationCoordinate2D?
    let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431), // Example: Austin, TX
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "camera")
        mapView.setRegion(region, animated: true)
        return mapView
    }

    /*
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = cameras.map { camera -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = camera.coordinate
            annotation.title = camera.locationname
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
     */
    
    /*
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Set region just once
        if !Self.didSetInitialRegion {
            let austinCenter = CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431)
            let region = MKCoordinateRegion(center: austinCenter,
                                            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            mapView.setRegion(region, animated: false)
            Self.didSetInitialRegion = true
        }

        // Remove only camera annotations to avoid duplicates
        let currentAnnotations = mapView.annotations.filter { $0 is CameraAnnotation }
        mapView.removeAnnotations(currentAnnotations)

        let newAnnotations = cameras.map { CameraAnnotation(camera: $0) }
        mapView.addAnnotations(newAnnotations)
    }
    */
    
    /*
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if !context.coordinator.hasSetRegion {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431),
                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
            )
            mapView.setRegion(region, animated: false)
            context.coordinator.hasSetRegion = true
        }

        // Remove and re-add camera annotations
        let existingAnnotations = mapView.annotations.filter { $0 is CameraAnnotation }
        mapView.removeAnnotations(existingAnnotations)
        let annotations = cameras.map { CameraAnnotation(camera: $0) }
        mapView.addAnnotations(annotations)
    }
    */
    
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
            // Update region if a new search coordinate is set
            if let coord = searchCoordinate {
                let region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                mapView.setRegion(region, animated: true)
            }

            // Remove old and add new annotations
            let currentAnnotations = mapView.annotations.filter { $0 is CameraAnnotation }
            mapView.removeAnnotations(currentAnnotations)

            let newAnnotations = cameras.map { CameraAnnotation(camera: $0) }
            mapView.addAnnotations(newAnnotations)
        }
    

    func makeCoordinator() -> Coordinator {
        Coordinator(cameras: $cameras, selectedCamera: $selectedCamera)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var cameras: [CameraObjects]
        @Binding var selectedCamera: CameraObjects?
        var hasSetRegion = false

        init(cameras: Binding<[CameraObjects]>, selectedCamera: Binding<CameraObjects?>) {
            _cameras = cameras
            _selectedCamera = selectedCamera
        }

        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            let tappedCoord = annotation.coordinate

            if let camera = cameras.first(where: {
                abs($0.coordinate.latitude - tappedCoord.latitude) < 0.0001 &&
                abs($0.coordinate.longitude - tappedCoord.longitude) < 0.0001
            }) {
                selectedCamera = camera
            }
        }
        

        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }

            let identifier = "camera"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                view?.annotation = annotation
            }

            view?.glyphImage = UIImage(systemName: "camera.circle.fill")
            view?.markerTintColor = .orange
            view?.canShowCallout = false
            return view
        }
        
        
    }
}



class CameraAnnotation: NSObject, MKAnnotation {
    let camera: CameraObjects

    // Required by MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        camera.coordinate
    }

    // Title to show in callout
    var title: String? {
        camera.locationname
    }

    // Optional: You could add subtitle (e.g. camera status or ID)
    var subtitle: String? {
        "Status: \(camera.camerastatus ?? "Unknown")"
    }

    init(camera: CameraObjects) {
        self.camera = camera
    }
}


struct MapSearchBar: UIViewRepresentable {
    @Binding var coordinate: CLLocationCoordinate2D?

    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: MapSearchBar

        init(_ parent: MapSearchBar) {
            self.parent = parent
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let searchText = searchBar.text else { return }
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText

            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let coordinate = response?.mapItems.first?.placemark.coordinate, error == nil else {
                    return
                }

                DispatchQueue.main.async {
                    self.parent.coordinate = coordinate
                }
            }

            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search for location"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {}
}


/*
//@available(iOS 17.0, *)
struct ZoomableAsyncImage: View {
    let imageURL: URL

    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        //.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(width: 350, height: 350, alignment: .topLeading)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350, alignment: .topLeading)
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .onEnded { value in
                                    withAnimation {
                                        scale = max(1.0, min(value, 5.0)) // clamp zoom level
                                    }
                                }
                        )
                case .failure:
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 350, height: 350)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                @unknown default:
                    EmptyView()
                }
            } 
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width: 350, height: 350, alignment: .topLeading)
            .frame(alignment: .leading)
        }
    }
}
*/

