//
//  NotificationsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/11/23.
//

import Foundation
import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel: NotificationsViewModel = .init()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.notifications.isEmpty {
                    Text("no_notifications".localize)
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.notifications) { notification in
                            NotificationRow(notification: notification)
                                .padding(.horizontal, Padding.medium)
                        }
                    }.scrollable()
                }
            }
            .navigationBarTitle("notifications".localize)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.viewModel.onAppear()
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

struct NotificationRow: View {
    var notification: NotificationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(notification.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            Text(notification.body)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            HStack {
                Spacer()
                Text(notification.createdAt ?? "")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(Padding.medium * 2 / 3)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.init(uiColor: .secondarySystemBackground))
        )
    }
}

#Preview(body: {
    NotificationsView()
})
