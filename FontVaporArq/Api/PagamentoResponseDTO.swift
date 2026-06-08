//
//  PagamentoResponseDTO.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 07/06/26.
//

struct PagamentoResponseDTO: Decodable {
    let status: String
    let mensagem: String
    let valor: Double

    var sucesso: Bool { status == "SUCESSO" }
}
