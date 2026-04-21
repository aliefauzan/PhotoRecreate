import Foundation

struct AnalysisResult: Decodable {
    let type: String
    let processed: Bool
    let fileName: String
    let details: [FeedbackDetail]
    let llmFeedback: String
    let motionHistory: [MotionData]?
    let counter: CounterData?
    let mistakeCount: Int?
    let snapshotURL: String?
    let snapshotStage: String?
    let snapshotTimestamp: Int?

    enum CodingKeys: String, CodingKey {
        case type, processed, details, counter
        case fileName = "file_name"
        case llmFeedback = "llm_feedback"
        case motionHistory = "motion_history"
        case mistakeCount = "mistake_count"
        case snapshotURL = "snapshot_url"
        case snapshotStage = "snapshot_stage"
        case snapshotTimestamp = "snapshot_timestamp"
    }

    var primarySnapshotFrame: String? {
        snapshotURL ?? details.first(where: { $0.frame != nil })?.frame
    }

    var primarySnapshotStage: String? {
        snapshotStage ?? details.first(where: { $0.frame != nil })?.stage
    }

    var resolvedMistakeCount: Int {
        mistakeCount ?? details.count
    }

    var fallbackSummaryStrings: Set<String> {
        [
            "Your form is generally good. Focus on controlled movement and stability.",
            "Your form is generally good. Keep focusing on core stability and controlled movements.",
            "Your model feedback will appear here after analysis finishes."
        ]
    }

    var summaryFeedback: String {
        let trimmed = llmFeedback.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty, !fallbackSummaryStrings.contains(trimmed) {
            return trimmed
        }
        return generatedSummary
    }

    var generatedSummary: String {
        let exerciseName = type.replacingOccurrences(of: "_", with: " ")
        if details.isEmpty {
            return "Your \(exerciseName) form looked steady throughout this clip. Nothing stood out as a clear breakdown pattern, which is a good sign that your setup and control were consistent. Keep the same tempo, stay intentional with each rep, and try to hold that level of control again on the next set."
        }

        let counts = Dictionary(grouping: details, by: \.stage)
            .mapValues(\.count)
            .sorted { lhs, rhs in
                if lhs.value == rhs.value {
                    return lhs.key < rhs.key
                }
                return lhs.value > rhs.value
            }
            .prefix(3)
            .map { "\($0.key.humanizedStageTitle) (\($0.value)x)" }
            .joined(separator: ", ")
        let mainStage = Dictionary(grouping: details, by: \.stage)
            .mapValues(\.count)
            .sorted { lhs, rhs in
                if lhs.value == rhs.value {
                    return lhs.key < rhs.key
                }
                return lhs.value > rhs.value
            }
            .first?
            .key ?? "unknown"

        if resolvedMistakeCount == 1 {
            return "In this \(exerciseName) clip, the main thing to clean up was \(mainStage.humanizedStageTitle). \(summaryFocus(for: mainStage, exerciseName: exerciseName))"
        }

        return "In this \(exerciseName) clip, there were \(resolvedMistakeCount) form breakdowns across the set. The most repeated patterns were \(counts), so the biggest priority is \(mainStage.humanizedStageTitle). \(summaryFocus(for: mainStage, exerciseName: exerciseName)) After that starts to look cleaner, work through the remaining mistakes one by one."
    }

    private func summaryFocus(for stage: String, exerciseName: String) -> String {
        switch stage.lowercased() {
        case "low back":
            return "Most of the breakdown came from a low back position. When the hips drop, more load shifts into the lower back and it becomes harder to keep the core doing the work. On the next set, brace your abs before you start, squeeze your glutes, and think about keeping the shoulders, hips, and heels in one straight line."
        case "high back":
            return "The biggest issue was a high hip position. When the hips stay too high, the plank becomes less effective for the core and the body loses that strong straight-line posture. On the next set, push the floor away, keep the ribs tucked down, and lower the hips just enough to line everything up."
        case "knee over toe":
            return "The main issue was the knee drifting too far forward. That usually means the movement is shifting away from a balanced lunge position and the front leg is absorbing force less efficiently. On the next set, sit the hips down and back a little more and keep the front shin more controlled as you lower."
        case "knee angle":
            return "The main issue was inconsistent knee depth and position. When the knee angle moves outside the stable range, it becomes harder to stay balanced and produce force cleanly through the rep. On the next set, lower with control, stop at a depth you can own, and keep both legs organized from top to bottom."
        case "leaning back":
            return "The biggest thing to clean up was leaning back during the curl. That shifts the work away from the arm and uses momentum to finish the rep instead of muscle control. On the next set, stay stacked over the hips, keep the ribs down, and let the elbow stay quiet while the forearm does the work."
        case "left loose upper arm":
            return "The left upper arm moved too much during the curl. When the upper arm drifts, the rep gets less strict and it becomes harder to keep tension where you want it. On the next set, pin the left elbow close to your side and focus on moving only through the forearm."
        case "right loose upper arm":
            return "The right upper arm moved too much during the curl. When the upper arm drifts, the rep gets less strict and it becomes harder to keep tension where you want it. On the next set, pin the right elbow close to your side and focus on moving only through the forearm."
        case "left weak peak contraction":
            return "The left side did not reach a strong squeeze at the top of the curl. That usually means you are moving through the rep without fully finishing it, so the bicep loses some of the training effect. On the next set, slow the top half slightly and actively squeeze before lowering again."
        case "right weak peak contraction":
            return "The right side did not reach a strong squeeze at the top of the curl. That usually means you are moving through the rep without fully finishing it, so the bicep loses some of the training effect. On the next set, slow the top half slightly and actively squeeze before lowering again."
        case "feet too tight":
            return "Your stance was too narrow for the squat pattern in this clip. A stance that is too tight can make it harder for the hips and knees to track smoothly, especially as you go deeper. On the next set, move the feet slightly wider and keep pressure balanced through the whole foot."
        case "feet too wide":
            return "Your stance was wider than it needed to be. That can make the squat harder to balance and can change how the knees and hips line up during the descent. On the next set, bring the feet in slightly and keep the descent straight and controlled."
        case "knee too tight":
            return "Your knees were tracking too far inward compared with the ideal line. That usually makes the position less stable and can reduce how cleanly you move through the squat. On the next set, keep the feet grounded and drive the knees out so they stay over the middle of the feet."
        case "knee too wide":
            return "Your knees were pushing too far outward compared with the ideal line. That can throw off balance and make the squat look less controlled even if you still finish the rep. On the next set, guide the knees over the toes naturally and avoid forcing them wider than needed."
        default:
            return "The clearest issue in this \(exerciseName) clip showed up around \(stage.humanizedStageTitle). Use the review frames to compare where your position starts to drift, then clean up that phase first on the next set."
        }
    }
}

struct FeedbackDetail: Decodable, Identifiable {
    let id = UUID()
    let type: String?
    let title: String?
    let peakVal: Double?
    let metricLabel: String?
    let metricValue: String?
    let explanation: String?
    let frame: String?
    let timestamp: Int?
    let stage: String

    enum CodingKeys: String, CodingKey {
        case type, title, frame, timestamp, stage, explanation
        case peakVal = "peak_val"
        case metricLabel = "metric_label"
        case metricValue = "metric_value"
        case peakAngle = "peak_angle"
        case peakProb = "peak_prob"
        case minConf = "min_conf"
    }

    init(
        type: String? = nil,
        title: String? = nil,
        peakVal: Double? = nil,
        metricLabel: String? = nil,
        metricValue: String? = nil,
        explanation: String? = nil,
        frame: String? = nil,
        timestamp: Int? = nil,
        stage: String
    ) {
        self.type = type
        self.title = title
        self.peakVal = peakVal
        self.metricLabel = metricLabel
        self.metricValue = metricValue
        self.explanation = explanation
        self.frame = frame
        self.timestamp = timestamp
        self.stage = stage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        frame = try container.decodeIfPresent(String.self, forKey: .frame)
        timestamp = try container.decodeIfPresent(Int.self, forKey: .timestamp)
        stage = try container.decodeIfPresent(String.self, forKey: .stage) ?? "unknown"
        explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
        metricLabel = try container.decodeIfPresent(String.self, forKey: .metricLabel)
        metricValue = try container.decodeIfPresent(String.self, forKey: .metricValue)
        peakVal =
            try container.decodeIfPresent(Double.self, forKey: .peakVal)
            ?? container.decodeIfPresent(Double.self, forKey: .peakAngle)
            ?? container.decodeIfPresent(Double.self, forKey: .peakProb)
            ?? container.decodeIfPresent(Double.self, forKey: .minConf)
    }

    var resolvedTitle: String {
        title ?? stage.humanizedStageTitle
    }

    var resolvedMetricLabel: String? {
        if let metricLabel, !metricLabel.isEmpty {
            return metricLabel
        }
        guard peakVal != nil else {
            return nil
        }

        let lowerStage = stage.lowercased()
        if lowerStage.contains("ratio") || lowerStage.contains("tight") || lowerStage.contains("wide") {
            return "Peak ratio"
        }
        if lowerStage.contains("angle") || lowerStage.contains("arm") || lowerStage.contains("contraction") {
            return "Peak angle"
        }
        if lowerStage.contains("confidence") || lowerStage.contains("back") {
            return "Model confidence"
        }
        return "Peak value"
    }

    var resolvedMetricValue: String? {
        if let metricValue, !metricValue.isEmpty {
            return metricValue
        }
        guard let peakVal else {
            return nil
        }

        let lowerStage = stage.lowercased()
        if lowerStage.contains("ratio") || lowerStage.contains("tight") || lowerStage.contains("wide") {
            return String(format: "%.2f", peakVal)
        }
        if lowerStage.contains("angle") || lowerStage.contains("arm") || lowerStage.contains("contraction") {
            return String(format: "%.1f deg", peakVal)
        }
        if lowerStage.contains("confidence") || lowerStage.contains("back") {
            return String(format: "%.3f", peakVal)
        }
        return String(format: "%.3f", peakVal)
    }

    var resolvedExplanation: String {
        if let explanation, !explanation.isEmpty {
            return explanation
        }

        let lowerStage = stage.lowercased()
        let metricSuffix: String
        if let label = resolvedMetricLabel, let value = resolvedMetricValue {
            metricSuffix = " \(label): \(value)."
        } else {
            metricSuffix = ""
        }

        let base: String
        switch lowerStage {
        case "low back":
            base = "Your hips dropped below a neutral plank line, so the lower back is taking extra load. Brace your abs and squeeze your glutes to bring the body back into one straight line."
        case "high back":
            base = "Your hips lifted too high, which reduces the core demand of the plank. Push the floor away and lower the hips until shoulders, hips, and heels line up."
        case "knee over toe":
            base = "The front knee drifted too far forward during the lunge. Sit the hips down and back so the shin stays more controlled and the leg can absorb force better."
        case "knee angle":
            base = "The lunge depth or knee depth was outside the stable target range. Lower with control and stop where both legs can stay balanced and aligned."
        case "leaning back":
            base = "Your torso leaned back during the curl, so momentum helped the rep instead of the arm. Keep ribs down and stay stacked over your hips before you curl."
        case "left loose upper arm":
            base = "Your left upper arm moved too much during the curl. Pin the elbow near your side and let only the forearm rotate through the rep."
        case "right loose upper arm":
            base = "Your right upper arm moved too much during the curl. Pin the elbow near your side and let only the forearm rotate through the rep."
        case "left weak peak contraction":
            base = "The left arm did not reach a strong squeeze at the top of the curl. Finish the rep by actively flexing the bicep before lowering."
        case "right weak peak contraction":
            base = "The right arm did not reach a strong squeeze at the top of the curl. Finish the rep by actively flexing the bicep before lowering."
        case "feet too tight":
            base = "Your stance was narrower than the model expects for a stable squat. Move the feet slightly wider so the hips and knees can track with better balance."
        case "feet too wide":
            base = "Your stance was wider than the model expects for a stable squat. Bring the feet in slightly so you can descend without shifting pressure side to side."
        case "knee too tight":
            base = "Your knees tracked too far inside the ideal squat line. Drive the knees out to stay over the middle of the feet as you descend."
        case "knee too wide":
            base = "Your knees tracked too far outside the ideal squat line. Keep pressure through the whole foot and guide the knees over the toes instead of pushing them excessively out."
        default:
            base = "The model flagged this phase as a form issue. Use the snapshot to compare your body position and clean up this rep pattern on the next set."
        }

        return base + metricSuffix
    }
}

struct MotionData: Decodable {
    let timestamp: Int
    let feetRatio: Double?
    let kneeRatio: Double?
    let stage: String?
    let confidence: Double?
    let rightKneeAngle: Double?
    let leftKneeAngle: Double?

    enum CodingKeys: String, CodingKey {
        case timestamp, stage, confidence
        case feetRatio = "feet_ratio"
        case kneeRatio = "knee_ratio"
        case rightKneeAngle = "right_knee_angle"
        case leftKneeAngle = "left_knee_angle"
    }
}

enum CounterData: Codable {
    case single(Int)
    case double(left: Int, right: Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let val = try? container.decode(Int.self) {
            self = .single(val)
        } else if let dict = try? container.decode([String: Int].self) {
            self = .double(left: dict["left_counter"] ?? 0, right: dict["right_counter"] ?? 0)
        } else {
            self = .single(0)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .single(let val):
            try container.encode(val)
        case .double(let left, let right):
            try container.encode(["left_counter": left, "right_counter": right])
        }
    }
}

private extension String {
    var humanizedStageTitle: String {
        replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}
