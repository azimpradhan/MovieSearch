//
//  SearchBar.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onTextChanged: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onChange(of: text) { _ in
                    onTextChanged()
                }

            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onTextChanged()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar(text: .constant(""), onTextChanged: {})
}
