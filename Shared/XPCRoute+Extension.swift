//
//  XPCRoute+Extension.swift
//  Mist
//
//  Created by TinHocThucHanh on 21/6/2022.
//

import Foundation
import SecureXPC

extension XPCRoute {
    static let commandRoute: XPCRouteWithMessageWithReply<HelperToolCommandRequest, HelperToolCommandResponse> = XPCRoute.named("process")
        .withMessageType(HelperToolCommandRequest.self)
        .withReplyType(HelperToolCommandResponse.self)
}
