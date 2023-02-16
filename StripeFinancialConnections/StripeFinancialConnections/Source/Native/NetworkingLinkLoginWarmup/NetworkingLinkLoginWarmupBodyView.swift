//
//  NetworkingLinkLoginWarmupBodyView.swift
//  StripeFinancialConnections
//
//  Created by Krisjanis Gaidis on 2/6/23.
//

import Foundation
@_spi(STP) import StripeCore
@_spi(STP) import StripeUICore
import UIKit

@available(iOSApplicationExtension, unavailable)
final class NetworkingLinkLoginWarmupBodyView: UIView {

    private let didSelectContinue: () -> Void

    init(
        email: String,
        didSelectContinue: @escaping (() -> Void),
        didSelectSkip: @escaping (() -> Void)
    ) {
        self.didSelectContinue = didSelectContinue
        super.init(frame: .zero)
        let verticalStackView = UIStackView(
            arrangedSubviews: [
                CreateContinueButton(
                    email: email,
                    didSelectContinue: didSelectContinue,
                    target: self
                ),
                CreateSkipButton(didSelectSkip: didSelectSkip),
            ]
        )
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 20
        addAndPinSubview(verticalStackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func didSelectContinueButton() {
        didSelectContinue()
    }
}

@available(iOSApplicationExtension, unavailable)
private func CreateContinueButton(
    email: String,
    didSelectContinue: @escaping () -> Void,
    target: UIView
) -> UIView {
    let horizontalStack = UIStackView(
        arrangedSubviews: [
            CreateContinueButtonLabelView(email: email),
            CreateArrowIconView(),
        ]
    )
    horizontalStack.axis = .horizontal
    horizontalStack.alignment = .center
    horizontalStack.spacing = 12
    horizontalStack.isLayoutMarginsRelativeArrangement = true
    horizontalStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
        top: 12,
        leading: 16,
        bottom: 12,
        trailing: 16
    )
    horizontalStack.layer.borderColor = UIColor.borderNeutral.cgColor
    horizontalStack.layer.borderWidth = 1
    horizontalStack.layer.cornerRadius = 8

    let tapGestureRecognizer = UITapGestureRecognizer(
        target: target,
        action: #selector(NetworkingLinkLoginWarmupBodyView.didSelectContinueButton)
    )
    horizontalStack.addGestureRecognizer(tapGestureRecognizer)

    return horizontalStack
}

private func CreateContinueButtonLabelView(email: String) -> UIView {
    let continueLabel = UILabel()
    continueLabel.text = "Continue as"
    continueLabel.font = .stripeFont(forTextStyle: .captionTightEmphasized)
    continueLabel.textColor = .textSecondary

    let emailLabel = UILabel()
    emailLabel.text = email
    emailLabel.font = .stripeFont(forTextStyle: .bodyEmphasized)
    emailLabel.textColor = .textPrimary

    let verticalStackView = UIStackView(
        arrangedSubviews: [
            continueLabel,
            emailLabel,
        ]
    )
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 0
    return verticalStackView
}

private func CreateArrowIconView() -> UIView {
    let imageView = UIImageView(image: Image.arrow_right.makeImage(template: true))
    imageView.tintColor = .textBrand
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        imageView.widthAnchor.constraint(equalToConstant: 16),
        imageView.heightAnchor.constraint(equalToConstant: 16),
    ])
    return imageView
}

@available(iOSApplicationExtension, unavailable)
private func CreateSkipButton(
    didSelectSkip: @escaping () -> Void
) -> UIView {
    let skipLabel = ClickableLabel(
        font: .stripeFont(forTextStyle: .captionTight),
        boldFont: .stripeFont(forTextStyle: .captionTightEmphasized),
        linkFont: .stripeFont(forTextStyle: .captionTightEmphasized),
        textColor: .textSecondary
    )
    skipLabel.setText(
        "Not you? [Continue without signing in](stripe://fakeurl)",
        action: { _ in
            didSelectSkip()
        }
    )
    return skipLabel
}

#if DEBUG

import SwiftUI

@available(iOSApplicationExtension, unavailable)
private struct NetworkingLinkLoginWarmupBodyViewUIViewRepresentable: UIViewRepresentable {

    func makeUIView(context: Context) -> NetworkingLinkLoginWarmupBodyView {
        NetworkingLinkLoginWarmupBodyView(
            email: "test@stripe.com",
            didSelectContinue: {},
            didSelectSkip: {}
        )
    }

    func updateUIView(_ uiView: NetworkingLinkLoginWarmupBodyView, context: Context) {}
}

@available(iOSApplicationExtension, unavailable)
struct NetworkingLinkLoginWarmupBodyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            Spacer()
            NetworkingLinkLoginWarmupBodyViewUIViewRepresentable()
                .frame(maxHeight: 200)
                .padding()
            Spacer()
        }
    }
}

#endif