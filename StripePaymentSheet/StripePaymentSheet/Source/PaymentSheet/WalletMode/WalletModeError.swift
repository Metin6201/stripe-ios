//
//  WalletModeError.swift
//  StripePaymentSheet
//

import Foundation
@_spi(STP) import StripeCore
import StripePayments

public enum WalletModeError: Error {

    case errorFetchingSavedPaymentMethods(Error)

    /// setupIntent is invalid
    case setupIntentClientSecretInvalid

    /// Unable to fetch setup intent using client secret
    case setupIntentFetchError(Error)

    /// An unknown error.
    case unknown(debugDescription: String)

    /// Localized description of the error
    public var localizedDescription: String {
        return NSError.stp_unexpectedErrorMessage()
    }
}