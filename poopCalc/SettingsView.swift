import SwiftUI

struct SettingsView: View {
    @Binding var monthlyHours: String
    @Binding var monthlySalary: String
    @ObservedObject var storageManager: StorageManager
    @Environment(\.dismiss) var dismiss
    @State private var showingResetConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Настройки")) {
                    TextField("Часов в месяц", text: $monthlyHours)
                        .keyboardType(.numberPad)
                    
                    TextField("Зарплата в месяц", text: $monthlySalary)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(role: .destructive, action: {
                        showingResetConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Сбросить все данные")
                        }
                    }
                }
                
                Section(header: Text("О разработчике")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Версия: 1.0.0")
                            .font(.subheadline)
                        
                        Text("Разработчик: Леон Пугачев")
                            .font(.subheadline)
                        
                        Text("© 2025 Все права защищены")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Настройки")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
            .alert("Подтверждение сброса", isPresented: $showingResetConfirmation) {
                Button("Отмена", role: .cancel) { }
                Button("Сбросить", role: .destructive) {
                    storageManager.resetAllData()
                }
            } message: {
                Text("Вы уверены, что хотите удалить всю историю посещений? Это действие нельзя отменить.")
            }
        }
    }
}

#Preview {
    SettingsView(monthlyHours: .constant(""), monthlySalary: .constant(""), storageManager: StorageManager())
} 