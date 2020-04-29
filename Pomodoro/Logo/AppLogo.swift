//
//  AppLogo.swift
//  Pomodoro
//
//  Created by Ramill Ibragimov on 29.04.2020.
//  Copyright © 2020 Ramill Ibragimov. All rights reserved.
//

import SwiftUI

struct AppLogo: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("b"), Color("r")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            Image(systemName: "timer")

                .resizable()
                .frame(width: 900, height: 900)
                .foregroundColor(.white)
            
                .opacity(0.3)
                .shadow(color: .white, radius: 100, x: 30, y: 30)
            
            Text("P")
                .font(.system(size: 1950))
                .bold()
                .opacity(0.6)
                .offset(x: -60, y: 225)
            
        }
    }
}

struct AppLogo_Previews: PreviewProvider {
    static var previews: some View {
        AppLogo()
    }
}
