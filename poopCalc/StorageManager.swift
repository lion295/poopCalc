import Foundation

// Класс для управления хранением данных о посещениях
class StorageManager: ObservableObject {
    // Массив всех посещений
    @Published var visits: [ToiletVisit] = []
    // Ключ для сохранения данных в UserDefaults
    private let visitsKey = "toiletVisits"
    // Ключ для сохранения времени начала активного таймера
    private let activeTimerKey = "activeTimerStart"
    
    // Инициализатор - загружает сохраненные данные при создании
    init() {
        loadVisits()
    }
    
    // Сохранение времени начала активного таймера
    func saveActiveTimerStart(_ date: Date) {
        UserDefaults.standard.set(date, forKey: activeTimerKey)
    }
    
    // Получение времени начала активного таймера
    func getActiveTimerStart() -> Date? {
        return UserDefaults.standard.object(forKey: activeTimerKey) as? Date
    }
    
    // Очистка времени начала активного таймера
    func clearActiveTimerStart() {
        UserDefaults.standard.removeObject(forKey: activeTimerKey)
    }
    
    // Добавление нового посещения
    func addVisit(_ visit: ToiletVisit) {
        visits.append(visit)
        saveVisits()
    }
    
    // Обновление существующего посещения
    func updateVisit(_ visit: ToiletVisit, with newVisit: ToiletVisit) {
        // Находим индекс существующей записи по ID
        if let index = visits.firstIndex(where: { $0.id == visit.id }) {
            // Заменяем старую запись на новую
            visits[index] = newVisit
            // Сохраняем изменения
            saveVisits()
        }
    }
    
    // Удаление посещения
    func deleteVisit(_ visit: ToiletVisit) {
        // Удаляем запись по ID
        visits.removeAll { $0.id == visit.id }
        // Сохраняем изменения
        saveVisits()
    }
    
    // Сброс всех данных
    func resetAllData() {
        visits = []
        clearActiveTimerStart()
        saveVisits()
    }
    
    // Вычисление общей стоимости всех посещений
    var totalCost: Double {
        visits.reduce(0) { $0 + $1.cost }
    }
    
    // Сохранение данных в UserDefaults
    private func saveVisits() {
        // Преобразуем массив в JSON
        if let encoded = try? JSONEncoder().encode(visits) {
            // Сохраняем JSON в UserDefaults
            UserDefaults.standard.set(encoded, forKey: visitsKey)
        }
    }
    
    // Загрузка данных из UserDefaults
    private func loadVisits() {
        // Получаем сохраненные данные
        if let data = UserDefaults.standard.data(forKey: visitsKey),
           // Преобразуем JSON обратно в массив
           let decoded = try? JSONDecoder().decode([ToiletVisit].self, from: data) {
            visits = decoded
        }
    }
} 