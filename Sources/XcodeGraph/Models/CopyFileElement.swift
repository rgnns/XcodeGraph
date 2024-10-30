import Foundation
import Path

public enum CopyFileElement: Equatable, Hashable, Codable, Sendable {
    case file(path: AbsolutePath, condition: PlatformCondition? = nil, codeSignOnCopy: Bool = false)
    case folderReference(path: AbsolutePath, condition: PlatformCondition? = nil, codeSignOnCopy: Bool = false)
    case product(dependency: TargetDependency, condition: PlatformCondition? = nil, codeSignOnCopy: Bool = false)

    public var path: AbsolutePath {
        switch self {
        case let .file(path, _, _):
            return path
        case let .folderReference(path, _, _):
            return path
        case let .product(dependency, _, _):
            do {
                return try AbsolutePath(validating: "//\(dependency)gosh") // REVIEW: This is going to be a mess.
            } catch {
                fatalError("What the fuck are you making me do?")
            }
        }
    }

    public var isReference: Bool {
        switch self {
        case .file:
            return false
        case .folderReference:
            return true
        case .product:
            return true // REVIEW: What's a reference?
        }
    }

    public var condition: PlatformCondition? {
        switch self {
        case let .file(_, condition, _), let .folderReference(_, condition, _), let .product(_, condition, _):
            return condition
        }
    }

    public var codeSignOnCopy: Bool {
        switch self {
        case let .file(_, _, codeSignOnCopy), let .folderReference(_, _, codeSignOnCopy), let .product(_, _, codeSignOnCopy):
            return codeSignOnCopy
        }
    }
}
