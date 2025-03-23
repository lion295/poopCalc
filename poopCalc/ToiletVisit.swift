import Foundation

struct ToiletVisit: Codable, Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let cost: Double
    
    init(startDate: Date, endDate: Date, cost: Double) {
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
        self.cost = cost
    }
} 