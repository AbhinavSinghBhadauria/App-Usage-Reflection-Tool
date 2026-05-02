import SwiftUI

struct AppRowView: View {
    let app: AppUsage

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 6) {

            HStack(spacing: 12) {

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(app.color.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: app.icon)
                        .foregroundColor(app.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(app.name)
                        .font(.system(size: 14, weight: .semibold))

                    Text(app.category.uppercased())
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(app.time)
                        .fontWeight(.bold)

                    Text("\(app.percent)%")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.2))

                    Capsule()
                        .fill(app.color)
                        .frame(width: geo.size.width * app.barWidth)
                        .animation(.easeInOut(duration: 1), value: app.barWidth)
                }
            }
            .frame(height: 4)
        }
        .padding(.vertical, 10)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                isVisible = true
            }
        }
    }
}
