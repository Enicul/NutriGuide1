// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI
import MapKit

// MARK: - Protocol Definition
protocol NearbyFoodViewModeling: ObservableObject {
    var nearbyPlaces: [NearbyFoodPlace] { get }
    var selectedPlace: NearbyFoodPlace? { get set }
    var currentLocation: CLLocationCoordinate2D? { get }
    var searchText: String { get set }
    var selectedCategory: FoodCategory? { get set }
    var sortOption: NearbySortOption { get set }
    var showingMap: Bool { get set }
    var isLoadingLocation: Bool { get }
    var isLoadingPlaces: Bool { get }
    var locationPermissionStatus: LocationPermissionStatus { get }
    
    func requestLocationPermission()
    func searchNearbyPlaces()
    func refreshPlaces()
    func getDirections(to place: NearbyFoodPlace)
    func callPlace(_ place: NearbyFoodPlace)
    func addToFavorites(_ place: NearbyFoodPlace)
}

// MARK: - Supporting Types
struct NearbyFoodPlace {
    let id = UUID()
    let name: String
    let category: FoodCategory
    let cuisine: String
    let rating: Double
    let reviewCount: Int
    let priceLevel: PriceLevel
    let distance: Double // meters
    let estimatedWalkTime: Int // minutes
    let coordinate: CLLocationCoordinate2D
    let address: String
    let phoneNumber: String?
    let website: String?
    let openingHours: OpeningHours
    let features: [PlaceFeature]
    let recommendedItems: [String]
    let healthyOptions: [String]
    var isFavorite: Bool = false
    let images: [String] // System image names as placeholders
    
    enum PriceLevel: String, CaseIterable {
        case budget = "$"
        case moderate = "$$"
        case expensive = "$$$"
        case luxury = "$$$$"
        
        var color: Color {
            switch self {
            case .budget: return .success
            case .moderate: return .warning
            case .expensive: return .stateStressed
            case .luxury: return .error
            }
        }
        
        var description: String {
            switch self {
            case .budget: return "Budget-friendly"
            case .moderate: return "Moderate pricing"
            case .expensive: return "Expensive"
            case .luxury: return "Fine dining"
            }
        }
    }
    
    enum PlaceFeature: String, CaseIterable {
        case takeout = "Takeout"
        case delivery = "Delivery"
        case dineIn = "Dine-in"
        case outdoor = "Outdoor Seating"
        case parking = "Parking"
        case accessible = "Wheelchair Accessible"
        case wifi = "Free WiFi"
        case healthy = "Healthy Options"
        case organic = "Organic"
        case vegan = "Vegan Options"
        case glutenFree = "Gluten-Free"
        
        var icon: String {
            switch self {
            case .takeout: return "bag.fill"
            case .delivery: return "car.fill"
            case .dineIn: return "fork.knife"
            case .outdoor: return "sun.max.fill"
            case .parking: return "car.garage"
            case .accessible: return "figure.roll"
            case .wifi: return "wifi"
            case .healthy: return "leaf.fill"
            case .organic: return "leaf.arrow.circlepath"
            case .vegan: return "leaf.fill"
            case .glutenFree: return "grain"
            }
        }
        
        var color: Color {
            switch self {
            case .takeout, .delivery: return .accentPrimary
            case .dineIn: return .textSecondary
            case .outdoor: return .warning
            case .parking, .accessible: return .info
            case .wifi: return .accentPrimary
            case .healthy, .organic, .vegan: return .success
            case .glutenFree: return .stateStressed
            }
        }
    }
}

struct OpeningHours {
    let isOpen: Bool
    let closingTime: String?
    let todayHours: String
    let weeklyHours: [String] // Mon-Sun
    
    static let sample = OpeningHours(
        isOpen: true,
        closingTime: "9:00 PM",
        todayHours: "7:00 AM - 9:00 PM",
        weeklyHours: [
            "Mon: 7:00 AM - 9:00 PM",
            "Tue: 7:00 AM - 9:00 PM",
            "Wed: 7:00 AM - 9:00 PM",
            "Thu: 7:00 AM - 9:00 PM",
            "Fri: 7:00 AM - 10:00 PM",
            "Sat: 8:00 AM - 10:00 PM",
            "Sun: 8:00 AM - 8:00 PM"
        ]
    )
}

enum FoodCategory: String, CaseIterable {
    case all = "All"
    case healthy = "Healthy"
    case fastFood = "Fast Food"
    case casual = "Casual Dining"
    case fineDining = "Fine Dining"
    case cafe = "Cafe"
    case bakery = "Bakery"
    case juice = "Juice Bar"
    case grocery = "Grocery"
    case market = "Farmers Market"
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .healthy: return "leaf.fill"
        case .fastFood: return "takeoutbag.and.cup.and.straw.fill"
        case .casual: return "fork.knife"
        case .fineDining: return "wineglass.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .bakery: return "birthday.cake.fill"
        case .juice: return "cup.and.saucer.fill"
        case .grocery: return "basket.fill"
        case .market: return "storefront.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .textSecondary
        case .healthy: return .success
        case .fastFood: return .warning
        case .casual: return .accentPrimary
        case .fineDining: return .stateSleepPrep
        case .cafe: return .stateStressed
        case .bakery: return .warning
        case .juice: return .success
        case .grocery: return .info
        case .market: return .success
        }
    }
}

enum NearbySortOption: String, CaseIterable {
    case distance = "Distance"
    case rating = "Rating"
    case price = "Price"
    case healthy = "Healthy Options"
    
    var icon: String {
        switch self {
        case .distance: return "location"
        case .rating: return "star.fill"
        case .price: return "dollarsign.circle"
        case .healthy: return "leaf.fill"
        }
    }
}

enum LocationPermissionStatus {
    case notDetermined
    case denied
    case authorized
    case loading
}

// MARK: - Mock ViewModel
class MockNearbyFoodViewModel: NearbyFoodViewModeling {
    @Published var nearbyPlaces: [NearbyFoodPlace] = []
    @Published var selectedPlace: NearbyFoodPlace? = nil
    @Published var currentLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // SF
    @Published var searchText: String = ""
    @Published var selectedCategory: FoodCategory? = nil
    @Published var sortOption: NearbySortOption = .distance
    @Published var showingMap: Bool = false
    @Published var isLoadingLocation: Bool = false
    @Published var isLoadingPlaces: Bool = false
    @Published var locationPermissionStatus: LocationPermissionStatus = .authorized
    
    init() {
        loadMockPlaces()
    }
    
    private func loadMockPlaces() {
        nearbyPlaces = [
            NearbyFoodPlace(
                name: "Green Bowl",
                category: .healthy,
                cuisine: "Healthy American",
                rating: 4.8,
                reviewCount: 324,
                priceLevel: .moderate,
                distance: 250,
                estimatedWalkTime: 3,
                coordinate: CLLocationCoordinate2D(latitude: 37.7751, longitude: -122.4180),
                address: "123 Health St, San Francisco, CA",
                phoneNumber: "(415) 555-0123",
                website: "greenbowl.com",
                openingHours: OpeningHours.sample,
                features: [.takeout, .dineIn, .healthy, .vegan, .glutenFree],
                recommendedItems: ["Quinoa Bowl", "Kale Salad", "Green Smoothie"],
                healthyOptions: ["Low-calorie options", "Organic ingredients", "Vegan menu"],
                images: ["leaf.fill", "bowl.fill", "carrot.fill"]
            ),
            NearbyFoodPlace(
                name: "Juice Paradise",
                category: .juice,
                cuisine: "Juice & Smoothies",
                rating: 4.6,
                reviewCount: 189,
                priceLevel: .moderate,
                distance: 420,
                estimatedWalkTime: 5,
                coordinate: CLLocationCoordinate2D(latitude: 37.7745, longitude: -122.4210),
                address: "456 Fresh Ave, San Francisco, CA",
                phoneNumber: "(415) 555-0456",
                website: nil,
                openingHours: OpeningHours.sample,
                features: [.takeout, .delivery, .healthy, .organic],
                recommendedItems: ["Green Detox", "Protein Smoothie", "Acai Bowl"],
                healthyOptions: ["Cold-pressed juices", "Superfood bowls", "Protein add-ins"],
                images: ["cup.and.saucer.fill", "leaf.fill", "drop.fill"]
            ),
            NearbyFoodPlace(
                name: "Farm Fresh Market",
                category: .market,
                cuisine: "Farmers Market",
                rating: 4.9,
                reviewCount: 567,
                priceLevel: .moderate,
                distance: 680,
                estimatedWalkTime: 8,
                coordinate: CLLocationCoordinate2D(latitude: 37.7760, longitude: -122.4170),
                address: "789 Market Plaza, San Francisco, CA",
                phoneNumber: "(415) 555-0789",
                website: "farmfreshsf.com",
                openingHours: OpeningHours.sample,
                features: [.outdoor, .organic, .parking, .accessible],
                recommendedItems: ["Organic Produce", "Local Honey", "Fresh Herbs"],
                healthyOptions: ["Organic vegetables", "Local fruits", "Whole grains"],
                images: ["storefront.fill", "leaf.fill", "basket.fill"]
            ),
            NearbyFoodPlace(
                name: "Quick Bites",
                category: .fastFood,
                cuisine: "American Fast Food",
                rating: 3.8,
                reviewCount: 892,
                priceLevel: .budget,
                distance: 150,
                estimatedWalkTime: 2,
                coordinate: CLLocationCoordinate2D(latitude: 37.7747, longitude: -122.4185),
                address: "321 Speed Way, San Francisco, CA",
                phoneNumber: "(415) 555-0321",
                website: nil,
                openingHours: OpeningHours.sample,
                features: [.takeout, .delivery, .dineIn, .parking],
                recommendedItems: ["Grilled Chicken Wrap", "Side Salad", "Fruit Cup"],
                healthyOptions: ["Grilled options", "Salads available", "Fruit sides"],
                images: ["takeoutbag.and.cup.and.straw.fill", "fork.knife", "car.fill"]
            )
        ]
    }
    
    func requestLocationPermission() {
        locationPermissionStatus = .loading
        isLoadingLocation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.locationPermissionStatus = .authorized
            self.isLoadingLocation = false
            self.searchNearbyPlaces()
        }
    }
    
    func searchNearbyPlaces() {
        isLoadingPlaces = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadMockPlaces()
            self.isLoadingPlaces = false
        }
    }
    
    func refreshPlaces() {
        searchNearbyPlaces()
    }
    
    func getDirections(to place: NearbyFoodPlace) {
        // Open Maps app with directions
    }
    
    func callPlace(_ place: NearbyFoodPlace) {
        // Make phone call
    }
    
    func addToFavorites(_ place: NearbyFoodPlace) {
        if let index = nearbyPlaces.firstIndex(where: { $0.id == place.id }) {
            nearbyPlaces[index].isFavorite.toggle()
        }
    }
}

// MARK: - Main Nearby Food View
struct NutriNearbyFoodView<ViewModel: NearbyFoodViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    @State private var showingLocationAlert = false
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Location status header
                LocationStatusHeaderView(
                    status: viewModel.locationPermissionStatus,
                    isLoading: viewModel.isLoadingLocation,
                    onRequestPermission: viewModel.requestLocationPermission
                )
                .padding(.horizontal)
                .padding(.bottom)
                
                // Search and filters
                SearchAndFiltersView(
                    searchText: $viewModel.searchText,
                    selectedCategory: $viewModel.selectedCategory,
                    sortOption: $viewModel.sortOption,
                    showingMap: $viewModel.showingMap,
                    onSearch: viewModel.searchNearbyPlaces
                )
                .padding(.horizontal)
                .padding(.bottom)
                
                // Content
                if viewModel.isLoadingPlaces {
                    Spacer()
                    ProgressView("Finding nearby places...")
                        .scaleEffect(1.2)
                    Spacer()
                } else if viewModel.nearbyPlaces.isEmpty {
                    EmptyNearbyPlacesView(onRefresh: viewModel.refreshPlaces)
                } else {
                    if viewModel.showingMap {
                        NearbyPlacesMapView(
                            places: viewModel.nearbyPlaces,
                            currentLocation: viewModel.currentLocation,
                            selectedPlace: $viewModel.selectedPlace
                        )
                    } else {
                        NearbyPlacesListView(
                            places: viewModel.nearbyPlaces,
                            onPlaceTap: { place in viewModel.selectedPlace = place },
                            onFavorite: viewModel.addToFavorites,
                            onDirections: viewModel.getDirections,
                            onCall: viewModel.callPlace
                        )
                    }
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Nearby Food")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                viewModel.refreshPlaces()
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            PlaceDetailView(
                place: place,
                onFavorite: { viewModel.addToFavorites(place) },
                onDirections: { viewModel.getDirections(to: place) },
                onCall: { viewModel.callPlace(place) }
            )
        }
        .alert("Location Access Required", isPresented: $showingLocationAlert) {
            Button("Settings") {
                // Open Settings app
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please enable location access in Settings to find nearby food options.")
        }
    }
}

// MARK: - Location Status Header
struct LocationStatusHeaderView: View {
    let status: LocationPermissionStatus
    let isLoading: Bool
    let onRequestPermission: () -> Void
    
    var body: some View {
        switch status {
        case .notDetermined, .denied:
            LocationPermissionCard(
                status: status,
                onRequestPermission: onRequestPermission
            )
        case .loading:
            LoadingLocationCard()
        case .authorized:
            if isLoading {
                LoadingLocationCard()
            } else {
                EmptyView()
            }
        }
    }
}

struct LocationPermissionCard: View {
    let status: LocationPermissionStatus
    let onRequestPermission: () -> Void
    
    var body: some View {
        NutriCard(backgroundColor: .warning.opacity(0.1)) {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: SystemIcon.location)
                        .font(.title2)
                        .foregroundColor(.warning)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Location Access Required")
                            .headline()
                            .foregroundColor(.textPrimary)
                        
                        Text("Enable location services to find nearby healthy food options")
                            .body()
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Button(status == .notDetermined ? "Enable Location" : "Open Settings") {
                    onRequestPermission()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(20)
        }
    }
}

struct LoadingLocationCard: View {
    var body: some View {
        NutriCard {
            HStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Finding your location...")
                        .headline()
                        .foregroundColor(.textPrimary)
                    
                    Text("Searching for nearby food options")
                        .body()
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            .padding(20)
        }
    }
}

// MARK: - Search and Filters
struct SearchAndFiltersView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: FoodCategory?
    @Binding var sortOption: NearbySortOption
    @Binding var showingMap: Bool
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Search bar
            HStack {
                Image(systemName: SystemIcon.search)
                    .foregroundColor(.textSecondary)
                
                TextField("Search restaurants, cafes, markets...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        onSearch()
                    }
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                        onSearch()
                    } label: {
                        Image(systemName: SystemIcon.close)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.backgroundSecondary)
            .cornerRadius(12)
            
            // Category and options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Categories
                    ForEach(FoodCategory.allCases, id: \.self) { category in
                        CategoryFilterChip(
                            category: category,
                            isSelected: selectedCategory == category,
                            onTap: {
                                selectedCategory = selectedCategory == category ? nil : category
                                onSearch()
                            }
                        )
                    }
                    
                    Divider()
                        .frame(height: 24)
                    
                    // Sort options
                    Menu {
                        ForEach(NearbySortOption.allCases, id: \.self) { option in
                            Button {
                                sortOption = option
                                onSearch()
                            } label: {
                                HStack {
                                    Image(systemName: option.icon)
                                    Text(option.rawValue)
                                    if sortOption == option {
                                        Image(systemName: SystemIcon.checkmark)
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: sortOption.icon)
                                .font(.caption)
                            Text(sortOption.rawValue)
                                .caption()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.backgroundSecondary)
                        .foregroundColor(.textPrimary)
                        .cornerRadius(8)
                    }
                    
                    // Map toggle
                    Button {
                        showingMap.toggle()
                    } label: {
                        Image(systemName: showingMap ? "list.bullet" : "map")
                            .font(.caption)
                            .padding(8)
                            .background(showingMap ? Color.accentPrimary : Color.backgroundSecondary)
                            .foregroundColor(showingMap ? .textOnAccent : .textPrimary)
                            .cornerRadius(8)
                    }
                    .accessibility(label: Text(showingMap ? "Switch to list view" : "Switch to map view"))
                }
                .padding(.horizontal, 1)
            }
        }
    }
}

struct CategoryFilterChip: View {
    let category: FoodCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .caption()
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? category.color.opacity(0.2) : Color.backgroundSecondary)
            .foregroundColor(isSelected ? category.color : .textPrimary)
            .cornerRadius(8)
        }
        .accessibility(label: Text("\(category.rawValue) category"))
        .accessibility(hint: Text(isSelected ? "Selected" : "Tap to filter by this category"))
    }
}

// MARK: - Places List View
struct NearbyPlacesListView: View {
    let places: [NearbyFoodPlace]
    let onPlaceTap: (NearbyFoodPlace) -> Void
    let onFavorite: (NearbyFoodPlace) -> Void
    let onDirections: (NearbyFoodPlace) -> Void
    let onCall: (NearbyFoodPlace) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(places, id: \.id) { place in
                    NearbyPlaceCard(
                        place: place,
                        onTap: { onPlaceTap(place) },
                        onFavorite: { onFavorite(place) },
                        onDirections: { onDirections(place) },
                        onCall: { onCall(place) }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
    }
}

struct NearbyPlaceCard: View {
    let place: NearbyFoodPlace
    let onTap: () -> Void
    let onFavorite: () -> Void
    let onDirections: () -> Void
    let onCall: () -> Void
    
    var body: some View {
        NutriCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header with name and actions
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(place.name)
                                .headline()
                                .foregroundColor(.textPrimary)
                            
                            if place.isFavorite {
                                Image(systemName: "heart.fill")
                                    .font(.caption)
                                    .foregroundColor(.error)
                            }
                        }
                        
                        Text("\(place.cuisine) • \(place.category.rawValue)")
                            .caption()
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Button(action: onFavorite) {
                            Image(systemName: place.isFavorite ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(place.isFavorite ? .error : .textSecondary)
                        }
                        .accessibility(label: Text(place.isFavorite ? "Remove from favorites" : "Add to favorites"))
                    }
                }
                
                // Rating, price, and status
                HStack(spacing: 16) {
                    // Rating
                    HStack(spacing: 4) {
                        Image(systemName: SystemIcon.star)
                            .font(.caption)
                            .foregroundColor(.warning)
                        
                        Text(String(format: "%.1f", place.rating))
                            .caption()
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                        
                        Text("(\(place.reviewCount))")
                            .caption()
                            .foregroundColor(.textSecondary)
                    }
                    
                    // Price level
                    Text(place.priceLevel.rawValue)
                        .caption()
                        .fontWeight(.medium)
                        .foregroundColor(place.priceLevel.color)
                    
                    Spacer()
                    
                    // Open status
                    HStack(spacing: 4) {
                        Circle()
                            .fill(place.openingHours.isOpen ? Color.success : Color.error)
                            .frame(width: 6, height: 6)
                        
                        Text(place.openingHours.isOpen ? "Open" : "Closed")
                            .caption()
                            .foregroundColor(place.openingHours.isOpen ? .success : .error)
                        
                        if place.openingHours.isOpen, let closingTime = place.openingHours.closingTime {
                            Text("• Closes \(closingTime)")
                                .caption()
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                // Distance and walk time
                HStack(spacing: 4) {
                    Image(systemName: SystemIcon.location)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if place.distance < 1000 {
                        Text("\(Int(place.distance))m")
                            .caption()
                            .foregroundColor(.textSecondary)
                    } else {
                        Text(String(format: "%.1f km", place.distance / 1000))
                            .caption()
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text("• \(place.estimatedWalkTime) min walk")
                        .caption()
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                }
                
                // Features
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(place.features.prefix(4)), id: \.self) { feature in
                            HStack(spacing: 4) {
                                Image(systemName: feature.icon)
                                    .font(.caption2)
                                Text(feature.rawValue)
                                    .caption2()
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(feature.color.opacity(0.1))
                            .foregroundColor(feature.color)
                            .cornerRadius(6)
                        }
                        
                        if place.features.count > 4 {
                            Text("+\(place.features.count - 4)")
                                .caption2()
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                
                // Recommended items
                if !place.recommendedItems.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recommended:")
                            .caption()
                            .foregroundColor(.textSecondary)
                        
                        Text(place.recommendedItems.joined(separator: " • "))
                            .body()
                            .foregroundColor(.textPrimary)
                            .lineLimit(2)
                    }
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    Button("Directions") {
                        onDirections()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .font(.caption)
                    .accessibility(label: Text("Get directions to \(place.name)"))
                    
                    if place.phoneNumber != nil {
                        Button("Call") {
                            onCall()
                        }
                        .buttonStyle(TertiaryButtonStyle())
                        .font(.caption)
                        .accessibility(label: Text("Call \(place.name)"))
                    }
                    
                    Button("Details") {
                        onTap()
                    }
                    .buttonStyle(TertiaryButtonStyle())
                    .font(.caption)
                    .accessibility(label: Text("View details for \(place.name)"))
                }
            }
            .padding(16)
        }
        .accessibility(label: Text("\(place.name), \(place.category.rawValue), \(String(format: "%.1f", place.rating)) stars"))
    }
}

// MARK: - Map View (Simplified)
struct NearbyPlacesMapView: View {
    let places: [NearbyFoodPlace]
    let currentLocation: CLLocationCoordinate2D?
    @Binding var selectedPlace: NearbyFoodPlace?
    
    var body: some View {
        VStack {
            // Placeholder for map implementation
            ZStack {
                Color.backgroundSecondary
                    .cornerRadius(12)
                
                VStack(spacing: 16) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.textTertiary)
                    
                    Text("Map View")
                        .title2()
                        .foregroundColor(.textPrimary)
                    
                    Text("Interactive map showing \(places.count) nearby places")
                        .body()
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(minHeight: 400)
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

// MARK: - Empty State
struct EmptyNearbyPlacesView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "location.slash")
                .font(.system(size: 64))
                .foregroundColor(.textTertiary)
            
            VStack(spacing: 8) {
                Text("No Places Found")
                    .title2()
                    .foregroundColor(.textPrimary)
                
                Text("Try adjusting your search criteria or check your location settings.")
                    .body()
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button("Refresh") {
                onRefresh()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 80)
            
            Spacer()
        }
    }
}

// MARK: - Place Detail View
struct PlaceDetailView: View {
    let place: NearbyFoodPlace
    let onFavorite: () -> Void
    let onDirections: () -> Void
    let onCall: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Hero section
                    PlaceHeroView(place: place)
                    
                    // Opening hours
                    OpeningHoursSection(hours: place.openingHours)
                    
                    // Features and amenities
                    FeaturesSection(features: place.features)
                    
                    // Healthy options
                    if !place.healthyOptions.isEmpty {
                        HealthyOptionsSection(options: place.healthyOptions)
                    }
                    
                    // Contact info
                    ContactInfoSection(place: place, onCall: onCall)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.backgroundPrimary)
            .navigationTitle(place.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: onFavorite) {
                        Image(systemName: place.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(place.isFavorite ? .error : .textSecondary)
                    }
                    
                    Button(action: onDirections) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.accentPrimary)
                    }
                }
            }
        }
    }
}

// MARK: - Detail View Components
struct PlaceHeroView: View {
    let place: NearbyFoodPlace
    
    var body: some View {
        NutriCard {
            VStack(spacing: 16) {
                // Images placeholder
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(place.images, id: \.self) { imageName in
                            Image(systemName: imageName)
                                .font(.system(size: 32))
                                .foregroundColor(.accentPrimary)
                                .frame(width: 80, height: 80)
                                .background(Color.accentPrimary.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                
                VStack(spacing: 8) {
                    Text(place.name)
                        .title()
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("\(place.cuisine) • \(place.category.rawValue)")
                        .subheadline()
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: SystemIcon.star)
                            .foregroundColor(.warning)
                        Text(String(format: "%.1f", place.rating))
                            .fontWeight(.medium)
                        Text("(\(place.reviewCount))")
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text("•")
                        .foregroundColor(.textTertiary)
                    
                    Text(place.priceLevel.rawValue)
                        .fontWeight(.medium)
                        .foregroundColor(place.priceLevel.color)
                    
                    Text("•")
                        .foregroundColor(.textTertiary)
                    
                    if place.distance < 1000 {
                        Text("\(Int(place.distance))m away")
                    } else {
                        Text(String(format: "%.1f km away", place.distance / 1000))
                    }
                }
                .font(.caption)
                .foregroundColor(.textSecondary)
            }
            .padding(20)
        }
    }
}

struct OpeningHoursSection: View {
    let hours: OpeningHours
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hours")
                .headline()
                .foregroundColor(.textPrimary)
            
            NutriCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(hours.isOpen ? Color.success : Color.error)
                            .frame(width: 8, height: 8)
                        
                        Text(hours.isOpen ? "Open now" : "Closed")
                            .headline()
                            .foregroundColor(hours.isOpen ? .success : .error)
                        
                        Spacer()
                        
                        Text(hours.todayHours)
                            .body()
                            .foregroundColor(.textSecondary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(hours.weeklyHours, id: \.self) { dayHours in
                            Text(dayHours)
                                .body()
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .padding(16)
            }
        }
    }
}

struct FeaturesSection: View {
    let features: [NearbyFoodPlace.PlaceFeature]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Features & Amenities")
                .headline()
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 12) {
                        Image(systemName: feature.icon)
                            .font(.title3)
                            .foregroundColor(feature.color)
                            .frame(width: 24)
                        
                        Text(feature.rawValue)
                            .body()
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct HealthyOptionsSection: View {
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Healthy Options")
                .headline()
                .foregroundColor(.textPrimary)
            
            NutriCard(backgroundColor: .success.opacity(0.1)) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        HStack(spacing: 12) {
                            Image(systemName: SystemIcon.checkmark)
                                .font(.caption)
                                .foregroundColor(.success)
                                .frame(width: 16)
                            
                            Text(option)
                                .body()
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                        }
                    }
                }
                .padding(16)
            }
        }
    }
}

struct ContactInfoSection: View {
    let place: NearbyFoodPlace
    let onCall: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact")
                .headline()
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: SystemIcon.location)
                        .font(.title3)
                        .foregroundColor(.accentPrimary)
                        .frame(width: 24)
                    
                    Text(place.address)
                        .body()
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
                
                if let phoneNumber = place.phoneNumber {
                    Button {
                        onCall()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "phone.fill")
                                .font(.title3)
                                .foregroundColor(.accentPrimary)
                                .frame(width: 24)
                            
                            Text(phoneNumber)
                                .body()
                                .foregroundColor(.accentPrimary)
                            
                            Spacer()
                        }
                    }
                }
                
                if let website = place.website {
                    HStack(spacing: 12) {
                        Image(systemName: "globe")
                            .font(.title3)
                            .foregroundColor(.accentPrimary)
                            .frame(width: 24)
                        
                        Text(website)
                            .body()
                            .foregroundColor(.accentPrimary)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct NutriNearbyFoodView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            NutriNearbyFoodView(viewModel: MockNearbyFoodViewModel())
        }
        .previewDevice("iPhone 15 Pro")
    }
}
