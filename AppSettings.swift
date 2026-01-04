import Foundation

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var inactivityThreshold: TimeInterval {
        didSet {
            UserDefaults.standard.set(inactivityThreshold, forKey: "inactivityThreshold")
        }
    }

    private init() {
        // 从 UserDefaults 加载，如果不存在则使用默认值
        let savedThreshold = UserDefaults.standard.double(forKey: "inactivityThreshold")
        self.inactivityThreshold = savedThreshold > 0 ? savedThreshold : 10.0
    }

    func getInactivityThresholdSeconds() -> Int {
        return Int(inactivityThreshold)
    }
}
