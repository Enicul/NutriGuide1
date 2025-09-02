import SwiftUI

extension Text {
    // MARK: - Title Styles
    func ernTitle() -> some View {
        self
            .font(.system(.title, design: .rounded, weight: .bold))
            .foregroundColor(.ernTextPrimary)
    }
    
    func ernTitle2() -> some View {
        self
            .font(.system(.title2, design: .rounded, weight: .semibold))
            .foregroundColor(.ernTextPrimary)
    }
    
    func ernTitle3() -> some View {
        self
            .font(.system(.title3, design: .rounded, weight: .medium))
            .foregroundColor(.ernTextPrimary)
    }
    
    // MARK: - Body Styles
    func ernBody() -> some View {
        self
            .font(.system(.body, design: .default, weight: .regular))
            .foregroundColor(.ernTextPrimary)
    }
    
    func ernBodyEmphasized() -> some View {
        self
            .font(.system(.body, design: .default, weight: .medium))
            .foregroundColor(.ernTextPrimary)
    }
    
    // MARK: - Caption Styles
    func ernCaption() -> some View {
        self
            .font(.system(.caption, design: .default, weight: .regular))
            .foregroundColor(.ernTextSecondary)
    }
    
    func ernCaption2() -> some View {
        self
            .font(.system(.caption2, design: .default, weight: .regular))
            .foregroundColor(.ernTextTertiary)
    }
    
    // MARK: - Footnote Styles
    func ernFootnote() -> some View {
        self
            .font(.system(.footnote, design: .default, weight: .regular))
            .foregroundColor(.ernTextSecondary)
    }
    
    func ernFootnoteEmphasized() -> some View {
        self
            .font(.system(.footnote, design: .default, weight: .medium))
            .foregroundColor(.ernTextSecondary)
    }
    
    // MARK: - Headline Styles
    func ernHeadline() -> some View {
        self
            .font(.system(.headline, design: .rounded, weight: .semibold))
            .foregroundColor(.ernTextPrimary)
    }
    
    func ernSubheadline() -> some View {
        self
            .font(.system(.subheadline, design: .default, weight: .medium))
            .foregroundColor(.ernTextSecondary)
    }
}
