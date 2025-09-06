import SwiftUI

struct HealthDataCards: View {
    let healthData: HealthData
    
    var body: some View {
        VStack(spacing: 16) {
            // Overall Health Score
            OverallHealthCard(healthData: healthData)
            
            // Individual Health Metrics
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                HeartRateVariabilityCard(hrv: healthData.heartRateVariability)
                SleepDataCard(sleep: healthData.sleepData)
                ActivityDataCard(activity: healthData.activityData)
                StressLevelCard(stress: healthData.stressLevel)
                HydrationLevelCard(hydration: healthData.hydrationLevel)
            }
        }
    }
}

struct OverallHealthCard: View {
    let healthData: HealthData
    
    var body: some View {
        ERNCard {
            VStack(spacing: 12) {
                HStack {
                    ERNIconView(ERNIcon.heart, color: healthScoreColor, size: 24)
                    Text("Overall Health Score")
                        .ernHeadline()
                    Spacer()
                }
                
                HStack(alignment: .bottom, spacing: 8) {
                    Text("\(Int(healthData.overallHealthScore * 100))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(healthScoreColor)
                    
                    Text("/ 100")
                        .ernBody()
                        .foregroundColor(.ernTextSecondary)
                        .padding(.bottom, 8)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(healthScoreDescription)
                            .ernCaption()
                            .foregroundColor(healthScoreColor)
                        
                        Text("Last synced: \(healthData.timestamp.formatted(date: .omitted, time: .shortened))")
                            .ernCaption2()
                            .foregroundColor(.ernTextTertiary)
                    }
                }
            }
        }
    }
    
    private var healthScoreColor: Color {
        switch healthData.overallHealthScore {
        case 0.8...1.0: return .ernSuccess
        case 0.6..<0.8: return .ernAccent
        case 0.4..<0.6: return .ernWarning
        default: return .ernError
        }
    }
    
    private var healthScoreDescription: String {
        switch healthData.overallHealthScore {
        case 0.8...1.0: return "Excellent"
        case 0.6..<0.8: return "Good"
        case 0.4..<0.6: return "Fair"
        case 0.2..<0.4: return "Poor"
        default: return "Very Poor"
        }
    }
}

struct HeartRateVariabilityCard: View {
    let hrv: HeartRateVariability
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ERNIconView(ERNIcon.heart, color: .ernAccent, size: 20)
                    Text("Heart Rate Variability")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    Spacer()
                }
                
                Text("\(Int(hrv.healthScore * 100))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(hrvColor)
                
                Text(hrv.interpretation)
                    .ernCaption2()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("RMSSD: \(String(format: "%.1f", hrv.rmssd))ms")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                    Text("SDNN: \(String(format: "%.1f", hrv.sdnn))ms")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                }
            }
        }
    }
    
    private var hrvColor: Color {
        switch hrv.healthScore {
        case 0.8...1.0: return .ernSuccess
        case 0.6..<0.8: return .ernAccent
        case 0.4..<0.6: return .ernWarning
        default: return .ernError
        }
    }
}

struct SleepDataCard: View {
    let sleep: SleepData
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ERNIconView(ERNIcon.moon, color: .ernAccent, size: 20)
                    Text("Sleep Quality")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    Spacer()
                }
                
                Text("\(Int(sleep.healthScore * 100))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(sleepColor)
                
                Text(sleep.interpretation)
                    .ernCaption2()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(formatDuration(sleep.totalSleepTime)) total")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                    Text("\(Int(sleep.sleepEfficiency))% efficiency")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                }
            }
        }
    }
    
    private var sleepColor: Color {
        switch sleep.healthScore {
        case 0.8...1.0: return .ernSuccess
        case 0.6..<0.8: return .ernAccent
        case 0.4..<0.6: return .ernWarning
        default: return .ernError
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        return "\(hours)h \(minutes)m"
    }
}

struct ActivityDataCard: View {
    let activity: ActivityData
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ERNIconView(ERNIcon.activity, color: .ernAccent, size: 20)
                    Text("Activity Level")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    Spacer()
                }
                
                Text("\(Int(activity.healthScore * 100))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(activityColor)
                
                Text(activity.interpretation)
                    .ernCaption2()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(activity.steps) steps")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                    Text("\(activity.activeMinutes) active min")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                }
            }
        }
    }
    
    private var activityColor: Color {
        switch activity.healthScore {
        case 0.8...1.0: return .ernSuccess
        case 0.6..<0.8: return .ernAccent
        case 0.4..<0.6: return .ernWarning
        default: return .ernError
        }
    }
}

struct StressLevelCard: View {
    let stress: StressLevel
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ERNIconView(ERNIcon.brain, color: .ernAccent, size: 20)
                    Text("Stress Level")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    Spacer()
                }
                
                Text("\(Int(stress.healthScore * 100))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(stressColor)
                
                Text(stress.interpretation)
                    .ernCaption2()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Perceived: \(String(format: "%.1f", stress.perceivedStress))/10")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                    Text("HR: \(Int(stress.heartRateResting)) bpm")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                }
            }
        }
    }
    
    private var stressColor: Color {
        switch stress.healthScore {
        case 0.8...1.0: return .ernSuccess
        case 0.6..<0.8: return .ernAccent
        case 0.4..<0.6: return .ernWarning
        default: return .ernError
        }
    }
}

struct HydrationLevelCard: View {
    let hydration: HydrationLevel
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ERNIconView(ERNIcon.water, color: .ernAccent, size: 20)
                    Text("Hydration")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    Spacer()
                }
                
                Text("\(Int(hydration.healthScore * 100))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(hydrationColor)
                
                Text(hydration.interpretation)
                    .ernCaption2()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(String(format: "%.1f", hydration.waterIntake))L today")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                    Text("Color: \(Int(hydration.urineColor))/8")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                }
            }
        }
    }
    
    private var hydrationColor: Color {
        switch hydration.healthScore {
        case 0.8...1.0: return .ernSuccess
        case 0.6..<0.8: return .ernAccent
        case 0.4..<0.6: return .ernWarning
        default: return .ernError
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        HealthDataCards(healthData: HealthData(
            timestamp: Date(),
            heartRateVariability: HeartRateVariability(rmssd: 45, sdnn: 65, pnn50: 15),
            sleepData: SleepData(
                totalSleepTime: 7.5 * 3600,
                deepSleepTime: 2 * 3600,
                remSleepTime: 1.5 * 3600,
                lightSleepTime: 4 * 3600,
                sleepEfficiency: 85,
                sleepOnsetTime: 15 * 60
            ),
            activityData: ActivityData(
                steps: 8500,
                activeMinutes: 120,
                caloriesBurned: 2200,
                exerciseMinutes: 45,
                standingHours: 10
            ),
            stressLevel: StressLevel(
                perceivedStress: 4,
                cortisolLevel: 0.3,
                heartRateResting: 62
            ),
            hydrationLevel: HydrationLevel(
                waterIntake: 2.5,
                urineColor: 3,
                skinElasticity: 0.8
            )
        ))
    }
    .padding()
    .background(Color.ernBackground)
}

