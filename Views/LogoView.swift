//
//  LogoView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/23/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        ZStack {
            VStack {
                ForEach((1...6), id: \.self) { _ in
                    Rectangle()
                        .frame(width: 250, height: 2)
                        .padding(20)
                        .foregroundColor(.secondary)
                }
            }
            HStack {
                ForEach((1...6), id: \.self) { _ in
                    Rectangle()
                        .frame(width: 2, height: 250)
                        .padding(20)
                        .foregroundColor(.secondary)
                }
            }
            Text(" SV ")
                .font(.custom("Pacifico-Regular", size: 130))
                .foregroundColor(Color(red: 1.0, green: 0.41, blue: 0.41))
                .offset(x: -3.5, y: 0)
        }
    }
}


#Preview {
    LogoView()
}
