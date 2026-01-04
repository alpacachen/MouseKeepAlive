import Foundation

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var inactivityThreshold: TimeInterval {
        didSet {
            UserDefaults.standard.set(inactivityThreshold, forKey: "inactivityThreshold")
        }
    }

    @Published var moveRange: Int {
        didSet {
            UserDefaults.standard.set(moveRange, forKey: "moveRange")
        }
    }

    private init() {
        // 从 UserDefaults 加载，如果不存在则使用默认值
        let savedThreshold = UserDefaults.standard.double(forKey: "inactivityThreshold")
        self.inactivityThreshold = savedThreshold > 0 ? savedThreshold : 10.0

        let savedRange = UserDefaults.standard.integer(forKey: "moveRange")
        self.moveRange = savedRange > 0 ? savedRange : 20
    }

    func getInactivityThresholdSeconds() -> Int {
        return Int(inactivityThreshold)
    }

    func getMoveRangeDescription() -> String {
        return "±\(moveRange)像素"
    }
}
