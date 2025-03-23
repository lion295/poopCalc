import SwiftUI

struct EditVisitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storageManager: StorageManager
    let visit: ToiletVisit
    let costPerSecond: Double
    
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var cost: String
    
    init(storageManager: StorageManager, visit: ToiletVisit, costPerSecond: Double) {
        self.storageManager = storageManager
        self.visit = visit
        self.costPerSecond = costPerSecond
        _startDate = State(initialValue: visit.startDate)
        _endDate = State(initialValue: visit.endDate)
        _cost = State(initialValue: String(format: "%.2f", visit.cost))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Время посещения")) {
                    DatePicker("Начало", selection: $startDate)
                        .onChange(of: startDate) { oldValue, newValue in
                            updateCost()
                        }
                    DatePicker("Конец", selection: $endDate)
                        .onChange(of: endDate) { oldValue, newValue in
                            updateCost()
                        }
                }
                
                Section(header: Text("Стоимость")) {
                    TextField("Стоимость", text: $cost)
                        .keyboardType(.decimalPad)
                        .disabled(true)
                }
                
                Section {
                    Button("Сохранить") {
                        let newVisit = ToiletVisit(startDate: startDate, endDate: endDate, cost: Double(cost) ?? 0)
                        storageManager.updateVisit(visit, with: newVisit)
                        dismiss()
                    }
                    .disabled(startDate >= endDate)
                }
            }
            .navigationTitle("Редактировать запись")
            .navigationBarItems(trailing: Button("Отмена") {
                dismiss()
            })
        }
    }
    
    private func updateCost() {
        let duration = endDate.timeIntervalSince(startDate)
        let newCost = duration * costPerSecond
        cost = String(format: "%.2f", newCost)
    }
}

#Preview {
    EditVisitView(storageManager: StorageManager(), visit: ToiletVisit(startDate: Date(), endDate: Date().addingTimeInterval(300), cost: 100), costPerSecond: 0.1)
} 