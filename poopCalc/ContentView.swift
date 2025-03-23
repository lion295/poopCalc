//
//  ContentView.swift
//  poopCalc
//
//  Created by Леон Пугачев on 22.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var storageManager = StorageManager()
    @State private var monthlyHours: String = ""
    @State private var monthlySalary: String = ""
    @State private var isTimerRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showingSettings = false
    @State private var showingHistory = false
    @State private var startDate: Date?
    
    private var costPerSecond: Double {
        guard let hours = Double(monthlyHours),
              let salary = Double(monthlySalary),
              hours > 0 else { return 0 }
        return salary / (hours * 3600)
    }
    
    private var currentCost: Double {
        return elapsedTime * costPerSecond
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    showingHistory = true
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.orange)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.trailing)
            }
            
            Text("Калькулятор стоимости туалета")
                .font(.title)
                .padding()
            
            Text("Проведено времени: \(formatTime(elapsedTime))")
                .font(.title2)
            
            Text("Стоимость за текущее посещение: \(String(format: "%.2f ₽", currentCost))")
                .font(.title2)
            
            Text("Общая стоимость: \(String(format: "%.2f ₽", storageManager.totalCost))")
                .font(.title2)
                .foregroundColor(.blue)
            
            Button(action: {
                if isTimerRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            }) {
                Text(isTimerRunning ? "Стоп" : "Старт")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isTimerRunning ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(monthlyHours: $monthlyHours, monthlySalary: $monthlySalary, storageManager: storageManager)
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView(storageManager: storageManager, monthlyHours: monthlyHours, monthlySalary: monthlySalary)
        }
        .onAppear {
            // Проверяем, есть ли активный таймер при запуске приложения
            if let startDate = storageManager.getActiveTimerStart() {
                self.startDate = startDate
                isTimerRunning = true
                updateElapsedTime()
                startTimer()
            }
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        startDate = Date()
        storageManager.saveActiveTimerStart(startDate!)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateElapsedTime()
        }
    }
    
    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        
        if let start = startDate {
            let visit = ToiletVisit(startDate: start, endDate: Date(), cost: currentCost)
            storageManager.addVisit(visit)
            storageManager.clearActiveTimerStart()
            startDate = nil
        }
        
        elapsedTime = 0
    }
    
    private func updateElapsedTime() {
        if let start = startDate {
            elapsedTime = Date().timeIntervalSince(start)
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    ContentView()
}
