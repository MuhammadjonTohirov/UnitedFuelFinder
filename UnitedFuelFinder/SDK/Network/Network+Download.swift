//
//  Network+Download.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/07/24.
//

import Foundation

extension Network {
    func downloadPDF(url urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: URLRequest.new(url: url)) { localURL, response, error in
            guard let localURL = localURL else {
                completion(nil)
                return
            }
            
            // Move the file to a permanent location if needed
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsPath.appendingPathComponent("d\(Date.timeIntervalSinceReferenceDate).pdf")
            
            do {
                try FileManager.default.moveItem(at: localURL, to: destinationURL)
                completion(destinationURL)
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
