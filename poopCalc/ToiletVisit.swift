import Foundation

// Модель данных для хранения информации о посещении туалета
struct ToiletVisit: Codable, Identifiable {
    // Уникальный идентификатор записи
    let id: UUID
    // Дата и время начала посещения
    let startDate: Date
    // Дата и время окончания посещения
    let endDate: Date
    // Стоимость посещения в рублях
    let cost: Double
    
    // Инициализатор для создания новой записи
    init(startDate: Date, endDate: Date, cost: Double) {
        // Генерируем новый уникальный идентификатор
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
        self.cost = cost
    }
} 