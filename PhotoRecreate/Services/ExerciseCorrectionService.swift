import Foundation
import UIKit

class ExerciseCorrectionService {
    static let shared = ExerciseCorrectionService()
    
    private var baseURL = "https://exercise-correction-847512274646.asia-southeast2.run.app"
    
    func analyzeVideo(videoURL: URL, exerciseType: String) async throws -> AnalysisResult {
        let url = URL(string: "\(baseURL)/api/video/upload?type=\(exerciseType)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let fileData = try Data(contentsOf: videoURL)
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"video.mp4\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(AnalysisResult.self, from: data)
    }
    
    func setBaseURL(_ newURL: String) {
        self.baseURL = newURL
    }
}
