import Foundation

struct ExerciseAnalysis {
    var counter: Int?
    var errors: [String] = []
    var motionHistory: [MotionHistory] = []
    var feedback: FeedbackModel
}
