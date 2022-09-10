//
//  main.swift
//  MistHelperTool
//
//  Created by TinHocThucHanh on 21/6/2022.
//

import Foundation
import SecureXPC

/// Helper Tool struct to run a command sent from the main application.
struct HelperToolCommandRunner {

    /// Run the requested command and return the status and output.
    ///
    /// - Parameters:
    ///   - request: A `HelperToolCommandRequest` struct containing the command to run with optional arguments.
    ///
    /// - Throws: A `MistError` if the command failed to execute.
    ///
    /// - Returns: A `HelperToolCommandResponse` struct containing the termination status, standard output and standard error.
    static func run(_ request: HelperToolCommandRequest) throws -> HelperToolCommandResponse {

        switch request.type {
        case .remove:

            guard let path: String = request.arguments.first else {
                return HelperToolCommandResponse(terminationStatus: 1, standardOutput: nil, standardError: "Invalid URL")
            }

            guard FileManager.default.fileExists(atPath: path) else {
                return HelperToolCommandResponse(terminationStatus: 0, standardOutput: nil, standardError: nil)
            }

            do {
                try FileManager.default.removeItem(atPath: path)
                return HelperToolCommandResponse(terminationStatus: 0, standardOutput: nil, standardError: nil)
            } catch {
                return HelperToolCommandResponse(terminationStatus: 1, standardOutput: nil, standardError: error.localizedDescription)
            }
        case .kill:
            ShellExecutor.shared.terminate()
            return HelperToolCommandResponse(terminationStatus: 0, standardOutput: nil, standardError: nil)
        default:
            let response: (terminationStatus: Int32, standardOutput: String?, standardError: String?) = try ShellExecutor.shared.execute(request.arguments, environment: request.environment)
            return HelperToolCommandResponse(terminationStatus: response.terminationStatus, standardOutput: response.standardOutput, standardError: response.standardError)
        }
    }
}

// launchd pid = 1
guard getppid() == 1 else {
    exit(1)
}

/// XPCServer used to monitor incoming requests
let server: XPCServer = try XPCServer.forThisBlessedHelperTool()
server.registerRoute(XPCRoute.commandRoute, handler: HelperToolCommandRunner.run(_:))
server.setErrorHandler { error in
    if case .connectionInvalid = error {
        // do nothing
    } else {
        NSLog("error: \(error)")
    }
}
server.startAndBlock()
