//
//  APIHandler.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation



protocol RequestHandler {
    associatedtype RequestDataType
    func makeRequest(from data : RequestDataType) -> URLRequest?
    
}

protocol ResponseHandler{
    associatedtype ResponseDataType
    func parseResponse(data : Data , response : HTTPURLResponse) throws -> ResponseDataType
}



// APIHandler typealias for both RequestHandler And ResponseHandler
// this allows type to conform to both protocols at the same time

typealias APIHandler = RequestHandler & ResponseHandler
