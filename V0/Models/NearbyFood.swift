import Foundation
import CoreLocation

// MARK: - Nearby Food Models
struct NearbyFood: Codable, Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let description: String
    let price: Double
    let currency: String
    let distance: Double // in meters
    let location: CLLocationCoordinate2D
    let venue: Venue
    let nutrition: Nutrition
    let dietaryFlags: [String]
    let allergyFlags: [String]
    let availability: Availability
    let rating: Double
    let preparationTime: Int // in minutes
    
    var formattedPrice: String {
        return "\(currency)\(String(format: "%.2f", price))"
    }
    
    var formattedDistance: String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            return "\(String(format: "%.1f", distance/1000))km"
        }
    }
    
    var isAvailable: Bool {
        return availability == .available
    }
}

struct Venue: Codable {
    let name: String
    let type: VenueType
    let address: String
    let phone: String?
    let website: String?
    let rating: Double
    let priceLevel: Int // 1-4
    let openingHours: [String]
    let features: [String]
    
    var formattedPriceLevel: String {
        return String(repeating: "$", count: priceLevel)
    }
}

enum VenueType: String, CaseIterable, Codable {
    case supermarket = "Supermarket"
    case restaurant = "Restaurant"
    case cafe = "Cafe"
    case fastFood = "Fast Food"
    case healthStore = "Health Store"
    case foodTruck = "Food Truck"
    case convenience = "Convenience Store"
    
    var icon: String {
        switch self {
        case .supermarket: return "cart.fill"
        case .restaurant: return "fork.knife"
        case .cafe: return "cup.and.saucer.fill"
        case .fastFood: return "takeoutbag.and.cup.and.straw.fill"
        case .healthStore: return "leaf.fill"
        case .foodTruck: return "truck.box.fill"
        case .convenience: return "storefront.fill"
        }
    }
}

enum Availability: String, CaseIterable, Codable {
    case available = "Available"
    case limited = "Limited"
    case outOfStock = "Out of Stock"
    case closed = "Closed"
    
    var color: String {
        switch self {
        case .available: return "green"
        case .limited: return "orange"
        case .outOfStock: return "red"
        case .closed: return "gray"
        }
    }
}

// MARK: - Nearby Food Service
class NearbyFoodService: ObservableObject {
    @Published var nearbyFoods: [NearbyFood] = []
    @Published var isSearching = false
    @Published var searchRadius: Double = 2000 // meters
    
    private let mockVenues: [Venue] = [
        Venue(
            name: "Whole Foods Market",
            type: .supermarket,
            address: "123 Main St, Downtown",
            phone: "+1-555-0123",
            website: "wholefoodsmarket.com",
            rating: 4.5,
            priceLevel: 3,
            openingHours: ["Mon-Sun: 7AM-10PM"],
            features: ["Organic", "Fresh Produce", "Deli", "Bakery"]
        ),
        Venue(
            name: "Green Garden Restaurant",
            type: .restaurant,
            address: "456 Oak Ave, Midtown",
            phone: "+1-555-0456",
            website: "greengarden.com",
            rating: 4.2,
            priceLevel: 2,
            openingHours: ["Mon-Sat: 11AM-9PM", "Sun: 12PM-8PM"],
            features: ["Vegetarian", "Vegan Options", "Gluten-Free", "Outdoor Seating"]
        ),
        Venue(
            name: "Joe's Coffee & Smoothies",
            type: .cafe,
            address: "789 Pine St, Uptown",
            phone: "+1-555-0789",
            website: "joescoffee.com",
            rating: 4.0,
            priceLevel: 2,
            openingHours: ["Mon-Fri: 6AM-6PM", "Sat-Sun: 7AM-5PM"],
            features: ["Fresh Smoothies", "Acai Bowls", "Cold Brew", "WiFi"]
        ),
        Venue(
            name: "FitLife Health Store",
            type: .healthStore,
            address: "321 Elm St, Health District",
            phone: "+1-555-0321",
            website: "fitlifehealth.com",
            rating: 4.7,
            priceLevel: 3,
            openingHours: ["Mon-Sat: 9AM-8PM", "Sun: 10AM-6PM"],
            features: ["Supplements", "Protein Powders", "Organic", "Nutritionist"]
        ),
        Venue(
            name: "Fresh Market Express",
            type: .convenience,
            address: "654 Maple Dr, Suburbs",
            phone: "+1-555-0654",
            website: nil,
            rating: 3.8,
            priceLevel: 2,
            openingHours: ["24/7"],
            features: ["24/7", "Fresh Produce", "Deli", "ATM"]
        )
    ]
    
    func searchNearbyFoods(for recommendation: NutritionalRecommendation, userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)) {
        isSearching = true
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.nearbyFoods = self.generateMockNearbyFoods(for: recommendation, userLocation: userLocation)
            self.isSearching = false
        }
    }
    
    private func generateMockNearbyFoods(for recommendation: NutritionalRecommendation, userLocation: CLLocationCoordinate2D) -> [NearbyFood] {
        var foods: [NearbyFood] = []
        
        // Generate foods based on nutritional priorities
        for priority in recommendation.priorityNutrients {
            switch priority.nutrient {
            case "Protein":
                foods.append(contentsOf: generateProteinFoods(priority: priority, userLocation: userLocation))
            case "Magnesium":
                foods.append(contentsOf: generateMagnesiumFoods(priority: priority, userLocation: userLocation))
            case "Tryptophan":
                foods.append(contentsOf: generateTryptophanFoods(priority: priority, userLocation: userLocation))
            case "Water":
                foods.append(contentsOf: generateHydrationFoods(priority: priority, userLocation: userLocation))
            default:
                break
            }
        }
        
        // Add some general healthy options
        foods.append(contentsOf: generateGeneralHealthyFoods(userLocation: userLocation))
        
        // Sort by distance and rating
        return foods.sorted { $0.distance < $1.distance }
    }
    
    private func generateProteinFoods(priority: PriorityNutrient, userLocation: CLLocationCoordinate2D) -> [NearbyFood] {
        let proteinFoods = [
            ("Grilled Chicken Breast", "🍗", "Lean protein, perfect for muscle recovery", 12.99, "USD", 150, ["Gluten-Free", "Keto"]),
            ("Greek Yogurt Parfait", "🥛", "High protein with berries and granola", 8.50, "USD", 300, ["Vegetarian", "High Protein"]),
            ("Salmon Bowl", "🐟", "Omega-3 rich salmon with quinoa and vegetables", 16.99, "USD", 500, ["Gluten-Free", "High Protein"]),
            ("Protein Smoothie", "🥤", "Plant-based protein with banana and spinach", 9.99, "USD", 200, ["Vegan", "High Protein"]),
            ("Turkey Wrap", "🌯", "Lean turkey with avocado and vegetables", 11.50, "USD", 400, ["Gluten-Free", "High Protein"])
        ]
        
        return proteinFoods.enumerated().map { index, food in
            NearbyFood(
                name: food.0,
                emoji: food.1,
                description: food.2,
                price: food.3,
                currency: food.4,
                distance: Double(food.5),
                location: generateNearbyLocation(userLocation, offset: Double(index * 100)),
                venue: mockVenues[index % mockVenues.count],
                nutrition: generateProteinNutrition(),
                dietaryFlags: food.6,
                allergyFlags: [],
                availability: .available,
                rating: 4.0 + Double.random(in: 0...1),
                preparationTime: Int.random(in: 5...15)
            )
        }
    }
    
    private func generateMagnesiumFoods(priority: PriorityNutrient, userLocation: CLLocationCoordinate2D) -> [NearbyFood] {
        let magnesiumFoods = [
            ("Dark Chocolate (85%)", "🍫", "Rich in magnesium and antioxidants", 4.99, "USD", 250, ["Vegetarian", "Antioxidant"]),
            ("Almond Butter Toast", "🍞", "Magnesium-rich almonds on whole grain", 7.50, "USD", 180, ["Vegetarian", "High Fiber"]),
            ("Spinach Salad", "🥗", "Fresh spinach with nuts and seeds", 9.99, "USD", 320, ["Vegan", "Low Calorie"]),
            ("Pumpkin Seeds", "🎃", "High magnesium snack, perfect for stress relief", 6.99, "USD", 100, ["Vegan", "High Protein"]),
            ("Banana Smoothie", "🍌", "Potassium and magnesium in a refreshing drink", 6.50, "USD", 220, ["Vegan", "Natural"]
            )
        ]
        
        return magnesiumFoods.enumerated().map { index, food in
            NearbyFood(
                name: food.0,
                emoji: food.1,
                description: food.2,
                price: food.3,
                currency: food.4,
                distance: Double(food.5),
                location: generateNearbyLocation(userLocation, offset: Double(index * 120)),
                venue: mockVenues[index % mockVenues.count],
                nutrition: generateMagnesiumNutrition(),
                dietaryFlags: food.6,
                allergyFlags: [],
                availability: .available,
                rating: 4.2 + Double.random(in: 0...0.8),
                preparationTime: Int.random(in: 2...10)
            )
        }
    }
    
    private func generateTryptophanFoods(priority: PriorityNutrient, userLocation: CLLocationCoordinate2D) -> [NearbyFood] {
        let tryptophanFoods = [
            ("Turkey Sandwich", "🥪", "Tryptophan-rich turkey for better sleep", 10.99, "USD", 350, ["High Protein", "Comfort Food"]),
            ("Milk & Honey", "🥛", "Classic bedtime combination", 4.50, "USD", 150, ["Vegetarian", "Natural"]),
            ("Oatmeal with Nuts", "🥣", "Complex carbs and tryptophan for sleep", 8.99, "USD", 280, ["Vegan", "High Fiber"]),
            ("Chamomile Tea", "🍵", "Calming herbal tea for relaxation", 3.99, "USD", 80, ["Vegan", "Caffeine-Free"]),
            ("Walnut Energy Balls", "🌰", "Tryptophan and healthy fats", 7.50, "USD", 200, ["Vegan", "High Protein"]
            )
        ]
        
        return tryptophanFoods.enumerated().map { index, food in
            NearbyFood(
                name: food.0,
                emoji: food.1,
                description: food.2,
                price: food.3,
                currency: food.4,
                distance: Double(food.5),
                location: generateNearbyLocation(userLocation, offset: Double(index * 90)),
                venue: mockVenues[index % mockVenues.count],
                nutrition: generateTryptophanNutrition(),
                dietaryFlags: food.6,
                allergyFlags: [],
                availability: .available,
                rating: 4.1 + Double.random(in: 0...0.9),
                preparationTime: Int.random(in: 3...12)
            )
        }
    }
    
    private func generateHydrationFoods(priority: PriorityNutrient, userLocation: CLLocationCoordinate2D) -> [NearbyFood] {
        let hydrationFoods = [
            ("Coconut Water", "🥥", "Natural electrolytes and hydration", 3.99, "USD", 120, ["Vegan", "Natural"]),
            ("Watermelon Slice", "🍉", "High water content and refreshing", 4.50, "USD", 180, ["Vegan", "Low Calorie"]),
            ("Cucumber Water", "🥒", "Infused water for extra hydration", 2.99, "USD", 100, ["Vegan", "Detox"]),
            ("Herbal Tea", "🍵", "Hydrating and calming", 3.50, "USD", 90, ["Vegan", "Caffeine-Free"]),
            ("Fresh Orange Juice", "🍊", "Vitamin C and natural hydration", 5.99, "USD", 200, ["Vegan", "Vitamin C"]
            )
        ]
        
        return hydrationFoods.enumerated().map { index, food in
            NearbyFood(
                name: food.0,
                emoji: food.1,
                description: food.2,
                price: food.3,
                currency: food.4,
                distance: Double(food.5),
                location: generateNearbyLocation(userLocation, offset: Double(index * 80)),
                venue: mockVenues[index % mockVenues.count],
                nutrition: generateHydrationNutrition(),
                dietaryFlags: food.6,
                allergyFlags: [],
                availability: .available,
                rating: 4.3 + Double.random(in: 0...0.7),
                preparationTime: Int.random(in: 1...5)
            )
        }
    }
    
    private func generateGeneralHealthyFoods(userLocation: CLLocationCoordinate2D) -> [NearbyFood] {
        let healthyFoods = [
            ("Acai Bowl", "🥣", "Antioxidant-rich superfood bowl", 12.99, "USD", 400, ["Vegan", "Antioxidant"]),
            ("Quinoa Salad", "🥗", "Complete protein with vegetables", 11.50, "USD", 350, ["Vegan", "High Protein"]),
            ("Avocado Toast", "🥑", "Healthy fats and fiber", 9.99, "USD", 250, ["Vegetarian", "High Fiber"]),
            ("Green Smoothie", "🥤", "Nutrient-dense vegetable smoothie", 8.50, "USD", 300, ["Vegan", "Detox"]),
            ("Hummus & Veggies", "🥕", "Plant-based protein and vitamins", 7.99, "USD", 200, ["Vegan", "High Fiber"]
            )
        ]
        
        return healthyFoods.enumerated().map { index, food in
            NearbyFood(
                name: food.0,
                emoji: food.1,
                description: food.2,
                price: food.3,
                currency: food.4,
                distance: Double(food.5),
                location: generateNearbyLocation(userLocation, offset: Double(index * 150)),
                venue: mockVenues[index % mockVenues.count],
                nutrition: generateGeneralNutrition(),
                dietaryFlags: food.6,
                allergyFlags: [],
                availability: .available,
                rating: 4.4 + Double.random(in: 0...0.6),
                preparationTime: Int.random(in: 5...20)
            )
        }
    }
    
    private func generateNearbyLocation(_ userLocation: CLLocationCoordinate2D, offset: Double) -> CLLocationCoordinate2D {
        let latOffset = (Double.random(in: -1...1) * offset) / 111000 // Rough conversion to degrees
        let lonOffset = (Double.random(in: -1...1) * offset) / 111000
        return CLLocationCoordinate2D(
            latitude: userLocation.latitude + latOffset,
            longitude: userLocation.longitude + lonOffset
        )
    }
    
    private func generateProteinNutrition() -> Nutrition {
        return Nutrition(
            kcal: Double.random(in: 200...400),
            carbs: Double.random(in: 10...30),
            protein: Double.random(in: 20...40),
            fat: Double.random(in: 5...15),
            micros: ["Mg": Double.random(in: 50...100), "B6": Double.random(in: 0.5...2.0)]
        )
    }
    
    private func generateMagnesiumNutrition() -> Nutrition {
        return Nutrition(
            kcal: Double.random(in: 150...300),
            carbs: Double.random(in: 15...40),
            protein: Double.random(in: 5...15),
            fat: Double.random(in: 8...20),
            micros: ["Mg": Double.random(in: 100...200), "K": Double.random(in: 200...500)]
        )
    }
    
    private func generateTryptophanNutrition() -> Nutrition {
        return Nutrition(
            kcal: Double.random(in: 180...350),
            carbs: Double.random(in: 20...45),
            protein: Double.random(in: 8...25),
            fat: Double.random(in: 6...18),
            micros: ["Tryptophan": Double.random(in: 0.1...0.5), "B6": Double.random(in: 0.3...1.5)]
        )
    }
    
    private func generateHydrationNutrition() -> Nutrition {
        return Nutrition(
            kcal: Double.random(in: 50...150),
            carbs: Double.random(in: 10...25),
            protein: Double.random(in: 1...5),
            fat: Double.random(in: 0...3),
            micros: ["Water": Double.random(in: 200...400), "K": Double.random(in: 100...300)]
        )
    }
    
    private func generateGeneralNutrition() -> Nutrition {
        return Nutrition(
            kcal: Double.random(in: 200...350),
            carbs: Double.random(in: 20...35),
            protein: Double.random(in: 10...20),
            fat: Double.random(in: 8...15),
            micros: ["Mg": Double.random(in: 30...80), "C": Double.random(in: 20...60)]
        )
    }
}

// MARK: - CLLocationCoordinate2D Codable Extension
extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

