import Foundation

class StorageManager: ObservableObject {
    @Published var visits: [ToiletVisit] = []
    private let visitsKey = "toiletVisits"
    
    init() {
        loadVisits()
    }
    
    func addVisit(_ visit: ToiletVisit) {
        visits.append(visit)
        saveVisits()
    }
    
    func updateVisit(_ visit: ToiletVisit, with newVisit: ToiletVisit) {
        if let index = visits.firstIndex(where: { $0.id == visit.id }) {
            visits[index] = newVisit
            saveVisits()
        }
    }
    
    func deleteVisit(_ visit: ToiletVisit) {
        visits.removeAll { $0.id == visit.id }
        saveVisits()
    }
    
    func resetAllData() {
        visits = []
        saveVisits()
    }
    
    var totalCost: Double {
        visits.reduce(0) { $0 + $1.cost }
    }
    
    private func saveVisits() {
        if let encoded = try? JSONEncoder().encode(visits) {
            UserDefaults.standard.set(encoded, forKey: visitsKey)
        }
    }
    
    private func loadVisits() {
        if let data = UserDefaults.standard.data(forKey: visitsKey),
           let decoded = try? JSONDecoder().decode([ToiletVisit].self, from: data) {
            visits = decoded
        }
    }
} 