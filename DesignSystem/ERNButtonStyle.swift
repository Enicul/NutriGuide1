import SwiftUI

struct ERNButtonStyle: ButtonStyle {
    enum Style {
        case primary
        case secondary
        case tertiary
    }
    
    let style: Style
    
    init(_ style: Style = .primary) {
        self.style = style
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .font(.system(.body, weight: .medium))
            .cornerRadius(12)
            .shadow(color: shadowColor, radius: configuration.isPressed ? 2 : 4, x: 0, y: configuration.isPressed ? 1 : 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .ernAccent
        case .secondary:
            return .ernCardBackground
        case .tertiary:
            return .clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .ernTextPrimary
        case .tertiary:
            return .ernAccent
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return .ernAccent.opacity(0.3)
        case .secondary:
            return .ernSurfaceShadow
        case .tertiary:
            return .clear
        }
    }
}

// MARK: - Convenience Extensions
extension Button {
    func ernPrimary() -> some View {
        self.buttonStyle(ERNButtonStyle(.primary))
    }
    
    func ernSecondary() -> some View {
        self.buttonStyle(ERNButtonStyle(.secondary))
    }
    
    func ernTertiary() -> some View {
        self.buttonStyle(ERNButtonStyle(.tertiary))
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Button("Primary Button") {
            // Action
        }
        .ernPrimary()
        
        Button("Secondary Button") {
            // Action
        }
        .ernSecondary()
        
        Button("Tertiary Button") {
            // Action
        }
        .ernTertiary()
    }
    .padding()
    .background(Color.ernBackground)
}
