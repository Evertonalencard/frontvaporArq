//
//  CartaoDTO.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 07/06/26.
//

struct CartaoDTO: Codable {
    let id: Int64?
    let numero: String
    let cvv: String
    let validade: String
    let titular: String
    let limite: Double
    let ativo: Bool
}
