//
//  APIService.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-04.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    
    static var endPoint = "http://localhost:8080/getFidoItems"
    
    static var cancellables = Set<AnyCancellable>()
    
    func fetchItems(completion: @escaping ([FidoItem]) -> Void) {
        URLSession.shared.dataTaskPublisher(for: URL(string: APIService.endPoint)!)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [FidoItem].self, decoder: JSONDecoder())
            .sink { completion in
                // This handles the end of the stream, whether it finished normally or failed
                switch completion {
                case .finished:
                    print("Successfully finished")
                case .failure(let error):
                    print("Finished with error: \(error.localizedDescription)")
                }
            } receiveValue: { items in
                // This handles the actual data (e.g., your [FidoItem])
                print("Received \(items) items")
                completion(items)
            }
            .store(in: &APIService.cancellables)
    }
    
    func addFidoItem(_ item: FidoItem, isPost: Bool = true) async -> Bool {
        let url = isPost ? URL(string: APIService.endPoint)! : URL(string: "\(APIService.endPoint)/\(item.id ?? 0)")!
        var request = URLRequest(url: url)
        request.httpMethod = isPost ? "POST" :"PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(item)
            
            // Perform the request
            let (_, response) = try await URLSession.shared.data(for: request)
            
            // Check if the status code is 200 OK
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                return true
            }
            return false
        } catch {
            print("Update error: \(error)")
            return false
        }
    }
}
