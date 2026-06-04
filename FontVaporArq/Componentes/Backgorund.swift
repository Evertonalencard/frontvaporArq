//
//  Backgorund.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

struct BackgorundFile: View {
    var body: some View {
        VStack{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.doisReais, .cincoReais, .dezReais,.vinteReais,.cinquentaReais,.cemReais,.duzentosReais]), startPoint: .top, endPoint: .bottom)
                Rectangle()
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.duzentosReais)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.horizontal,20)
                    .padding(.top,40)
                    .blur(radius: 5)
                Rectangle()
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.cemReais)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.horizontal,20)
                    .padding(.top,100)
                    .blur(radius: 5)
                Rectangle()
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.doisReais)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(.horizontal,20)
                    .padding(.bottom,10)
                    .blur(radius: 5)
                Rectangle()
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.dezReais)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal,105)
                    .padding(.top,200)
                    .blur(radius: 5)
                Rectangle()
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.cincoReais)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.horizontal,60)
                    .padding(.bottom,102)
                    .blur(radius: 5)
                Rectangle()
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.vinteReais)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.leading,-40)
                    .padding(.bottom,40)
                    .blur(radius: 5)
                Rectangle()
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.cinquentaReais)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.horizontal,120)
                    .padding(.top,150)
                    .blur(radius: 5)
            }
            
        }.edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgorundFile()
}
