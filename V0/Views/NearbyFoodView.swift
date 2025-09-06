import SwiftUI
import CoreLocation

struct NearbyFoodView: View {
    @ObservedObject var nearbyFoodService: NearbyFoodService
    @State private var selectedFilter: VenueType?
    @State private var sortBy: SortOption = .distance
    @State private var searchRadius: Double = 2000
    
    enum SortOption: String, CaseIterable {
        case distance = "Distance"
        case price = "Price"
        case rating = "Rating"
        case preparationTime = "Prep Time"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                ERNIconView(ERNIcon.location, color: .ernAccent, size: 24)
                Text("Nearby Options")
                    .ernHeadline()
                Spacer()
                Button("Refresh") {
                    // Refresh action will be handled by parent
                }
                .ernTertiary()
            }
            
            // Filters and Sorting
            VStack(spacing: 12) {
                // Venue Type Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All",
                            isSelected: selectedFilter == nil,
                            action: { selectedFilter = nil }
                        )
                        
                        ForEach(VenueType.allCases, id: \.self) { type in
                            FilterChip(
                                title: type.rawValue,
                                isSelected: selectedFilter == type,
                                action: { selectedFilter = type }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Sort Options
                HStack {
                    Text("Sort by:")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    
                    Picker("Sort", selection: $sortBy) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                }
            }
            
            // Food List
            if nearbyFoodService.isSearching {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Finding nearby options...")
                        .ernBody()
                        .foregroundColor(.ernTextSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filteredAndSortedFoods.isEmpty {
                VStack(spacing: 16) {
                    ERNIconView(ERNIcon.search, color: .ernTextSecondary, size: 48)
                    Text("No options found")
                        .ernTitle3()
                        .foregroundColor(.ernTextSecondary)
                    Text("Try adjusting your filters or expanding the search radius")
                        .ernBody()
                        .foregroundColor(.ernTextTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredAndSortedFoods) { food in
                            NearbyFoodCard(food: food)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var filteredAndSortedFoods: [NearbyFood] {
        var foods = nearbyFoodService.nearbyFoods
        
        // Filter by venue type
        if let selectedFilter = selectedFilter {
            foods = foods.filter { $0.venue.type == selectedFilter }
        }
        
        // Sort by selected option
        switch sortBy {
        case .distance:
            foods.sort { $0.distance < $1.distance }
        case .price:
            foods.sort { $0.price < $1.price }
        case .rating:
            foods.sort { $0.rating > $1.rating }
        case .preparationTime:
            foods.sort { $0.preparationTime < $1.preparationTime }
        }
        
        return foods
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .ernCaption()
                .foregroundColor(isSelected ? .white : .ernTextPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.ernAccent : Color.ernCardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.ernAccent : Color.ernTextSecondary.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NearbyFoodCard: View {
    let food: NearbyFood
    @State private var showingDetails = false
    
    var body: some View {
        ERNCard {
            VStack(spacing: 12) {
                // Header
                HStack(alignment: .top, spacing: 12) {
                    // Food emoji
                    Text(food.emoji)
                        .font(.system(size: 32))
                        .accessibilityHidden(true)
                    
                    // Food info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(food.name)
                            .ernHeadline()
                            .foregroundColor(.ernTextPrimary)
                        
                        Text(food.description)
                            .ernCaption()
                            .foregroundColor(.ernTextSecondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    // Availability indicator
                    AvailabilityIndicator(availability: food.availability)
                }
                
                // Venue info
                HStack {
                    ERNIconView(ERNIcon(iconName: food.venue.type.icon), color: .ernAccent, size: 16)
                    Text(food.venue.name)
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    
                    Spacer()
                    
                    Text(food.venue.formattedPriceLevel)
                        .ernCaption()
                        .foregroundColor(.ernTextTertiary)
                }
                
                // Price and distance
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(food.formattedPrice)
                            .ernBodyEmphasized()
                            .foregroundColor(.ernTextPrimary)
                        Text("Price")
                            .ernCaption2()
                            .foregroundColor(.ernTextTertiary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 2) {
                        Text(food.formattedDistance)
                            .ernBodyEmphasized()
                            .foregroundColor(.ernTextPrimary)
                        Text("Distance")
                            .ernCaption2()
                            .foregroundColor(.ernTextTertiary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 2) {
                            ERNIconView(ERNIcon.star, color: .ernWarning, size: 12)
                            Text(String(format: "%.1f", food.rating))
                                .ernBodyEmphasized()
                                .foregroundColor(.ernTextPrimary)
                        }
                        Text("Rating")
                            .ernCaption2()
                            .foregroundColor(.ernTextTertiary)
                    }
                }
                
                // Dietary flags
                if !food.dietaryFlags.isEmpty || !food.allergyFlags.isEmpty {
                    HStack {
                        ForEach(food.dietaryFlags.prefix(3), id: \.self) { flag in
                            DietaryFlag(flag: flag, isAllergy: false)
                        }
                        
                        ForEach(food.allergyFlags.prefix(2), id: \.self) { flag in
                            DietaryFlag(flag: flag, isAllergy: true)
                        }
                        
                        Spacer()
                    }
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    Button("View Details") {
                        showingDetails.toggle()
                    }
                    .ernSecondary()
                    .frame(maxWidth: .infinity)
                    
                    Button("Get Directions") {
                        // TODO: Open maps with directions
                    }
                    .ernTertiary()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .sheet(isPresented: $showingDetails) {
            NearbyFoodDetailView(food: food)
        }
    }
}

struct AvailabilityIndicator: View {
    let availability: Availability
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(availabilityColor)
                .frame(width: 8, height: 8)
            
            Text(availability.rawValue)
                .ernCaption2()
                .foregroundColor(availabilityColor)
        }
    }
    
    private var availabilityColor: Color {
        switch availability {
        case .available: return .ernSuccess
        case .limited: return .ernWarning
        case .outOfStock: return .ernError
        case .closed: return .ernTextTertiary
        }
    }
}

struct DietaryFlag: View {
    let flag: String
    let isAllergy: Bool
    
    var body: some View {
        Text(flag)
            .ernCaption2()
            .foregroundColor(isAllergy ? .ernError : .ernSuccess)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background((isAllergy ? .ernError : .ernSuccess).opacity(0.1))
            .cornerRadius(4)
    }
}

struct NearbyFoodDetailView: View {
    let food: NearbyFood
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Text(food.emoji)
                            .font(.system(size: 64))
                        
                        Text(food.name)
                            .ernTitle2()
                            .multilineTextAlignment(.center)
                        
                        Text(food.description)
                            .ernBody()
                            .foregroundColor(.ernTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Venue info
                    ERNCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                ERNIconView(ERNIcon(iconName: food.venue.type.icon), color: .ernAccent, size: 20)
                                Text(food.venue.name)
                                    .ernHeadline()
                                Spacer()
                            }
                            
                            Text(food.venue.address)
                                .ernBody()
                                .foregroundColor(.ernTextSecondary)
                            
                            HStack {
                                HStack(spacing: 4) {
                                    ERNIconView(ERNIcon.star, color: .ernWarning, size: 16)
                                    Text(String(format: "%.1f", food.venue.rating))
                                        .ernBody()
                                }
                                
                                Spacer()
                                
                                Text(food.venue.formattedPriceLevel)
                                    .ernBody()
                                    .foregroundColor(.ernTextSecondary)
                            }
                            
                            if let phone = food.venue.phone {
                                Button("Call \(phone)") {
                                    // TODO: Make phone call
                                }
                                .ernTertiary()
                            }
                        }
                    }
                    
                    // Nutrition info
                    ERNCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Nutrition (per serving)")
                                .ernHeadline()
                            
                            VStack(spacing: 8) {
                                NutritionRow(label: "Calories", value: "\(Int(food.nutrition.kcal))", unit: "kcal")
                                NutritionRow(label: "Protein", value: "\(String(format: "%.1f", food.nutrition.protein))", unit: "g")
                                NutritionRow(label: "Carbs", value: "\(String(format: "%.1f", food.nutrition.carbs))", unit: "g")
                                NutritionRow(label: "Fat", value: "\(String(format: "%.1f", food.nutrition.fat))", unit: "g")
                            }
                        }
                    }
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        Button("Order Now") {
                            // TODO: Handle ordering
                        }
                        .ernPrimary()
                        .frame(maxWidth: .infinity)
                        
                        Button("Get Directions") {
                            // TODO: Open maps
                        }
                        .ernSecondary()
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .background(Color.ernBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .ernTertiary()
                }
            }
        }
    }
}

struct NutritionRow: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(label)
                .ernBody()
                .foregroundColor(.ernTextSecondary)
            
            Spacer()
            
            Text("\(value) \(unit)")
                .ernBodyEmphasized()
        }
    }
}

// MARK: - Preview
#Preview {
    NearbyFoodView(nearbyFoodService: NearbyFoodService())
        .padding()
        .background(Color.ernBackground)
}

