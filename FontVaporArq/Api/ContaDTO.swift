//
//  ContaDTO.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//
import Foundation

struct ContaDTO: Codable {
    let id: UUID
    let nome: String
    let saldo: Double
    let tipo: String
}
