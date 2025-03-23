import SwiftUI

// Представление для редактирования записи о посещении туалета
struct EditVisitView: View {
    // Переменная для закрытия текущего экрана
    @Environment(\.dismiss) var dismiss
    // Менеджер для работы с данными (сохранение, загрузка, обновление)
    @ObservedObject var storageManager: StorageManager
    // Запись, которую мы редактируем
    let visit: ToiletVisit
    // Стоимость одной секунды (зарплата в месяц / (часы в месяц * 3600))
    let costPerSecond: Double
    
    // Состояние для хранения даты начала посещения
    @State private var startDate: Date
    // Состояние для хранения даты окончания посещения
    @State private var endDate: Date
    // Состояние для хранения стоимости в виде строки
    @State private var cost: String
    
    // Инициализатор - вызывается при создании экрана
    init(storageManager: StorageManager, visit: ToiletVisit, costPerSecond: Double) {
        self.storageManager = storageManager
        self.visit = visit
        self.costPerSecond = costPerSecond
        // Инициализируем начальные значения для состояний
        _startDate = State(initialValue: visit.startDate)
        _endDate = State(initialValue: visit.endDate)
        _cost = State(initialValue: String(format: "%.2f", visit.cost))
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Секция с выбором времени
                Section(header: Text("Время посещения")) {
                    // Выбор даты и времени начала
                    DatePicker("Начало", selection: $startDate)
                        // При изменении даты начала пересчитываем стоимость
                        .onChange(of: startDate) { oldValue, newValue in
                            updateCost()
                        }
                    // Выбор даты и времени окончания
                    DatePicker("Конец", selection: $endDate)
                        // При изменении даты окончания пересчитываем стоимость
                        .onChange(of: endDate) { oldValue, newValue in
                            updateCost()
                        }
                }
                
                // Секция с отображением стоимости
                Section(header: Text("Стоимость")) {
                    // Поле для отображения стоимости (нельзя редактировать)
                    TextField("Стоимость", text: $cost)
                        .keyboardType(.decimalPad)
                        .disabled(true)
                }
                
                // Секция с кнопкой сохранения
                Section {
                    Button("Сохранить") {
                        // Создаем новую запись с обновленными данными
                        let newVisit = ToiletVisit(startDate: startDate, endDate: endDate, cost: Double(cost) ?? 0)
                        // Обновляем запись в хранилище
                        storageManager.updateVisit(visit, with: newVisit)
                        // Закрываем экран редактирования
                        dismiss()
                    }
                    // Кнопка неактивна, если время окончания раньше времени начала
                    .disabled(startDate >= endDate)
                }
            }
            .navigationTitle("Редактировать запись")
            // Кнопка отмены в правом верхнем углу
            .navigationBarItems(trailing: Button("Отмена") {
                dismiss()
            })
        }
    }
    
    // Функция для пересчета стоимости
    private func updateCost() {
        // Вычисляем длительность в секундах
        let duration = endDate.timeIntervalSince(startDate)
        // Вычисляем стоимость (длительность * стоимость в секунду)
        let newCost = duration * costPerSecond
        // Обновляем отображение стоимости с двумя знаками после запятой
        cost = String(format: "%.2f", newCost)
    }
}

// Предварительный просмотр для разработки
#Preview {
    EditVisitView(storageManager: StorageManager(), visit: ToiletVisit(startDate: Date(), endDate: Date().addingTimeInterval(300), cost: 100), costPerSecond: 0.1)
} 