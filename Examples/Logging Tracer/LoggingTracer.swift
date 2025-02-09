/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

class LoggingTracer: Tracer {
    let tracerName = "LoggingTracer"

    var binaryFormat: BinaryFormattable = LoggingBinaryFormat()
    var textFormat: TextMapPropagator = W3CTraceContextPropagator()

    func spanBuilder(spanName: String) -> SpanBuilder {
        return LoggingSpanBuilder(tracer: self, spanName: spanName)
    }

    class LoggingSpanBuilder: SpanBuilder {
        private var tracer: Tracer
        private var isRootSpan: Bool = false
        private var spanContext: SpanContext?
        private var name: String

        init(tracer: Tracer, spanName: String) {
            self.tracer = tracer
            name = spanName
        }

        func startSpan() -> Span {
            if spanContext == nil, !isRootSpan {
                spanContext = OpenTelemetry.instance.contextProvider.activeSpan?.context
            }
            if spanContext != nil {
                return LoggingSpan(name: name, kind: .client)
            } else {
                return DefaultTracer.instance.spanBuilder(spanName: name).startSpan()
            }
        }

        func setParent(_ parent: Span) -> Self {
            spanContext = parent.context
            return self
        }

        func setParent(_ parent: SpanContext) -> Self {
            spanContext = parent
            return self
        }

        func setNoParent() -> Self {
            isRootSpan = true
            return self
        }

        func addLink(spanContext: SpanContext) -> Self {
            return self
        }

        func addLink(spanContext: SpanContext, attributes: [String: AttributeValue]) -> Self {
            return self
        }

        func setSpanKind(spanKind: SpanKind) -> Self {
            return self
        }

        func setStartTime(time: Date) -> Self {
            return self
        }

        func setAttribute(key: String, value: AttributeValue) -> Self {
            return self
        }

        func setActive(_ active: Bool) -> Self {
            return self
        }
    }
}
