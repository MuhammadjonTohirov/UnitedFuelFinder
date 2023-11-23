//
//  SessionsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 23/11/23.
//

import Foundation
import SwiftUI

struct SessionsView: View {
    @State private(set) var sessions: [SessionItem] = []
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                LazyVStack(spacing: 12, content: {
                    ForEach(sessions) { item in
                        sessionView(item)
                            .padding(.horizontal, Padding.medium)
                    }
                }).scrollable()
            }
        }
        .navigationTitle("Active sessions")
        .onAppear {
            getSessions()
        }
    }
    
    private func sessionView(_ session: SessionItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.agent ?? "")
                .font(.system(size: 13, weight: .semibold))
            
            Text("Driver: \(session.driverId ?? "")")
                .font(.system(size: 12, weight: .regular))
            
            HStack {
                Text(session.ip ?? "")
                Spacer()
                Text(session.beautifiedDateTime)
            }
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(Color.init(uiColor: .secondaryLabel))
        }
        .padding(Padding.medium * 2 / 3)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.init(uiColor: .secondarySystemBackground))
        )
    }
    
    private func getSessions() {
        isLoading = true
        Task {
            let _sessions = await MainService.shared.getSessions()
            
            await MainActor.run {
                isLoading = false
                sessions = _sessions
            }
        }
    }
}
