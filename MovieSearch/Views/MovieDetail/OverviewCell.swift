//
//  OverviewCell.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/4/25.
//

import SwiftUI

struct OverviewCell: View {
    let overviewText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4))
                .padding(.bottom, 16)
            Text("Overview".uppercased())
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.gray)
            Text(overviewText)
                .font(.body)
                .padding(.trailing, 20)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4))
                .padding(.top, 16)
        }
        .padding(.leading, 20)

    }
}

#Preview {
    OverviewCell(overviewText: "After the devastating events of Avengers: Infinity War, the universe is in ruins due to the efforts of the Mad Titan, Thanos. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos' actions and restore balance to the universe once and for all, no matter what consequences may be in store.")
}
