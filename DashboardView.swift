import SwiftUI

// MARK: - Data Models
struct AppUsage: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let time: String
    let percent: Int
    let color: Color
    let icon: String
    var barWidth: Double {
        Double(percent) / 100.0
    }
}

struct InsightStat: Identifiable {
    let id = UUID()
    let value: String
    let description: String
    let iconColor: Color
    let bgColor: Color
}

// MARK: - Theme
struct DarkTheme {
    static let bg         = Color(hex: "#0a0a0a")
    static let surface    = Color(hex: "#111111")
    static let elevated   = Color(hex: "#161616")
    static let border     = Color(hex: "#1e1e1e")
    static let dimText    = Color(hex: "#444444")
    static let mutedText  = Color(hex: "#888888")
    static let bodyText   = Color(hex: "#e0e0e0")
    static let accent     = Color(hex: "#5DCAA5")
    static let purple     = Color(hex: "#AFA9EC")
    static let amber      = Color(hex: "#EF9F27")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Main View
struct DashboardView: View {
    @StateObject var viewModel = UsageViewModel()

    let stats = [
        ("18", "Sessions"),
        ("4",  "Apps"),
        ("14m","Avg")
    ]

    var body: some View {
        ZStack {
            DarkTheme.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                    heroCard
                    appSection
                    insightSection
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 40)
            }
            .refreshable {
                viewModel.loadData()
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Top Bar
    var topBar: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("FRIDAY, 2 MAY")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(DarkTheme.dimText)
                    .tracking(1.4)

                Text("Screen\nTime")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(.white)
                    .kerning(-1.2)
                    .lineSpacing(-4)
            }

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(DarkTheme.elevated)
                    .frame(width: 42, height: 42)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DarkTheme.border, lineWidth: 1)
                    )
                Image(systemName: "bell")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DarkTheme.dimText)
            }
            .padding(.top, 6)
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Hero Card
    var heroCard: some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(DarkTheme.purple.opacity(0.07))
                .frame(width: 150, height: 150)
                .offset(x: 30, y: -30)

            VStack(alignment: .leading, spacing: 0) {
                Text("TODAY'S TOTAL")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(DarkTheme.dimText)
                    .tracking(1.2)

                Text(viewModel.totalTime)
                    .font(.system(size: 62, weight: .heavy))
                    .foregroundColor(.white)
                    .kerning(-3)
                    .padding(.top, 4)
                    .scaleEffect(1.0)
                    .animation(.spring(), value: viewModel.totalTime)

                HStack(spacing: 8) {
                    Text("↑ 12 MIN")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(DarkTheme.bg)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(DarkTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    Text("vs yesterday")
                        .font(.system(size: 12))
                        .foregroundColor(DarkTheme.dimText)
                }

                HStack(spacing: 8) {
                    ForEach(stats, id: \.0) { stat in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(stat.0)
                                .font(.system(size: 18, weight: .heavy))
                                .foregroundColor(.white)
                            Text(stat.1.uppercased())
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(DarkTheme.dimText)
                                .tracking(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(DarkTheme.elevated)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(DarkTheme.border, lineWidth: 1)
                        )
                    }
                }
                .padding(.top, 16)
            }
            .padding(20)
        }
        .background(DarkTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(DarkTheme.border, lineWidth: 1)
        )
    }

    // MARK: - Apps Section
    var appSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("TOP APPS")

            VStack(spacing: 0) {
                if viewModel.apps.isEmpty {
                    Text("No data available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.apps) { app in
                        AppRowView(app: app)
                    }
                }
            }
            .padding(.horizontal, 16)
            .background(DarkTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(DarkTheme.border, lineWidth: 1)
            )
        }
    }

    // MARK: - Insights
    var insightSection: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.insights, id: \.self) { insight in
                    Text("• \(insight)")
                        .font(.system(size: 13))
                        .foregroundColor(DarkTheme.mutedText)
                }
            }
            .padding(14)
            .background(DarkTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(DarkTheme.border, lineWidth: 1)
            )
            .padding(.top, 8)

            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(DarkTheme.elevated)
                        .frame(width: 38, height: 38)
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(DarkTheme.amber)
                }

                (Text("18 min under your goal")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                + Text(" — on a 4-day streak of hitting targets.")
                    .font(.system(size: 13))
                    .foregroundColor(DarkTheme.mutedText))
            }
            .padding(14)
            .background(DarkTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(DarkTheme.border, lineWidth: 1)
            )
            .padding(.top, 8)
        }
    }

    func insightTile(value: String, desc: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(color.opacity(0.1))
                    .frame(width: 28, height: 28)
                Circle().fill(color).frame(width: 7, height: 7)
            }
            Text(value)
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.white)
                .kerning(-0.8)
            Text(desc)
                .font(.system(size: 11))
                .foregroundColor(DarkTheme.dimText)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(DarkTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(DarkTheme.border, lineWidth: 1)
        )
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(DarkTheme.dimText)
            .tracking(1.2)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
}
