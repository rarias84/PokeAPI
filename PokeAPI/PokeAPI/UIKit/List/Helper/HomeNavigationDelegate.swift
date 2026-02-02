import UIKit

final class HomeNavigationDelegate: NSObject, UINavigationControllerDelegate {
    var selectedCellFrame: CGRect?

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = selectedCellFrame else {
            return nil
        }

        return PokemonZoomAnimator(isPresenting: operation == .push, originFrame: frame)
    }
}

final class PokemonZoomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let originFrame: CGRect

    init(isPresenting: Bool, originFrame: CGRect) {
        self.isPresenting = isPresenting
        self.originFrame = originFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.45
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let isPush = isPresenting

        let originVC = isPush ? fromVC : toVC
        let destinationVC = isPush ? toVC : fromVC

        let initialFrame = isPush ? originFrame : destinationVC.view.frame
        let finalFrame = isPush ? destinationVC.view.frame : originFrame

        let snapshot = destinationVC.view.snapshotView(afterScreenUpdates: true) ?? UIView()
        snapshot.frame = initialFrame
        snapshot.layer.cornerRadius = isPush ? 12 : 0
        snapshot.layer.masksToBounds = true

        if isPush {
            destinationVC.view.isHidden = true
            container.addSubview(destinationVC.view)
            container.addSubview(snapshot)
        } else {
            originVC.view.isHidden = true
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
            container.addSubview(snapshot)
        }

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.3,
            options: [.curveEaseInOut]
        ) {
            snapshot.frame = finalFrame
        } completion: { _ in
            originVC.view.isHidden = false
            destinationVC.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
