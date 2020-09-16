//
//  BobbleShelfSwiftUIView.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 9/11/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import SwiftUI
import SceneKit
import bobbleFramework
import myBobblesFramework
import NotificationCenter

struct BobbleShelfSwiftUIView: View {
    
    var bobbles = [Bobble]()
    var myWonBobbles = [myBobbles]()
    
    init(bobbles: [Bobble], myWonBobbles: [myBobbles]) {
        self.bobbles = bobbles
        self.myWonBobbles = myWonBobbles
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(minimum: 70, maximum: 140), spacing: 22, alignment: .top),
                            GridItem(.flexible(minimum: 70, maximum: 140), spacing: 22, alignment: .top),
                            GridItem(.flexible(minimum: 70, maximum: 140), spacing: 22, alignment: .top),
                            GridItem(.flexible(minimum: 70, maximum: 140), spacing: 22, alignment: .top)
                        ], spacing: 16, content: {
                            ForEach(myWonBobbles, id: \.self) { wonBobble in
                                ForEach(bobbles, id: \.self) { bobble in
                                    if(wonBobble.id == bobble.id) {
                                        bobbleInfoView(bobble: bobble)
                                    }
                                }
                            }
                        }).padding(.horizontal, 12)
                    }.navigationBarTitle("Bobbles")
            }
        }
//        .background(
//            Image("bookshelf")
//                .resizable()
//                .scaledToFill()
//        )
    }
    
}

struct bobbleInfoView: View {
    
    let bobble: Bobble
    
    @State var isPresentingModal = false
    
    var body: some View {
        Button(action: { self.isPresentingModal = true }) {
            VStack(alignment: .center, spacing: 4) {
                
                Image(bobble.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(60)
                    .overlay(RoundedRectangle(cornerRadius: 60)
                                .stroke(Color.blue, lineWidth: 4))
                    .shadow(radius: 6)
                
                Text(bobble.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                
                Spacer()
            }
        }
        .sheet(isPresented: $isPresentingModal, content: {
            bobbleDetailView(bobble: bobble, isPresentingModal: self.$isPresentingModal)
        })
    }
}

struct bobbleDetailView: View {
    
    let bobble: Bobble
    
    @Binding var isPresentingModal: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 12) {
                Text(bobble.name)
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 14)
                
                Image(systemName: "xmark.circle.fill")
                    .padding(.top)
                    .foregroundColor(Color.primary)
                    .onTapGesture {
                        withAnimation {
                            self.isPresentingModal.toggle()
                        }
                    }.animation(.none)
                
            }
                    
            if #available(iOS 14.0, *) {
                SceneView(scene: SCNScene(named: "donut.dae"), options: [ .autoenablesDefaultLighting, .allowsCameraControl ])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.3)
            }
            
            HStack {
                VStack {
                    Text("Rarity")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    Text(bobble.probability)
                        .font(.system(size: 16, weight: .bold))
                        .padding(.top, 1)
                        .padding(.bottom)
                }
                .padding()
                
                Divider().frame(height:80)
                
                HStack() {
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.Name("dismissSwiftUI"), object: nil)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .padding(.trailing, 4)
                        Text("Share")
                            .fontWeight(.semibold)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
                    .padding(.horizontal, 12)
                    
                }
            }

            VStack() {
                Text("Description")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.all, 10)
                Text(bobble.bobbleDescription)
                    .font(.system(size: 16, weight: .light))
                    .padding(.bottom, 10)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            Spacer()
        }.padding(.bottom, 16)
    }
}
