import SwiftUI

struct WorkoutCardComponent: View {
    let item: WorkoutItem
    
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            // action
        } label: {
            HStack(spacing: 12) {
                
                // Left content
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(item.videos) videos")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    VStack(spacing: 16) {
        WorkoutCardComponent(item: .init(title: "Today", videos: 7))
        WorkoutCardComponent(item: .init(title: "Sunday", videos: 4))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
