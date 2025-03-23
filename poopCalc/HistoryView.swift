import SwiftUI

struct HistoryView: View {
    @ObservedObject var storageManager: StorageManager
    @State private var selectedVisit: ToiletVisit?
    @State private var showingEditSheet = false
    let monthlyHours: String
    let monthlySalary: String
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var costPerSecond: Double {
        guard let hours = Double(monthlyHours),
              let salary = Double(monthlySalary),
              hours > 0 else { return 0 }
        return salary / (hours * 3600)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(storageManager.visits.sorted(by: { $0.startDate > $1.startDate })) { visit in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(dateFormatter.string(from: visit.startDate))
                            .font(.headline)
                        
                        HStack {
                            Text("Длительность:")
                            Text(formatDuration(from: visit.startDate, to: visit.endDate))
                        }
                        .font(.subheadline)
                        
                        Text("Стоимость: \(String(format: "%.2f ₽", visit.cost))")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedVisit = visit
                        showingEditSheet = true
                    }
                }
                .onDelete { indexSet in
                    let sortedVisits = storageManager.visits.sorted(by: { $0.startDate > $1.startDate })
                    indexSet.forEach { index in
                        if let visitToDelete = sortedVisits[safe: index] {
                            storageManager.deleteVisit(visitToDelete)
                        }
                    }
                }
            }
            .navigationTitle("История посещений")
            .sheet(isPresented: $showingEditSheet) {
                if let visit = selectedVisit {
                    EditVisitView(storageManager: storageManager, visit: visit, costPerSecond: costPerSecond)
                }
            }
        }
    }
    
    private func formatDuration(from start: Date, to end: Date) -> String {
        let duration = end.timeIntervalSince(start)
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    HistoryView(storageManager: StorageManager(), monthlyHours: "160", monthlySalary: "50000")
} 