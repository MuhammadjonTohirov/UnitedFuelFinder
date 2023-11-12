//
//  StationCommentItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/11/23.
//

import Foundation
import SwiftUI

struct StationCommentItemView: View {
    var sender: String
    var comment: String
    var rate: Int
    var dateValue: String
    var canDelete: Bool = false
    
    var onClickDelete: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: Padding.small) {
            HStack {
                Text(sender)
                    .fontWeight(.medium)
                    .font(.system(size: 13, weight: .medium))
                
                Spacer()
                
                Button(action: {
                    self.onClickDelete?()
                }, label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                })
                .opacity(canDelete ? 1 : 0)
            }
            
            Text(comment)
                .fontWeight(.light)
                .font(.system(size: 12))
            
            HStack(spacing: 5) {
                RateView(rate: rate, canRate: false)
                    .frame(width: 80, height: 16)
                Spacer()
                Text(dateValue)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray).opacity(0.7)
            }
        }
        .padding(Padding.small)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.init(uiColor: .secondarySystemBackground))
        )
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.label.opacity(0.5))
                .opacity(canDelete ? 1 : 0)
        )
        .frame(maxHeight: 120)
    }
    
    func set(onClickDelete: @escaping () -> Void) -> Self {
        var v = self
        v.onClickDelete = onClickDelete
        return v
    }
}

#Preview {
    StationCommentItemView(sender: "a", comment: "b", rate: 2, dateValue: "c", canDelete: true)
        .padding()
}

extension StationCommentItem {
    var view: StationCommentItemView {
        .init(sender: self.senderValue, comment: self.comment, rate: self.rate, dateValue: self.dateValue, canDelete: self.canDelete)
    }
}
