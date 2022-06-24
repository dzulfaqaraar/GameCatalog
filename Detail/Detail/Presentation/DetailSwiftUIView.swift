//
//  DetailSwiftUIView.swift
//  Detail
//
//  Created by Dzulfaqar on 19/06/22.
//

import Common
import SDWebImageSwiftUI
import SwiftUI

struct DetailSwiftUIView: View {
    typealias GetType = GetFavoriteDetailUseCase<GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>
    typealias InsertType = InsertFavoriteDetailUseCase<InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>
    typealias DeleteType = DeleteFavoriteDetailUseCase<DeleteFavoriteDetailRepository<DetailLocaleDataSource>>
    typealias LoadType = LoadDataDetailUseCase<LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>

    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: DetailViewModel<GetType, InsertType, DeleteType, LoadType>

    init(viewModel: DetailViewModel<GetType, InsertType, DeleteType, LoadType>) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                imageBackground(width: geometry.size.width, height: geometry.size.height)

                VStack(alignment: .leading, spacing: 0) {
                    HStack { Spacer() }
                        .frame(height: viewModel.getTopInsets())

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack { Spacer() }
                                .frame(height: geometry.size.height * 0.3)

                            if !viewModel.isLoadingData && !viewModel.isErrorAlert {
                                VStack(alignment: .leading, spacing: 20) {
                                    header

                                    HStack(alignment: .top, spacing: 0) {
                                        developer(width: geometry.size.width * 0.5)
                                        publisher(width: geometry.size.width * 0.5)
                                    }

                                    genres

                                    HStack(alignment: .top, spacing: 0) {
                                        releaseDate(width: geometry.size.width * 0.5)
                                        rating(width: geometry.size.width * 0.5)
                                    }

                                    description
                                }
                                .padding()
                                .background(.black.opacity(0.8))
                                .cornerRadius(30, corners: [.topLeft, .topRight])
                            }
                        }
                        .alert(isPresented: $viewModel.isErrorAlert) {
                            Alert(
                                title: Text("info".localized()),
                                message: Text(viewModel.messageError),
                                primaryButton: .default(Text("try_again".localized()), action: {
                                    if viewModel.isErrorData == true {
                                        viewModel.loadDetail()
                                    } else if viewModel.isErrorData == false {
                                        viewModel.share()
                                    } else {
                                        dismiss()
                                    }
                                }),
                                secondaryButton: .destructive(Text("close".localized()), action: {
                                    dismiss()
                                })
                            )
                        }
                    }
                    .frame(height: geometry.size.height - viewModel.getTopInsets())
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(loading, alignment: .center)
        .onAppear {
            viewModel.loadDetail()
        }
    }
}

extension DetailSwiftUIView {
    var loading: some View {
        VStack {
            if viewModel.isLoadingData || viewModel.isLoadingShare {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(
                            tint: viewModel.isLoadingShare ? .white : .gray)
                        )
                        .scaleEffect(1.8)
                        .padding(.top, -40)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.center)
                .background(viewModel.isLoadingShare ? .gray.opacity(0.3) : .clear)
            }
        }
    }

    func imageBackground(width: CGFloat, height: CGFloat) -> some View {
        WebImage(url: URL(string: viewModel.detailData?.image ?? ""))
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
    }

    var header: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(viewModel.detailData?.name ?? "")
                .fontWeight(.bold)
                .font(.system(.largeTitle))
                .foregroundColor(.white)
                .padding(.trailing, 50)

            Spacer()

            Button(
                action: { viewModel.share() },
                label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32, alignment: .center)
                        .foregroundColor(.white)
                }
            )
            .padding(.trailing, 10)

            Button(
                action: { viewModel.favoriteGame() },
                label: {
                    Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32, alignment: .center)
                        .foregroundColor(.red)
                }
            )
        }
        .sheet(isPresented: $viewModel.isShare) {
            if let image = viewModel.loadedImage {
                DetailShareRepresentable(image: image)
            }
        }
    }
    
    func developer(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("developer_label".localized())
                .fontWeight(.bold)
                .font(.system(.headline))
                .foregroundColor(.white)

            Text(viewModel.detailData?.developersName ?? "")
                .font(.system(.body))
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: width, alignment: .topLeading)
    }

    func publisher(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("publisher_label".localized())
                .fontWeight(.bold)
                .font(.system(.headline))
                .foregroundColor(.white)

            Text(viewModel.detailData?.publishersName ?? "")
                .font(.system(.body))
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: width, alignment: .topLeading)
    }

    var genres: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("genres_label".localized())
                .fontWeight(.bold)
                .font(.system(.headline))
                .foregroundColor(.white)

            Text(viewModel.detailData?.genres ?? "")
                .font(.system(.body))
                .foregroundColor(.white)
        }
    }

    func releaseDate(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("release_date_label".localized())
                .fontWeight(.bold)
                .font(.system(.headline))
                .foregroundColor(.white)

            Text(viewModel.detailData?.released?.toDate() ?? "")
                .font(.system(.body))
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: width, alignment: .topLeading)
    }

    func rating(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("rating_label".localized())
                .fontWeight(.bold)
                .font(.system(.headline))
                .foregroundColor(.white)

            Text(String(format: "%.2f", viewModel.detailData?.rating ?? 0.0))
                .font(.system(.body))
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: width, alignment: .topLeading)
    }

    var description: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("description_label".localized())
                .fontWeight(.bold)
                .font(.system(.headline))
                .foregroundColor(.white)

            Text(viewModel.detailData?.descriptionRaw ?? "")
                .font(.system(.body))
                .foregroundColor(.white)
        }
    }
}
