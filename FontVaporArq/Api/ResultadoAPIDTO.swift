//
//  ResultadoAPIDTO.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 07/06/26.
//

import Foundation

struct ResultadoAPIDTO: Codable {
    let sucesso: Bool
    let id: UUID?
    let novoValor: Double?
    let erro: String?

    func toResultado() -> Resultado {
        if sucesso {
            return .sucesso(novoValor: novoValor ?? 0)
        }
        return .falha(erro: erro ?? "Erro desconhecido")
    }
}
