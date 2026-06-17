//
//  ContentView.swift
//  HeroAnimation
//
//  Created by IT-SSP on 17/06/26.
//

import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let description: String
}

struct ContentView: View {

    @Namespace private var animation
    @State private var selectedImage: String?
    @State private var showDetails = false
    @State private var animateList = false
    @GestureState private var dragOffset: CGSize = .zero

    let products: [Product] = [
        Product(
            imageName: "image",
            name: "iPhone 16 Pro",
            description: "Apple flagship smartphone with A-series chip, titanium design, and advanced camera system."
        ),
        Product(
            imageName: "image2",
            name: "MacBook Pro",
            description: "High-performance laptop designed for development, design, and professional workflows."
        ),
        Product(
            imageName: "image3",
            name: "Apple Watch Ultra",
            description: "Rugged smartwatch with GPS, health tracking, and long battery life."
        ),
        Product(
            imageName: "image4",
            name: "AirPods Pro",
            description: "Wireless earbuds with active noise cancellation and immersive audio."
        )
    ]

    var body: some View {
        ZStack {

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(products) { product in
                        HStack(spacing: 16) {
                            if selectedImage != product.imageName {
                                Image(product.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .shadow(radius: 4)
                                    .hoverEffect(.lift)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .matchedGeometryEffect(id: product.imageName, in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.clear)
                                    .frame(width: 80, height: 80)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.name)
                                    .font(.headline)
                                    .fontWeight(.semibold)

                                Text(product.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .scaleEffect(animateList ? 1 : 0.95)
                        .opacity(animateList ? 1 : 0)
                        .offset(y: animateList ? 0 : 20)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.85)
                            .delay(Double(products.firstIndex(where: { $0.id == product.id }) ?? 0) * 0.08),
                            value: animateList
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                                selectedImage = product.imageName
                                showDetails = true
                            }
                        }
                    }
                }
                .padding(.vertical)
                .onAppear {
                    animateList = true
                }
            }

            if let imageName = selectedImage,
               let product = products.first(where: { $0.imageName == imageName }) {
                Color.black
                    .opacity(showDetails ? max(0.2, 0.6 - abs(dragOffset.height) / 500) : 0)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.18), value: showDetails)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: imageName, in: animation)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(radius: 10)
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset) { value, state, _ in
                                        state = value.translation
                                    }
                                    .onEnded { value in
                                        if value.translation.height > 120 {
                                            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                                                showDetails = false
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                selectedImage = nil
                                            }
                                        }
                                    }
                            )

                        HStack {
                            VStack(spacing: 8) {
                                Capsule()
                                    .fill(.secondary.opacity(0.4))
                                    .frame(width: 40, height: 5)

                                Text("⬇️ Swipe down to close")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button {
                                withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                                    showDetails = false
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    selectedImage = nil
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Text(product.name)
                            .font(.system(size: 34, weight: .bold))
                            .fontWeight(.bold)
                            .opacity(showDetails ? 1 : 0)
                            .offset(y: showDetails ? 0 : 30)
                            .animation(.easeInOut(duration: 0.22), value: showDetails)

                        HStack(spacing: 4) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }

                            Text("4.9")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Text(product.description + "\n\nExperience premium quality, cutting-edge technology, and elegant design crafted for everyday use.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .opacity(showDetails ? 1 : 0)
                            .offset(y: showDetails ? 0 : 40)
                            .animation(.easeInOut(duration: 0.22).delay(0.03), value: showDetails)

                        Button("Buy Now • $999") {
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .opacity(showDetails ? 1 : 0)
                        .offset(y: showDetails ? 0 : 50)
                        .animation(.easeInOut(duration: 0.22).delay(0.05), value: showDetails)

                        Button("Add to Cart") {
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .opacity(showDetails ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: showDetails)
                .allowsHitTesting(showDetails)
            }
        }
    }
}

#Preview {
    ContentView()
}
