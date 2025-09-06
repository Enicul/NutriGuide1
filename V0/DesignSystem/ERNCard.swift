import SwiftUI

struct ERNCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color.ernCardBackground)
            .cornerRadius(20)
            .shadow(color: .ernSurfaceShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sample Card")
                    .ernTitle3()
                Text("This is a sample card content")
                    .ernBody()
            }
        }
        
        ERNCard {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("Card with Icon")
                    .ernBodyEmphasized()
                Spacer()
            }
        }
    }
    .padding()
    .background(Color.ernBackground)
}
