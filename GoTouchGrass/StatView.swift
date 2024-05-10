//
//  StatView.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 25/3/2567 BE.
//

import SwiftUI
import CoreData

struct StatView: View {
    @ObservedObject var dailyDataModel: DailyDataModel // Binding to the ObservableObject
    var body: some View {
        ZStack{
            Color.init(red: 248/255, green: 250/255, blue: 236/255)
            VStack{
                Text("Your Statistic")
                    .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                    .font(.system(size: 24, weight: .heavy))
                    .padding(.top, 64)
                ZStack{
                    Rectangle()
                        .frame(width: 380, height: 170)
                        .cornerRadius(20)
                        .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                    HStack {
                        VStack{
                            VStack(alignment: .leading){
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                Text("Today’s Cal")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                if let dailyData = dailyDataModel.dailyData {
                                    Text("\((dailyData.breakfast + dailyData.lunch + dailyData.dinner) * 4) Cal")
                                        .fontWeight(.ultraLight)
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                } else {
                                    Text("Data not available")
                                        .fontWeight(.ultraLight)
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                            
                        }
                        .padding(20)
                        VStack{
                            ZStack {
                                Button(action: {
                                    // Add action for the button here
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
                                                .padding(.leading, 45)
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: 183, height: 43)
                                .background(Color(red: 79/255, green: 165/255, blue: 88/255))
                                .cornerRadius(15)
                                // Add other components inside the button here
                            }
                            ZStack {
                                Button(action: {
                                    // Add action for the button here
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
                                .background(Color(red: 79/255, green: 165/255, blue: 88/255))
                                .cornerRadius(15)
                                // Add other components inside the button here
                            }
                            ZStack {
                                Button(action: {
                                    // Add action for the button here
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
                                .background(Color(red: 79/255, green: 165/255, blue: 88/255))
                                .cornerRadius(15)
                                // Add other components inside the button here
                            }
                            
                        }
                    }
                }
                Text("Exercise’s Lists")
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                    .padding(.leading, -185)
                    .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                ZStack{
                    Rectangle()
                        .frame(width: 380, height: 200)
                        .cornerRadius(20)
                        .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                    ScrollView {
                        VStack(spacing: 10) {
                            if let exercises = dailyDataModel.dailyData?.exercises {
                                ForEach(exercises.keys.sorted(), id: \.self) { exerciseName in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.green)
                                            .frame(width: 276, height: 47)
                                            .overlay(
                                                Text("\(exerciseName)")
                                                    .foregroundColor(.white)
                                            )
                                    }
                                }
                            } else {
                                Text("No exercises found")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }
                    .frame(width: 310, height: 201)
                    .clipped()
            }
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
    }
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
}
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        // Initialize Core Data context for in-memory storage (for previews)
        let inMemoryContext = {
            let container = NSPersistentContainer(name: "DailyDataModel")
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            container.loadPersistentStores { _, error in
                if let nsError = error as NSError? { // Replace <#identifier#> with a variable name
                    fatalError("Error initializing Core Data: \(nsError.localizedDescription)")
                }
            }
            return container.viewContext
        }()
        
        // Create an instance of DailyDataModel with the in-memory context
        let testDailyDataModel = DailyDataModel(context: inMemoryContext) // Ensure correct initialization
        
        return StatView(dailyDataModel: testDailyDataModel) // Pass only DailyDataModel
            .environmentObject(testDailyDataModel) // Provide the environment object
    }
}
