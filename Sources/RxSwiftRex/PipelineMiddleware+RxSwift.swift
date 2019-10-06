import Foundation
import RxSwift
import SwiftRex

extension PipelineMiddleware {
    public static func rx(
        actionTransformer: @escaping ((Observable<(ActionType, StateType)>) -> Observable<ActionType>) = { _ in
            .empty()
        }
    ) -> PipelineMiddleware {
        return .init(
            actionTransformer: { actionPublisher in
                actionTransformer(actionPublisher.asObservable())
                    .asPublisher()
                    .assertNoFailure()
            },
            actionSubject: { SubjectType(unfailablePublishSubject: PublishSubject()) },
            subscriptionCollection: DisposeBag.init
        )
    }
}
