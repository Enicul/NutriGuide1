# SwiftUI NutriGuide Implementation

## Overview

This directory contains a complete SwiftUI implementation of the NutriGuide nutrition app. All files are **self-contained** and can be copied into any Swift project without dependencies on existing architecture.

## 📁 File Structure

### Design System
- **`DesignSystem/NutriGuideDesignSystem.swift`** - Comprehensive design system with semantic colors, typography, reusable components, and sample data models

### Views
- **`Views/NutriHomeView.swift`** - Main home screen with health state monitoring and food recommendations
- **`Views/NutriSmartwatchSyncView.swift`** - Apple Watch synchronization interface with health data management
- **`Views/NutriSettingsView.swift`** - Comprehensive settings with user profile, preferences, and privacy controls
- **`Views/NutriRecommendationView.swift`** - Detailed nutritional recommendations with filtering and sorting
- **`Views/NutriNearbyFoodView.swift`** - Location-based food discovery with map integration
- **`Views/NutriHealthCardsView.swift`** - Health metrics dashboard with detailed analytics
- **`Views/NutriRootView.swift`** - Main app entry point with tab navigation and onboarding

## ✨ Key Features

### 🎨 Design System Compliance
- **Apple HIG Compliant**: Follows Human Interface Guidelines
- **Accessibility**: Full VoiceOver support, minimum 44pt touch targets
- **Dynamic Type**: Scalable fonts throughout
- **Dark Mode**: Semantic colors support both light and dark themes
- **SF Symbols**: Uses only native system icons

### 📱 Self-Contained Architecture
- **Protocol-based ViewModels**: Clean abstraction layer for each view
- **Mock Data**: Complete sample data for demonstrations
- **No Dependencies**: Uses only native SwiftUI and Apple frameworks
- **Independent Files**: Each view can run in Xcode Previews standalone

### 🏥 Health Integration
- **Apple Watch Sync**: Real-time health data synchronization
- **Health Metrics**: Heart rate, steps, sleep, stress level monitoring
- **Smart State Detection**: AI-powered health state analysis
- **Nutritional Recommendations**: Personalized food suggestions based on health data

### 🍎 Nutrition Features
- **Smart Recommendations**: AI-driven food suggestions
- **Dietary Preferences**: Support for vegetarian, vegan, keto, etc.
- **Allergy Management**: Comprehensive allergy and intolerance tracking
- **Nutritional Analysis**: Detailed macro and micronutrient information

### 📍 Location Services
- **Nearby Food Discovery**: Find healthy restaurants, cafes, markets
- **Map Integration**: Visual location-based search
- **Availability Tracking**: Real-time open/closed status
- **Healthy Options Filter**: Focus on nutritious choices

## 🛠 Technical Implementation

### Architecture Patterns
- **MVVM**: Clean separation of concerns with protocol-based ViewModels
- **Composition**: Reusable components following single responsibility principle
- **State Management**: `@StateObject` and `@Published` for reactive UI

### SwiftUI Best Practices
- **Native Layout**: Uses `VStack`, `HStack`, `ZStack`, `LazyVGrid`
- **Semantic UI**: Meaningful component names and structure
- **Performance**: Lazy loading for large lists
- **Animation**: Smooth, purposeful transitions

### Accessibility Features
- **VoiceOver Labels**: Descriptive labels for all interactive elements
- **Hints**: Contextual hints for complex interactions
- **Touch Targets**: Minimum 44pt size for all buttons
- **Color Contrast**: WCAG compliant color combinations

## 📱 Screen Coverage

### 1. Home Screen (`NutriHomeView.swift`)
- Health state monitoring card
- Quick health metrics overview
- Personalized food recommendations
- Smart sync integration
- Snooze and explanation modals

### 2. Apple Watch Sync (`NutriSmartwatchSyncView.swift`)
- Connection status management
- Health data synchronization
- Sync history tracking
- Permission management
- Data visualization

### 3. Settings (`NutriSettingsView.swift`)
- User profile setup
- Dietary preferences and allergies
- Notification controls
- Privacy settings
- Data export/import

### 4. Nutritional Recommendations (`NutriRecommendationView.swift`)
- Detailed food recommendations
- Filtering and sorting options
- Nutritional benefit analysis
- Preparation difficulty indicators
- Alternative suggestions

### 5. Nearby Food (`NutriNearbyFoodView.swift`)
- Location-based food discovery
- Restaurant and market finder
- Healthy options filtering
- Map and list views
- Contact and directions

### 6. Health Dashboard (`NutriHealthCardsView.swift`)
- Comprehensive health metrics
- Interactive charts and trends
- Target range indicators
- Insights and recommendations
- Time-based analysis

### 7. Root Navigation (`NutriRootView.swift`)
- Tab-based navigation
- Onboarding flow
- App state management
- Loading and error states

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Copy any individual file(s) to your Xcode project
2. Each file is self-contained and will compile independently
3. Use the mock ViewModels for demonstration, replace with real implementations

### Usage Examples

#### Basic Home View
```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NutriHomeView(viewModel: MockHomeViewModel())
    }
}
```

#### Complete App with Tab Navigation
```swift
import SwiftUI

@main
struct MyNutriApp: App {
    var body: some Scene {
        WindowGroup {
            NutriRootView(viewModel: MockRootViewModel())
        }
    }
}
```

## 🎯 Mock Data

Each view includes comprehensive mock data for demonstration:

- **Health States**: Calm, Stressed, Low Energy, Post-Workout, Sleep Prep, Focus Needed
- **Food Items**: Detailed nutrition information, preparation time, difficulty
- **Health Metrics**: Heart rate, steps, sleep, stress, calories, oxygen levels
- **User Preferences**: Dietary restrictions, allergies, goals
- **Location Data**: Nearby restaurants, markets, healthy options

## 📱 Previews

Each file includes `PreviewProvider` with:
- **iPhone 15 Pro** preview device
- **DevicePreview** wrapper for realistic device appearance
- **Rounded corners** simulation
- **Multiple preview scenarios** where applicable

## 🔧 Customization

### Colors and Themes
All colors are defined in the design system using semantic tokens:
```swift
// Background colors
.backgroundPrimary
.backgroundSecondary
.backgroundCard

// Text colors
.textPrimary
.textSecondary
.textTertiary

// Accent colors
.accentPrimary
.accentSecondary
```

### Typography
Typography system with Dynamic Type support:
```swift
Text("Hello").largeTitle()
Text("World").title()
Text("Content").body()
```

### Components
Reusable components ready for customization:
- `NutriCard` - Primary container component
- `HealthStateTag` - Status indicators
- `NutritionBadge` - Nutritional information
- Button styles - Primary, Secondary, Tertiary

## 🔒 Privacy & Security

- **Health Data**: Processed locally, requires explicit user permission
- **Location Services**: Optional, with clear permission requests
- **Data Sharing**: User-controlled privacy settings
- **Analytics**: Opt-in only with transparency

## 📋 Requirements Compliance

### Apple Human Interface Guidelines
✅ **Touch Targets**: Minimum 44pt size
✅ **Accessibility**: Full VoiceOver support
✅ **Dynamic Type**: Scalable fonts
✅ **Color Contrast**: WCAG compliant
✅ **Navigation**: Intuitive tab-based structure

### Technical Requirements
✅ **Self-contained**: No external dependencies
✅ **Protocol-based**: Clean abstraction layers
✅ **Mock Data**: Complete sample implementations
✅ **Xcode Previews**: All views preview-ready
✅ **SF Symbols**: Native icon system
✅ **Semantic Colors**: Light/Dark mode support

## 📄 License

This implementation is provided as example code for educational and development purposes. Each file includes a header comment indicating it is self-contained and should be renamed/integrated according to your project's conventions.

---

*Generated with comprehensive SwiftUI best practices and Apple HIG compliance.*
