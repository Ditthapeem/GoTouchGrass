//
//  SuggestionView.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 25/3/2567 BE.
//

import SwiftUI
import CoreData

struct Exercise: Codable {
    let description: String
    let durationInSeconds: Int
}

struct SuggestionView: View {
    @ObservedObject var dailyDataModel: DailyDataModel
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer? = nil
    @State private var isTimerRunning = false
    @State private var TodayTime: Int = 0
    @State private var selectedCategory = 0
    @State private var selectedExercises: [String: Exercise] = [:]
    
    let excerciseCatigory = ["Chest", "Back", "Sholder", "Leg", "Arm"]
    let chestList: [String: Exercise] = [
        "Push-ups": Exercise(description: "Start in a plank position, hands shoulder-width apart, lower your body until your chest nearly touches the floor, then push back up.", durationInSeconds: 60),
        "Dumbbell bench press": Exercise(description: "Lie on a bench with dumbbells in hand, lower them to chest level, then press them back up.", durationInSeconds: 60),
        "Chest flyes": Exercise(description: "Lie on a bench with dumbbells in hand, arms extended above chest, lower arms to the sides, then bring them back together.", durationInSeconds: 45),
        "Dips": Exercise(description: "Use parallel bars or a sturdy chair, lower your body by bending your arms, then push back up.", durationInSeconds: 60),
        "Decline push-ups": Exercise(description: "Place feet on an elevated surface, perform push-ups as usual.", durationInSeconds: 45),
        "Incline dumbbell press": Exercise(description: "Lie on an incline bench, press dumbbells up from chest level.", durationInSeconds: 60),
        "Medicine ball chest pass": Exercise(description: "Hold a medicine ball, extend arms in front of you, then explosively push it forward.", durationInSeconds: 45),
        "Cable chest press": Exercise(description: "Use a cable machine, grasp handles, extend arms forward, then bring them back to chest level.", durationInSeconds: 60),
        "Chest press machine": Exercise(description: "Sit on a chest press machine, grasp handles, push handles forward until arms are extended, then return to starting position.", durationInSeconds: 45),
        "Plyometric push-ups": Exercise(description: "Perform push-ups explosively, pushing your body off the ground with force.", durationInSeconds: 60)
    ]
    
    let backList: [String: Exercise] = [
        "Pull-ups": Exercise(description: "Hang from a bar, pull your body up until your chin clears the bar.", durationInSeconds: 45),
        "Bent-over rows": Exercise(description: "Hold dumbbells or a barbell, bend forward at the waist, pull the weight up toward your lower chest.", durationInSeconds: 60),
        "Single-arm dumbbell rows": Exercise(description: "Bend at the waist, support yourself with one hand on a bench, row a dumbbell up toward your hip.", durationInSeconds: 45),
        "Lat pulldowns": Exercise(description: "Sit at a lat pulldown machine, grasp the bar, pull it down toward your chest.", durationInSeconds: 60),
        "Seated rows": Exercise(description: "Sit at a rowing machine, grasp handles, pull them toward your torso.", durationInSeconds: 45),
        "Superman": Exercise(description: "Lie face down on the floor, extend arms and legs off the ground, hold briefly, then lower.", durationInSeconds: 60),
        "Reverse flyes": Exercise(description: "Bend forward at the waist, hold dumbbells with arms hanging down, raise arms out to the sides.", durationInSeconds: 45),
        "T-bar rows": Exercise(description: "Straddle a T-bar machine, grasp handles, pull the bar toward your torso.", durationInSeconds: 60),
        "Renegade rows": Exercise(description: "Start in a plank position with dumbbells in hand, row one dumbbell up to your side while balancing on the other arm.", durationInSeconds: 45),
        "Deadlifts": Exercise(description: "Stand with feet hip-width apart, grasp a barbell or dumbbells, keeping back straight, hinge at the hips and lower the weight toward the ground, then return to standing position.", durationInSeconds: 60)
    ]
    let legList: [String: Exercise] = [
        "Bodyweight squats": Exercise(description: "Stand with feet hip-width apart, lower your body by bending at the knees and hips, keeping your chest up, then return to standing.", durationInSeconds: 90), // Duration is variable
        "Lunges": Exercise(description: "Step forward with one leg, lower your body until both knees are bent at 90-degree angles, then push back up to starting position and repeat with the other leg.", durationInSeconds: 60),
        "Bulgarian split squats": Exercise(description: "Stand a few feet in front of a bench or elevated surface, place one foot on the bench behind you, lower your body until your front thigh is parallel to the ground, then push back up.", durationInSeconds: 60),
        "Wall sits": Exercise(description: "Lean your back against a wall and slide down until your thighs are parallel to the ground, hold this position.", durationInSeconds: 90),
        "Step-ups": Exercise(description: "Step onto a bench or sturdy elevated surface with one foot, pushing through the heel, then step down and repeat with the other foot.", durationInSeconds: 60),
        "Calf raises": Exercise(description: "Stand with feet hip-width apart, raise up onto the balls of your feet, then lower back down.", durationInSeconds: 90),
        "Glute bridges": Exercise(description: "Lie on your back with knees bent, lift your hips off the ground until your body forms a straight line from knees to shoulders, then lower back down.", durationInSeconds: 60),
        "Single-leg deadlifts": Exercise(description: "Stand on one leg with a slight bend in the knee, hinge forward at the hips while extending the other leg behind you, keeping your back straight, then return to standing.", durationInSeconds: 60),
        "Squat jumps": Exercise(description: "Perform a squat, then explode upward into a jump, land softly and immediately go into the next squat.", durationInSeconds: 45),
        "Leg press": Exercise(description: "Sit on a leg press machine, place feet shoulder-width apart on the platform, push the platform away from you by extending your knees, then return to starting position.", durationInSeconds: 60)
    ]
    let shoulderList: [String: Exercise] = [
        "Dumbbell shoulder press": Exercise(description: "Sit or stand with dumbbells in hand, press them overhead until arms are fully extended, then lower back down.", durationInSeconds: 60),
        "Lateral raises": Exercise(description: "Stand with dumbbells in hand by your sides, raise them out to the sides until arms are parallel to the ground, then lower back down.", durationInSeconds: 45),
        "Front raises": Exercise(description: "Stand with dumbbells in hand in front of your thighs, raise them straight in front of you until arms are parallel to the ground, then lower back down.", durationInSeconds: 45),
        "Rear delt flyes": Exercise(description: "Bend forward at the waist with dumbbells in hand, raise them out to the sides until arms are parallel to the ground, then lower back down.", durationInSeconds: 45),
        "Arnold press": Exercise(description: "Start with dumbbells at shoulder height and palms facing you, press them overhead while rotating your palms to face away from you at the top, then reverse the motion.", durationInSeconds: 60),
        "Shoulder shrugs": Exercise(description: "Hold dumbbells at your sides, shrug your shoulders up toward your ears, then lower back down.", durationInSeconds: 90),
        "Upright rows": Exercise(description: "Hold a barbell or dumbbells in front of your thighs, pull them up toward your chin, keeping elbows higher than wrists.", durationInSeconds: 60),
        "Face pulls": Exercise(description: "Attach a rope to a cable machine at shoulder height, grasp the rope handles, pull them toward your face, keeping elbows high and wide.", durationInSeconds: 45),
        "Handstand push-ups": Exercise(description: "Kick up into a handstand against a wall, lower your body by bending your arms, then press back up.", durationInSeconds: 60),
        "Military press": Exercise(description: "Stand or sit with a barbell or dumbbells at shoulder height, press them overhead until arms are fully extended, then lower back down.", durationInSeconds: 60)
    ]
    let armList: [String: Exercise] = [
        "Bicep curls": Exercise(description: "Stand or sit with dumbbells in hand, curl them up toward your shoulders, then lower back down.", durationInSeconds: 60),
        "Hammer curls": Exercise(description: "Stand or sit with dumbbells in hand, curl them up toward your shoulders with palms facing in, then lower back down.", durationInSeconds: 60),
        "Tricep dips": Exercise(description: "Sit on the edge of a bench or chair, grip the edge with hands shoulder-width apart, slide your butt off the bench, lower your body by bending your arms, then press back up.", durationInSeconds: 60),
        "Tricep kickbacks": Exercise(description: "Stand with a dumbbell in hand, hinge forward at the waist, extend your arm behind you, then return to starting position.", durationInSeconds: 45),
        "Skull crushers": Exercise(description: "Lie on a bench with dumbbells in hand, extend arms straight up over chest, bend elbows to lower weights toward forehead, then extend arms back up.", durationInSeconds: 60),
        "Close-grip push-ups": Exercise(description: "Perform push-ups with hands close together, targeting the triceps.", durationInSeconds: 45),
        "Chin-ups": Exercise(description: "Perform pull-ups with palms facing towards you, targeting the biceps.", durationInSeconds: 45),
        "Cable bicep curls": Exercise(description: "Attach a straight or EZ-bar to a cable machine, grasp the bar, curl it up toward your shoulders, then lower back down.", durationInSeconds: 60),
        "Cable tricep pushdowns": Exercise(description: "Attach a rope to a high cable pulley, grasp the rope, push it down toward the ground, then return to starting position.", durationInSeconds: 45),
        "Preacher curls": Exercise(description: "Sit at a preacher curl bench, grasp a barbell with an underhand grip, curl it up toward your shoulders, then lower back down.", durationInSeconds: 60)
    ]
    
    
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
                TodayTime += 1
            } else {
                timer.invalidate()
                self.timer = nil // Clear the timer reference
                let todayDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
                do {
                    let exercisesToSave = convertExercisesToDictionary() // Convert before saving
                    dailyDataModel.savetotalTime(time: TodayTime)
                    try! dailyDataModel.saveExercises(exercises: exercisesToSave)
                } catch {
                    print("Error during timer or exercises save:", error.localizedDescription) // Error handling
                }
            }
        }
    }

    
    func pauseTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func convertExercisesToDictionary() -> [String: Int] {
            var exerciseDictionary: [String: Int] = [:]
            for (key, exercise) in selectedExercises {
                exerciseDictionary[key] = exercise.durationInSeconds
            }
            return exerciseDictionary
        }
    
    var body: some View {
        let exerciseList: [String: Exercise]
        switch selectedCategory {
        case 0:
            exerciseList = chestList
        case 1:
            exerciseList = backList
        case 2:
            exerciseList = shoulderList
        case 3:
            exerciseList = legList
        case 4:
            exerciseList = armList
        default:
            exerciseList = chestList
        }
        return NavigationView{
            ZStack{
                Color.init(red: 248/255, green: 250/255, blue: 236/255)
                VStack{
                    Text("Suggestion")
                        .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                        .font(.system(size: 24, weight: .heavy))
                        .padding(.top, 64)
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 234/255, green: 238/255, blue: 212/255))
                            .frame(width: 387, height: 427)
                        VStack{
                            HStack(spacing: 40){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(red: 35/255, green: 35/255, blue: 35/255))
                                        .frame(width: 140, height: 111)
                                    
                                    VStack(alignment: .leading) {
                                        Image(systemName: "timer")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 34, height: 34)
                                            .foregroundColor(.white) // Set icon color
                                        
                                        Text("\(TodayTime/60) mins")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 20))
                                            .foregroundColor(.white) // Set text color
                                        
                                        Text("Time")
                                            .fontWeight(.ultraLight)
                                            .font(.system(size: 12))
                                            .foregroundColor(.white) // Set text color
                                        // Query Timer
                                    }
                                    .padding(.leading, -40)
                                }
                                VStack {
                                    Text("\(timeRemaining) Secs")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                                        .frame(width: 136, height: 39)
                                    
                                    Button(action: {
                                        if isTimerRunning {
                                            pauseTimer()
                                        } else {
                                            startTimer()
                                        }
                                    }) {
                                        Text(isTimerRunning ? "Pause" : "Start")
                                            .font(.system(size: 12, weight: .thin))
                                            .foregroundColor(Color(red: 35/255, green: 35/255, blue: 35/255))
                                            .frame(width: 136, height: 39)
                                            .background(Color(red: 79/255, green: 165/255, blue: 88/255))
                                            .cornerRadius(10)
                                    }
                                }
  
                            }
                            Text("Exercise’s Lists")
                                .fontWeight(.heavy)
                                .font(.system(size: 20))
                                .padding(.leading, -155)
                                .padding(.top)
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 35/255, green: 35/255, blue: 35/255))
                                    .frame(width: 310, height: 201)
                                ScrollView {
                                    Spacer()
                                    VStack(spacing: 10) {
                                        ForEach(selectedExercises.keys.sorted(), id: \.self) { exerciseName in
                                            if let exercise = selectedExercises[exerciseName] {
                                                Button(action: {
                                                    selectedExercises.removeValue(forKey: exerciseName)
                                                    calculateTotalDuration()
                                                }) {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(Color(red: 79/255, green: 165/255, blue: 88/255)) // Color 4FA558
                                                        .frame(width: 276, height: 47)
                                                        .overlay(
                                                            Text("\(exerciseName)")
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(width: 310, height: 201)
                                .clipped()
                            }
                        }
                        
                    }
                    Picker(selection: $selectedCategory, label: Text("Select Category")) {
                        ForEach(0..<excerciseCatigory.count) { index in
                            Text(self.excerciseCatigory[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 234/255, green: 238/255, blue: 212/255))
                            .frame(width: 387, height: 207)
                        
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(exerciseList.keys.sorted(), id: \.self) { exerciseName in
                                    if let exercise = exerciseList[exerciseName] {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .frame(width: 350, height: 130) // Adjust size as needed
                                            .overlay(
                                                Button(action: {
                                                    if selectedExercises[exerciseName] != nil {
                                                        selectedExercises.removeValue(forKey: exerciseName)
                                                        calculateTotalDuration()
                                                    } else {
                                                        selectedExercises[exerciseName] = exercise
                                                        calculateTotalDuration()
                                                    }
                                                }) {
                                                    VStack(spacing: 5) {
                                                        Text(exerciseName)
                                                            .fontWeight(.semibold)
                                                            .font(.system(size: 18))
                                                            .foregroundColor(.black)
                                                        Spacer()
                                                        Text(exercise.description)
                                                            .font(.system(size: 14))
                                                            .foregroundColor(.black)
                                                            .multilineTextAlignment(.center)
                                                        Spacer()
                                                    }
                                                    .padding()
                                                }
                                            )
                                            .padding(.vertical, 5)
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(width: 367, height: 187)
                        .clipped()
                    }
                    
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .onDisappear {
                pauseTimer() // Ensure timer is stopped when the view is dismissed
            }
        }
    }
    
    func calculateTotalDuration() {
        timeRemaining = selectedExercises.values.reduce(0) { $0 + $1.durationInSeconds }
    }
}



struct SuggestionView_Previews: PreviewProvider {
    @ObservedObject static var dailyDataModel: DailyDataModel = {
        let inMemoryContext = {
            // Create an in-memory persistent store for previews
            let container = NSPersistentContainer(name: "DailyDataModel")
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // Set to /dev/null for in-memory
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Error loading in-memory Core Data stack: \(error), \(error.userInfo)")
                }
            }
            return container.viewContext
        }()
        return DailyDataModel(context: inMemoryContext) // Initialize DailyDataModel with in-memory context
    }()
    
    static var previews: some View {
        SuggestionView(dailyDataModel: dailyDataModel) // Pass DailyDataModel to the view
    }
}
