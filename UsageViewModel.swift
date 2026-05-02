import SwiftUI

class UsageViewModel: ObservableObject {

    @Published var apps: [AppUsage] = []
    @Published var insights: [String] = []
    @Published var totalTime: String = ""

    init() {
        loadData()
    }

    func loadData() {
        totalTime = "3:45"
        apps = [
            AppUsage(name: "Instagram", category: "Social",    time: "1:20", percent: 36, color: Color(hex: "#833AB4"), icon: "camera.fill"),
            AppUsage(name: "Spotify",   category: "Music",     time: "0:58", percent: 26, color: Color(hex: "#1DB954"), icon: "music.note"),
            AppUsage(name: "WhatsApp",  category: "Messaging", time: "0:47", percent: 21, color: Color(hex: "#25D366"), icon: "message.fill")
            
        ]
        generateInsights()
    }

    func generateInsights() {
        guard !apps.isEmpty else { return }

        var result: [String] = []

        if let top = apps.max(by: { $0.percent < $1.percent }) {
            result.append("You spend most time on \(top.name)")
        }

        let socialUsage = apps
            .filter { $0.category.lowercased() == "social" }
            .reduce(0) { $0 + $1.percent }

        if socialUsage > 50 {
            result.append("Social apps dominate your usage")
        }

        if let least = apps.min(by: { $0.percent < $1.percent }) {
            result.append("You spend least time on \(least.name)")
        }

        insights = result
    }
}
