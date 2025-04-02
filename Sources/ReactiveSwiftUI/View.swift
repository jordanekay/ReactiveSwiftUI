public import SwiftUI

@preconcurrency public import ReactiveSwift

public extension View {
    func onReceive<T: Sendable>(_ signal: Signal<T, Never>, perform action: @escaping (T) -> Void) -> some View {
        modifier(
            SignalModifier(
                signal: signal,
                action: action
            )
        )
    }
}

// MARK: -
private struct SignalModifier<T: Sendable> {
    private let signal: Signal<T, Never>
    private let action: (T) -> Void

    init(
        signal: Signal<T, Never>,
        action: @escaping (T) -> Void
    ) {
        self.signal = signal
        self.action = action
    }
}

extension SignalModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.task {
            let stream = AsyncStream { continuation in
                let disposable = signal.observe { event in
                    switch event {
                    case let .value(value):
                        continuation.yield(value)
                    case .completed, .interrupted:
                        continuation.finish()
                    }
                }

                continuation.onTermination = { _ in
                    disposable?.dispose()
                }
            }

            for await value in stream {
                action(value)
            }
        }
    }
}
