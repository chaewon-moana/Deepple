//
//  ContentView.swift
//  hackerton
//
//  Created by Cho Chaewon on 2023/08/17.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 32)
                .frame(width: 960, height: 635)
                .foregroundColor(.secondary)
                .overlay(
                    Text("Advertisement Area")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                )
            
            HStack{
                RoundedRectangle(cornerRadius: 32)
                    .frame(width: 464, height: 604)
                
                OrderButtonView()
            }
        }
        .foregroundColor(.gray)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
