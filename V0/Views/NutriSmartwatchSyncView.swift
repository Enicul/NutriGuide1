// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI
import HealthKit

// MARK: - Protocol Definition
protocol SmartwatchSyncViewModeling: ObservableObject {
    var connectionStatus: ConnectionStatus { get }
    var healthData: [HealthDataItem] { get }
    var syncHistory: [SyncEvent] { get }
    var issyncing: Bool { get }
    var permissionsGranted: Bool { get }
    var lastSyncTime: Date? { get }
    
    func requestHealthPermissions()
    func startSync()
    func stopSync()
    func clearData()
    func refreshData()
}

// MARK: - Supporting Types
enum ConnectionStatus {
    case disconnected
    case connecting
    case connected
    case error(String)
    
    var title: String {
        switch self {
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting..."
        case .connected: return "Connected"
        case .error: return "Connection Error"
        }
    }
    
    var color: Color {
        switch self {
        case .disconnected: return .textSecondary
        case .connecting: return .warning
        case .connected: return .success
        case .error: return .error
        }
    }
    
    var icon: String {
        switch self {
        case .disconnected: return "applewatch.slash"
        case .connecting: return "applewatch"
        case .connected: return "applewatch.radiowaves.left.and.right"
        case .error: return "exclamationmark.applewatch"
        }
    }
}

struct HealthDataItem {
    let id = UUID()
    let type: HealthDataType
    let value: String
    let unit: String
    let timestamp: Date
    let source: String
    
    enum HealthDataType: String, CaseIterable {
        case heartRate = "Heart Rate"
        case steps = "Steps"
        case activeCalories = "Active Calories"
        case restingHeartRate = "Resting Heart Rate"
        case heartRateVariability = "HRV"
        case bloodOxygen = "Blood Oxygen"
        case sleepAnalysis = "Sleep"
        case stressLevel = "Stress Level"
        case workoutTime = "Workout Time"
        
        var icon: String {
            switch self {
            case .heartRate, .restingHeartRate: return SystemIcon.heart
            case .steps: return SystemIcon.activity
            case .activeCalories: return "flame.fill"
            case .heartRateVariability: return "waveform.path.ecg"
            case .bloodOxygen: return "lungs.fill"
            case .sleepAnalysis: return SystemIcon.sleep
            case .stressLevel: return SystemIcon.stress
            case .workoutTime: return "figure.run"
            }
        }
        
        var color: Color {
            switch self {
            case .heartRate, .restingHeartRate: return .error
            case .steps: return .success
            case .activeCalories: return .warning
            case .heartRateVariability: return .accentPrimary
            case .bloodOxygen: return .info
            case .sleepAnalysis: return .stateSleepPrep
            case .stressLevel: return .stateStressed
            case .workoutTime: return .statePostWorkout
            }
        }
    }
}

struct SyncEvent {
    let id = UUID()
    let timestamp: Date
    let dataTypes: [HealthDataItem.HealthDataType]
    let status: SyncStatus
    let itemCount: Int
    
    enum SyncStatus {
        case success
        case partial
        case failed
        
        var title: String {
            switch self {
            case .success: return "Success"
            case .partial: return "Partial"
            case .failed: return "Failed"
            }
        }
        
        var color: Color {
            switch self {
            case .success: return .success
            case .partial: return .warning
            case .failed: return .error
            }
        }
        
        var icon: String {
            switch self {
            case .success: return SystemIcon.checkmark
            case .partial: return SystemIcon.warning
            case .failed: return SystemIcon.error
            }
        }
    }
}

// MARK: - Mock ViewModel
class MockSmartwatchSyncViewModel: SmartwatchSyncViewModeling {
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var healthData: [HealthDataItem] = []
    @Published var syncHistory: [SyncEvent] = []
    @Published var issyncing: Bool = false
    @Published var permissionsGranted: Bool = false
    @Published var lastSyncTime: Date? = nil
    
    var issyncing: Bool {
        get { issyncing }
        set { issyncing = newValue }
    }
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        healthData = [
            HealthDataItem(
                type: .heartRate,
                value: "72",
                unit: "bpm",
                timestamp: Date().addingTimeInterval(-300),
                source: "Apple Watch Series 9"
            ),
            HealthDataItem(
                type: .steps,
                value: "8,432",
                unit: "steps",
                timestamp: Date().addingTimeInterval(-600),
                source: "Apple Watch Series 9"
            ),
            HealthDataItem(
                type: .activeCalories,
                value: "324",
                unit: "cal",
                timestamp: Date().addingTimeInterval(-900),
                source: "Apple Watch Series 9"
            ),
            HealthDataItem(
                type: .restingHeartRate,
                value: "58",
                unit: "bpm",
                timestamp: Date().addingTimeInterval(-3600),
                source: "Apple Watch Series 9"
            ),
            HealthDataItem(
                type: .sleepAnalysis,
                value: "7h 32m",
                unit: "",
                timestamp: Date().addingTimeInterval(-28800),
                source: "Apple Watch Series 9"
            ),
            HealthDataItem(
                type: .stressLevel,
                value: "Low",
                unit: "",
                timestamp: Date().addingTimeInterval(-1200),
                source: "Apple Watch Series 9"
            )
        ]
        
        syncHistory = [
            SyncEvent(
                timestamp: Date().addingTimeInterval(-300),
                dataTypes: [.heartRate, .steps, .activeCalories],
                status: .success,
                itemCount: 15
            ),
            SyncEvent(
                timestamp: Date().addingTimeInterval(-3600),
                dataTypes: [.sleepAnalysis, .restingHeartRate],
                status: .success,
                itemCount: 8
            ),
            SyncEvent(
                timestamp: Date().addingTimeInterval(-7200),
                dataTypes: [.heartRate, .steps],
                status: .partial,
                itemCount: 3
            )
        ]
        
        lastSyncTime = Date().addingTimeInterval(-300)
    }
    
    func requestHealthPermissions() {
        permissionsGranted = true
        connectionStatus = .connected
    }
    
    func startSync() {
        guard permissionsGranted else {
            connectionStatus = .error("Health permissions required")
            return
        }
        
        issyncing = true
        connectionStatus = .connecting
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.issyncing = false
            self.connectionStatus = .connected
            self.lastSyncTime = Date()
            
            // Add new sync event
            let newEvent = SyncEvent(
                timestamp: Date(),
                dataTypes: [.heartRate, .steps, .activeCalories, .stressLevel],
                status: .success,
                itemCount: 12
            )
            self.syncHistory.insert(newEvent, at: 0)
        }
    }
    
    func stopSync() {
        issyncing = false
        connectionStatus = .disconnected
    }
    
    func clearData() {
        healthData.removeAll()
        syncHistory.removeAll()
        lastSyncTime = nil
    }
    
    func refreshData() {
        loadMockData()
    }
}

// MARK: - Main Sync View
struct NutriSmartwatchSyncView<ViewModel: SmartwatchSyncViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    @State private var showingPermissionAlert = false
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Connection Status Card
                    ConnectionStatusCard(
                        status: viewModel.connectionStatus,
                        issyncing: viewModel.issyncing,
                        lastSyncTime: viewModel.lastSyncTime,
                        onConnect: handleConnection,
                        onSync: viewModel.startSync,
                        onDisconnect: viewModel.stopSync
                    )
                    .padding(.horizontal)
                    
                    // Permissions Section
                    if !viewModel.permissionsGranted {
                        PermissionsCard(
                            onRequestPermissions: viewModel.requestHealthPermissions
                        )
                        .padding(.horizontal)
                    }
                    
                    // Health Data Overview
                    if !viewModel.healthData.isEmpty {
                        HealthDataOverviewSection(
                            healthData: viewModel.healthData,
                            onRefresh: viewModel.refreshData
                        )
                        .padding(.horizontal)
                    }
                    
                    // Sync History
                    if !viewModel.syncHistory.isEmpty {
                        SyncHistorySection(
                            syncHistory: viewModel.syncHistory,
                            onClearHistory: viewModel.clearData
                        )
                        .padding(.horizontal)
                    }
                    
                    // Help Section
                    HelpSection()
                        .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Apple Watch Sync")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                viewModel.refreshData()
            }
        }
        .alert("Health Permissions Required", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                // Open Settings app
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please grant health data access in Settings to sync with your Apple Watch.")
        }
    }
    
    private func handleConnection() {
        if viewModel.permissionsGranted {
            viewModel.startSync()
        } else {
            showingPermissionAlert = true
        }
    }
}

// MARK: - Connection Status Card
struct ConnectionStatusCard: View {
    let status: ConnectionStatus
    let issyncing: Bool
    let lastSyncTime: Date?
    let onConnect: () -> Void
    let onSync: () -> Void
    let onDisconnect: () -> Void
    
    var body: some View {
        NutriCard(shadowLevel: 2) {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Apple Watch")
                            .caption()
                            .foregroundColor(.textSecondary)
                        
                        Text(status.title)
                            .title2()
                            .foregroundColor(status.color)
                    }
                    
                    Spacer()
                    
                    if issyncing {
                        ProgressView()
                            .scaleEffect(1.2)
                    } else {
                        Image(systemName: status.icon)
                            .font(.largeTitle)
                            .foregroundColor(status.color)
                    }
                }
                
                if let lastSync = lastSyncTime {
                    HStack {
                        Image(systemName: SystemIcon.clock)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("Last sync: \(lastSync, formatter: syncTimeFormatter)")
                            .caption()
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                }
                
                HStack(spacing: 12) {
                    switch status {
                    case .disconnected, .error:
                        Button("Connect") {
                            onConnect()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(issyncing)
                        
                    case .connecting:
                        Button("Connecting...") {}
                            .buttonStyle(SecondaryButtonStyle())
                            .disabled(true)
                        
                    case .connected:
                        Button("Sync Now") {
                            onSync()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(issyncing)
                        
                        Button("Disconnect") {
                            onDisconnect()
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .disabled(issyncing)
                    }
                }
            }
            .padding(20)
        }
        .accessibility(label: Text("Apple Watch connection status: \(status.title)"))
    }
}

// MARK: - Permissions Card
struct PermissionsCard: View {
    let onRequestPermissions: () -> Void
    
    var body: some View {
        NutriCard(backgroundColor: .warning.opacity(0.1)) {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: SystemIcon.warning)
                        .font(.title2)
                        .foregroundColor(.warning)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Health Access Required")
                            .headline()
                            .foregroundColor(.textPrimary)
                        
                        Text("Grant permission to sync health data from your Apple Watch")
                            .body()
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Button("Grant Permissions") {
                    onRequestPermissions()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(20)
        }
        .accessibility(label: Text("Health permissions required"))
        .accessibility(hint: Text("Tap to grant health data access"))
    }
}

// MARK: - Health Data Overview
struct HealthDataOverviewSection: View {
    let healthData: [HealthDataItem]
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Health Data")
                    .headline()
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: onRefresh) {
                    Image(systemName: SystemIcon.refresh)
                        .font(.title3)
                        .foregroundColor(.accentPrimary)
                }
                .accessibility(label: Text("Refresh health data"))
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(healthData) { dataItem in
                    HealthDataItemCard(dataItem: dataItem)
                }
            }
        }
    }
}

struct HealthDataItemCard: View {
    let dataItem: HealthDataItem
    
    var body: some View {
        NutriCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: dataItem.type.icon)
                        .font(.title3)
                        .foregroundColor(dataItem.type.color)
                    
                    Spacer()
                    
                    Text(timeAgo(from: dataItem.timestamp))
                        .caption2()
                        .foregroundColor(.textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(dataItem.value)
                            .headline()
                            .foregroundColor(.textPrimary)
                        
                        if !dataItem.unit.isEmpty {
                            Text(dataItem.unit)
                                .caption()
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                    }
                    
                    Text(dataItem.type.rawValue)
                        .caption()
                        .foregroundColor(.textSecondary)
                }
                
                Text(dataItem.source)
                    .caption2()
                    .foregroundColor(.textTertiary)
                    .lineLimit(1)
            }
            .padding(16)
        }
        .accessibility(label: Text("\(dataItem.type.rawValue): \(dataItem.value) \(dataItem.unit)"))
    }
}

// MARK: - Sync History Section
struct SyncHistorySection: View {
    let syncHistory: [SyncEvent]
    let onClearHistory: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sync History")
                    .headline()
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Menu {
                    Button("Clear History", role: .destructive) {
                        onClearHistory()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(.accentPrimary)
                }
                .accessibility(label: Text("Sync history options"))
            }
            
            VStack(spacing: 12) {
                ForEach(syncHistory) { event in
                    SyncEventCard(event: event)
                }
            }
        }
    }
}

struct SyncEventCard: View {
    let event: SyncEvent
    
    var body: some View {
        NutriCard {
            HStack(spacing: 16) {
                Image(systemName: event.status.icon)
                    .font(.title3)
                    .foregroundColor(event.status.color)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(event.status.title)
                            .headline()
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Text("\(event.itemCount) items")
                            .caption()
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text(event.timestamp, formatter: syncTimeFormatter)
                        .caption()
                        .foregroundColor(.textSecondary)
                    
                    HStack {
                        ForEach(Array(event.dataTypes.prefix(3)), id: \.self) { type in
                            Text(type.rawValue)
                                .caption2()
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(4)
                        }
                        
                        if event.dataTypes.count > 3 {
                            Text("+\(event.dataTypes.count - 3)")
                                .caption2()
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
            .padding(16)
        }
        .accessibility(label: Text("Sync \(event.status.title) at \(event.timestamp, formatter: syncTimeFormatter)"))
    }
}

// MARK: - Help Section
struct HelpSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Help & Tips")
                .headline()
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                HelpTipCard(
                    icon: SystemIcon.info,
                    title: "Automatic Sync",
                    description: "Health data syncs automatically when your Apple Watch is nearby and connected."
                )
                
                HelpTipCard(
                    icon: "battery.25",
                    title: "Battery Optimization",
                    description: "Sync frequency adjusts based on your Apple Watch battery level."
                )
                
                HelpTipCard(
                    icon: SystemIcon.settings,
                    title: "Privacy",
                    description: "Your health data is processed locally and never shared without permission."
                )
            }
        }
    }
}

struct HelpTipCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentPrimary)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .headline()
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .body()
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Helper Functions
private let syncTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

private func timeAgo(from date: Date) -> String {
    let interval = Date().timeIntervalSince(date)
    
    if interval < 60 {
        return "Just now"
    } else if interval < 3600 {
        return "\(Int(interval / 60))m ago"
    } else if interval < 86400 {
        return "\(Int(interval / 3600))h ago"
    } else {
        return "\(Int(interval / 86400))d ago"
    }
}

// MARK: - Preview
struct NutriSmartwatchSyncView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            NutriSmartwatchSyncView(viewModel: MockSmartwatchSyncViewModel())
        }
        .previewDevice("iPhone 15 Pro")
    }
}
