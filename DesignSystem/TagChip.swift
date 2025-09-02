import SwiftUI

struct TagChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.callout.weight(.semibold))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.accentColor.opacity(0.2) : Color.ernBackground)
                .foregroundStyle(isSelected ? Color.accentColor : Color.ernTextPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isSelected ? Color.accentColor : Color.ernTextSecondary.opacity(0.25),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        TagChip(text: "Vegan", isSelected: false) { }
        TagChip(text: "Dairy-free", isSelected: true) { }
        TagChip(text: "Gluten-free", isSelected: false) { }
    }
    .padding()
}
