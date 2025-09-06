import Foundation

// MARK: - Health Data Models
struct HealthData: Codable, Identifiable {
    let id = UUID()
    let timestamp: Date
    let heartRateVariability: HeartRateVariability
    let sleepData: SleepData
    let activityData: ActivityData
    let stressLevel: StressLevel
    let hydrationLevel: HydrationLevel
    
    var overallHealthScore: Double {
        let hrvScore = heartRateVariability.healthScore
        let sleepScore = sleepData.healthScore
        let activityScore = activityData.healthScore
        let stressScore = stressLevel.healthScore
        let hydrationScore = hydrationLevel.healthScore
        
        return (hrvScore + sleepScore + activityScore + stressScore + hydrationScore) / 5.0
    }
}

struct HeartRateVariability: Codable {
    let rmssd: Double // Root Mean Square of Successive Differences
    let sdnn: Double  // Standard Deviation of NN intervals
    let pnn50: Double // Percentage of NN intervals differing by more than 50ms
    
    var healthScore: Double {
        // Normalize HRV values to 0-1 scale
        let normalizedRMSSD = min(max(rmssd / 50.0, 0), 1) // 0-50ms range
        let normalizedSDNN = min(max(sdnn / 100.0, 0), 1)  // 0-100ms range
        let normalizedPNN50 = min(max(pnn50 / 20.0, 0), 1) // 0-20% range
        
        return (normalizedRMSSD + normalizedSDNN + normalizedPNN50) / 3.0
    }
    
    var interpretation: String {
        switch healthScore {
        case 0.8...1.0: return "Excellent recovery"
        case 0.6..<0.8: return "Good recovery"
        case 0.4..<0.6: return "Moderate recovery"
        case 0.2..<0.4: return "Poor recovery"
        default: return "Very poor recovery"
        }
    }
}

struct SleepData: Codable {
    let totalSleepTime: TimeInterval // in seconds
    let deepSleepTime: TimeInterval
    let remSleepTime: TimeInterval
    let lightSleepTime: TimeInterval
    let sleepEfficiency: Double // percentage
    let sleepOnsetTime: TimeInterval // time to fall asleep in seconds
    
    var healthScore: Double {
        let sleepDurationScore = min(max(totalSleepTime / (8 * 3600), 0), 1) // 8 hours ideal
        let deepSleepScore = min(max(deepSleepTime / (2 * 3600), 0), 1) // 2 hours ideal
        let efficiencyScore = sleepEfficiency / 100.0
        let onsetScore = min(max(1 - (sleepOnsetTime / (30 * 60)), 0), 1) // 30 min ideal onset
        
        return (sleepDurationScore + deepSleepScore + efficiencyScore + onsetScore) / 4.0
    }
    
    var interpretation: String {
        switch healthScore {
        case 0.8...1.0: return "Excellent sleep quality"
        case 0.6..<0.8: return "Good sleep quality"
        case 0.4..<0.6: return "Moderate sleep quality"
        case 0.2..<0.4: return "Poor sleep quality"
        default: return "Very poor sleep quality"
        }
    }
}

struct ActivityData: Codable {
    let steps: Int
    let activeMinutes: Int
    let caloriesBurned: Double
    let exerciseMinutes: Int
    let standingHours: Int
    
    var healthScore: Double {
        let stepsScore = min(max(Double(steps) / 10000, 0), 1) // 10k steps ideal
        let activeScore = min(max(Double(activeMinutes) / 150, 0), 1) // 150 min ideal
        let exerciseScore = min(max(Double(exerciseMinutes) / 60, 0), 1) // 60 min ideal
        let standingScore = min(max(Double(standingHours) / 12, 0), 1) // 12 hours ideal
        
        return (stepsScore + activeScore + exerciseScore + standingScore) / 4.0
    }
    
    var interpretation: String {
        switch healthScore {
        case 0.8...1.0: return "Highly active day"
        case 0.6..<0.8: return "Moderately active day"
        case 0.4..<0.6: return "Lightly active day"
        case 0.2..<0.4: return "Sedentary day"
        default: return "Very sedentary day"
        }
    }
}

struct StressLevel: Codable {
    let perceivedStress: Double // 1-10 scale
    let cortisolLevel: Double // normalized 0-1
    let heartRateResting: Double // bpm
    
    var healthScore: Double {
        let stressScore = 1 - (perceivedStress - 1) / 9 // invert 1-10 to 0-1
        let cortisolScore = 1 - cortisolLevel // lower is better
        let hrScore = min(max(1 - abs(heartRateResting - 60) / 30, 0), 1) // 60 bpm ideal
        
        return (stressScore + cortisolScore + hrScore) / 3.0
    }
    
    var interpretation: String {
        switch healthScore {
        case 0.8...1.0: return "Very low stress"
        case 0.6..<0.8: return "Low stress"
        case 0.4..<0.6: return "Moderate stress"
        case 0.2..<0.4: return "High stress"
        default: return "Very high stress"
        }
    }
}

struct HydrationLevel: Codable {
    let waterIntake: Double // liters
    let urineColor: Double // 1-8 scale (1=clear, 8=dark)
    let skinElasticity: Double // 0-1 scale
    
    var healthScore: Double {
        let waterScore = min(max(waterIntake / 3.0, 0), 1) // 3L ideal
        let urineScore = 1 - (urineColor - 1) / 7 // invert 1-8 to 0-1
        let skinScore = skinElasticity
        
        return (waterScore + urineScore + skinScore) / 3.0
    }
    
    var interpretation: String {
        switch healthScore {
        case 0.8...1.0: return "Excellent hydration"
        case 0.6..<0.8: return "Good hydration"
        case 0.4..<0.6: return "Moderate hydration"
        case 0.2..<0.4: return "Poor hydration"
        default: return "Very poor hydration"
        }
    }
}

// MARK: - Health Data Service
class HealthDataService: ObservableObject {
    @Published var currentHealthData: HealthData?
    @Published var isSyncing = false
    
    func syncHealthData() {
        isSyncing = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.currentHealthData = self.generateMockHealthData()
            self.isSyncing = false
        }
    }
    
    private func generateMockHealthData() -> HealthData {
        let now = Date()
        
        return HealthData(
            timestamp: now,
            heartRateVariability: HeartRateVariability(
                rmssd: Double.random(in: 20...60),
                sdnn: Double.random(in: 30...80),
                pnn50: Double.random(in: 5...25)
            ),
            sleepData: SleepData(
                totalSleepTime: TimeInterval.random(in: 6*3600...9*3600),
                deepSleepTime: TimeInterval.random(in: 1*3600...3*3600),
                remSleepTime: TimeInterval.random(in: 1*3600...2*3600),
                lightSleepTime: TimeInterval.random(in: 3*3600...5*3600),
                sleepEfficiency: Double.random(in: 75...95),
                sleepOnsetTime: TimeInterval.random(in: 5*60...45*60)
            ),
            activityData: ActivityData(
                steps: Int.random(in: 3000...15000),
                activeMinutes: Int.random(in: 30...180),
                caloriesBurned: Double.random(in: 1500...3000),
                exerciseMinutes: Int.random(in: 0...120),
                standingHours: Int.random(in: 6...16)
            ),
            stressLevel: StressLevel(
                perceivedStress: Double.random(in: 1...10),
                cortisolLevel: Double.random(in: 0.2...0.8),
                heartRateResting: Double.random(in: 50...80)
            ),
            hydrationLevel: HydrationLevel(
                waterIntake: Double.random(in: 1.5...4.0),
                urineColor: Double.random(in: 1...8),
                skinElasticity: Double.random(in: 0.3...1.0)
            )
        )
    }
}

