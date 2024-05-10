//
//  ContentView.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 25/3/2567 BE.
//

import SwiftUI
import CoreData
import Foundation
import Combine

// Define your DailyData structure
struct DailyData: Codable {
    var date: String
    var breakfast: Int
    var lunch: Int
    var dinner: Int
    var sleep: Int
    var totalTime: Int
    var exercises: [String: Int]
}

class DailyDataModel: ObservableObject {
    @Published var dailyData: DailyData?
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        loadDailyData()
    }

    func currentFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    func loadDailyData() {
        let todayDate = currentFormattedDate()
        let fetchRequest: NSFetchRequest<DailyDataEntity> = DailyDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", todayDate)

        do {
            let results = try context.fetch(fetchRequest)
            if let dataEntity = results.first {
                dailyData = DailyData(
                    date: dataEntity.date ?? todayDate,
                    breakfast: Int(dataEntity.breakfast),
                    lunch: Int(dataEntity.lunch),
                    dinner: Int(dataEntity.dinner),
                    sleep: Int(dataEntity.sleep),
                    totalTime: Int(dataEntity.totalTime), // Ensure the correct totalTime value
                    exercises: (dataEntity.exercises as? [String: Int]) ?? [:]
                )
                print(dailyData?.exercises)
            } else {
                initializeDefaultDailyData(for: todayDate)
            }
        } catch {
            print("Error fetching daily data:", error.localizedDescription)
            initializeDefaultDailyData(for: todayDate)
        }
    }

    func initializeDefaultDailyData(for date: String) {
        let newEntity = DailyDataEntity(context: context)
        newEntity.date = date
        newEntity.breakfast = 0
        newEntity.lunch = 0
        newEntity.dinner = 0
        newEntity.sleep = 0
        newEntity.totalTime = 0 // Initialize with correct default values
        newEntity.exercises = [:] as NSObject

        dailyData = DailyData(
            date: date,
            breakfast: 0,
            lunch: 0,
            dinner: 0,
            sleep: 0,
            totalTime: 0, // Ensure proper initialization
            exercises: [:]
        )

        do {
            try context.save() // Save new data to Core Data
        } catch {
            print("Failed to save DailyDataEntity:", error.localizedDescription)
        }
    }

    func saveDailyData(field: String, value: Int) {
            guard var dailyData = dailyData else { // Make sure 'dailyData' can be updated
                print("dailyData is nil, cannot save")
                return
            }

            switch field {
            case "breakfast":
                dailyData.breakfast = value
            case "lunch":
                dailyData.lunch = value
            case "dinner":
                dailyData.dinner = value
            default:
                print("Unknown field:", field)
                return
            }

            // Fetch the corresponding Core Data entity to update
            let fetchRequest: NSFetchRequest<DailyDataEntity> = DailyDataEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "date == %@", dailyData.date)

            do {
                let results = try context.fetch(fetchRequest)
                if let entity = results.first {
                    entity.breakfast = Int16(dailyData.breakfast)
                    entity.lunch = Int16(dailyData.lunch)
                    entity.dinner = Int16(dailyData.dinner)

                    try context.save() // Save context to persist changes
                } else {
                    print("No matching Core Data entry found.")
                }
            } catch {
                print("Error updating Core Data:", error.localizedDescription)
            }

            self.dailyData = dailyData // Update published variable to trigger UI updates
        }
    
    func fetchDailyDataEntity(for date: String) -> DailyDataEntity {
        let fetchRequest: NSFetchRequest<DailyDataEntity> = DailyDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingData = results.first {
                return existingData
            }
        } catch {
            print("Error fetching DailyDataEntity:", error.localizedDescription)
        }

        // Create a new entity if none was found
        let newEntity = DailyDataEntity(context: context)
        newEntity.date = date
        return newEntity
    }

    func savetotalTime(time: Int) {
        
        guard var dailyData = dailyData else { // Make sure 'dailyData' can be updated
            print("dailyData is nil, cannot save")
            return
        }
        
        let fetchRequest: NSFetchRequest<DailyDataEntity> = DailyDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", dailyData.date)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let entity = results.first {
                // Correct update logic
                entity.totalTime += Int16(time / 60)
                try context.save() // Save changes
            } else {
                print("No matching Core Data entry found for date: \(dailyData.date)")
            }
        } catch let fetchError as NSError {
            print("Failed to fetch Core Data records:", fetchError, fetchError.userInfo)
        }
        self.dailyData = dailyData // Update for UI
    }

    
    func saveExercises(exercises: [String: Int]) throws {
        
        guard var dailyData = dailyData else { // Make sure 'dailyData' can be updated
            print("dailyData is nil, cannot save")
            return
        }
        
        let fetchRequest: NSFetchRequest<DailyDataEntity> = DailyDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", dailyData.date)
        
        let results = try context.fetch(fetchRequest)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let entity = results.first {
                var existingExercises: [String: Int] = [:]
                
                // Convert the exercises to a Swift dictionary if not nil
                if let entityExercises = entity.exercises as? [String: Int] {
                    existingExercises = entityExercises
                }
                
                // Merge the incoming exercises with the existing ones
                for (exercise, time) in exercises {
                    if let existingTime = existingExercises[exercise] {
                        existingExercises[exercise] = existingTime + time
                    } else {
                        existingExercises[exercise] = time
                    }
                }
                
                // Update the entity's exercises with the merged dictionary
                entity.exercises = existingExercises as NSObject
                
                // Save the context to persist changes
                try context.save()
                
                // Update the struct with the new exercises
                dailyData.exercises = existingExercises
                    } else {
                print("No matching Core Data entry found for date: \(dailyData.date)")
            }
        } catch let fetchError as NSError {
            print("Failed to fetch Core Data records:", fetchError, fetchError.userInfo)
        }
        self.dailyData = dailyData // Update for UI

    }

}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var isShowingSuggestionView = false
    @State private var isShowingPopup = false
    @State private var icon = ""
    
    @ObservedObject var dailyDataModel: DailyDataModel
    
    var body: some View {
        NavigationView { //Start NavView
            ZStack {//Start ZStack
                Color.init(red: 248/255, green: 250/255, blue: 236/255)
                VStack {
                    HStack {
                        Circle()
                            .fill(Color(red: 79/255, green: 165/255, blue: 88/255))
                            .frame(width: 80, height: 80)
                            .padding(.leading, 22)
                        VStack{
                            Text("Hirun Timmy")
                                .fontWeight(.heavy)
                                .font(.system(size: 24))
                            Text("Ranking: Chest Slayer")
                                .fontWeight(.ultraLight)
                                .font(.system(size: 16))
                        }
                        Spacer()
                    }
                    .padding(.top, 50)
                    Text("Let’s Go Touch Grass")
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .padding(.leading, -160)
                        .padding(.top)
                    Button(action: {
                        self.isShowingSuggestionView = true
                    }) {
                        Text("Button Text")
                            .foregroundColor(.white)
                    }
                    .frame(width: 370, height: 111)
                    .background(Color.blue)
                    .cornerRadius(20)
                    NavigationLink(
                        destination: SuggestionView(dailyDataModel: dailyDataModel),
                        isActive: $isShowingSuggestionView
                    ) {
                        EmptyView() // NavigationLink with EmptyView if not visible
                    }
                    .hidden()
                    Text("Today’s Meal")
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .padding(.leading, -180)
                        .padding(.top)
                    HStack{
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 234/255, green: 238/255, blue: 212/255))
                                .frame(width: 178, height: 148)
                            VStack(alignment: .leading){
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                Text("Today’s Cal")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 24))
                                if let dailyData = dailyDataModel.dailyData {
                                    Text("\((dailyData.breakfast + dailyData.lunch + dailyData.dinner) * 4) Cal")
                                        .fontWeight(.ultraLight)
                                        .font(.system(size: 20))
                                } else {
                                    Text("Data not available")
                                        .fontWeight(.ultraLight)
                                        .font(.system(size: 20))
                                }
                                // Query Cal
                            }
                        }
                        
                        HStack{
                            VStack{
                                ZStack {
                                    Button(action: {
                                        // B1
                                        self.isShowingPopup = true
                                        self.icon = "morning"
                                    }) {
                                        HStack{
                                            Image(systemName: "sunrise")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .padding(.leading, -10)
                                            VStack(alignment: .leading){
                                                Text("Breackfast")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                Text("protein")
                                                    .fontWeight(.ultraLight)
                                                    .font(.system(size: 10))
                                            }
                                            if let dailyData = dailyDataModel.dailyData {
                                                Text("\(dailyData.breakfast) g")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                    .padding(.leading, 20)
                                            } else {
                                                Text("Data not available")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                    .padding(.leading, 20)
                                            }
                                            // Input and shoe query breackfast today
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: 183, height: 43)
                                    .background(Color(red: 234/255, green: 238/255, blue: 212/255)) // EAEED4 color
                                    .cornerRadius(15)
                                    // Add other components inside the button here
                                }
                                ZStack {
                                    Button(action: {
                                        // B2
                                        self.isShowingPopup = true
                                        self.icon = "lunch"
                                    }) {
                                        HStack{
                                            Image(systemName: "sun.max")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .padding(.leading, -10)
                                            VStack(alignment: .leading){
                                                Text("Lunch")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                Text("protein")
                                                    .fontWeight(.ultraLight)
                                                    .font(.system(size: 10))
                                            }
                                            if let dailyData = dailyDataModel.dailyData {
                                                Text("\(dailyData.lunch) g")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                    .padding(.leading, 45)
                                            } else {
                                                Text("Data not available")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                    .padding(.leading, 45)
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: 183, height: 43)
                                    .background(Color(red: 234/255, green: 238/255, blue: 212/255)) // EAEED4 color
                                    .cornerRadius(15)
                                    // Add other components inside the button here
                                }
                                ZStack {
                                    Button(action: {
                                        // B3
                                        self.isShowingPopup = true
                                        self.icon = "dinner"
                                    }) {
                                        HStack{
                                            Image(systemName: "sunset")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .padding(.leading, -10)
                                            VStack(alignment: .leading){
                                                Text("Dinner")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                Text("protein")
                                                    .fontWeight(.ultraLight)
                                                    .font(.system(size: 10))
                                            }
                                            if let dailyData = dailyDataModel.dailyData {
                                                Text("\(dailyData.dinner) g")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                    .padding(.leading, 45)
                                            } else {
                                                Text("Data not available")
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 11))
                                                    .padding(.leading, 45)
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: 183, height: 43)
                                    .background(Color(red: 234/255, green: 238/255, blue: 212/255)) // EAEED4 color
                                    .cornerRadius(15)
                                    // Add other components inside the button here
                                }
                                
                            }
                        }
                    }
                    Text("Today’s Stats")
                        .fontWeight(.heavy)
                        .font(.system(size: 20))
                        .padding(.leading, -180)
                    VStack{
                        HStack{
                            CustomStatBox(stat: "Calories") {
                                if let dailyData = dailyDataModel.dailyData {
                                    Text("\((dailyData.breakfast + dailyData.lunch + dailyData.dinner) * 4) Cal")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                } else {
                                    Text("Data not available")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                }
                            }
                            CustomStatBox(stat: "totalTime") {
                                if let dailyData = dailyDataModel.dailyData {
                                    Text("\(dailyData.totalTime) min")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                } else {
                                    Text("Data not available")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                }
                            }
                        }
                        HStack{
                            CustomStatBox(stat: "Sleep") {
                                if let dailyData = dailyDataModel.dailyData {
                                    Text("\(dailyData.sleep) min")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                } else {
                                    Text("Data not available")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                }
                            }
                            CustomStatBox(stat: "AvgCalories") {
                                if let dailyData = dailyDataModel.dailyData {
                                    Text("\((dailyData.breakfast + dailyData.lunch + dailyData.dinner) * 4) Cal")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                } else {
                                    Text("Data not available")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                }
                            }
                            
                        }
                    }
                    Spacer()
                }
                if isShowingPopup {
                    MealInputPopup(
                        isVisible: $isShowingPopup,
                        icon: icon,
                        dailyDataModel: dailyDataModel // Pass the DailyDataModel
                    )
                }
            }//End ZStack
            .edgesIgnoringSafeArea(.top)
            
        }//End NavView
        .onAppear {
            dailyDataModel.loadDailyData()
        }
        .environmentObject(dailyDataModel)
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView(dailyDataModel: DailyDataModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    
}
