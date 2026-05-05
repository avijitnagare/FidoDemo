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
    
    func addFidoItem(_ item: FidoItem, completion: @escaping (Bool) -> Void) {
        
    }
}
