//
//  MealInputPopup.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 16/4/2567 BE.
//


import SwiftUI

struct MealInfoView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
            
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .font(.system(size: 24))
            
            Text("Amount of Protein")
                .foregroundColor(.white)
                .fontWeight(.thin)
                .font(.system(size: 16))
        }
    }
}

struct MealInputPopup: View {
    let isVisible: Binding<Bool> // Controls popup visibility
    let icon: String // Identifies the type of meal
    @ObservedObject var dailyDataModel: DailyDataModel // Model to interact with Core Data
    @State private var userInput: Int = 0 // Tracks user input for updating Core Data
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4) // Background for the popup
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer() // Ensures the close button is aligned to the right
                    Button(action: {
                        self.isVisible.wrappedValue = false // Close the popup
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.top, 10)
                            .padding(.horizontal)
                    }
                }
                
                // Determine which meal to update based on the icon
                if icon == "morning" {
                    MealInfoView(icon: "sunrise", title: "Breakfast")
                } else if icon == "lunch" {
                    MealInfoView(icon: "sun.max", title: "Lunch")
                } else if icon == "dinner" {
                    MealInfoView(icon: "sunset", title: "Dinner")
                }
                
                // Text field to capture user input for protein amount
                HStack {
                    TextField("Enter protein (g)", value: $userInput, formatter: NumberFormatter())
                        .keyboardType(.numberPad) // Allow only numeric input
                        .padding()
                        .frame(width: 166, height: 40)
                        .background(Color.white)
                        .cornerRadius(15)
                    
                    // Button to update Core Data with user input
                    Button(action: {
                        // Update Core Data based on the icon and user input
                        if userInput > 0 { // Only allow valid positive input
                            if icon == "morning" {
                                dailyDataModel.saveDailyData(field: "breakfast", value: userInput)
                            } else if icon == "lunch" {
                                dailyDataModel.saveDailyData(field: "lunch", value: userInput)
                            } else if icon == "dinner" {
                                dailyDataModel.saveDailyData(field: "dinner", value: userInput)
                            }
                        }
                        self.isVisible.wrappedValue = false // Close the popup after updating
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer() // Ensure proper spacing in the popup
            }
            .frame(width: 255, height: 220) // Set popup size
            .background(Color(red: 35/255, green: 35/255, blue: 35/255)) // Set popup background
            .cornerRadius(20) // Rounded corners
        }
        .opacity(isVisible.wrappedValue ? 1 : 0) // Control visibility with animation
        .animation(.easeInOut)
    }
}


struct MealInputPopup_Previews: PreviewProvider {
    @State static var isPopupVisible = true
    @ObservedObject static var dailyDataModel = DailyDataModel()
    static var previews: some View {
        MealInputPopup(isVisible: $isPopupVisible, icon: "morning", dailyDataModel: dailyDataModel)
    }
}
