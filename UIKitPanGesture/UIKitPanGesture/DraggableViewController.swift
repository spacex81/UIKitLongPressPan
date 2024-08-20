import UIKit

class DraggableViewController: UIViewController {

    private let draggableView = UIView()
    private var longPressRecognized = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up draggable view
        draggableView.backgroundColor = .blue
        draggableView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        draggableView.layer.cornerRadius = 50
        view.addSubview(draggableView)
        
        // Add gesture recognizers
        setupGestures()
    }

    private func setupGestures() {
        // Long press gesture recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        draggableView.addGestureRecognizer(longPressRecognizer)
        
        // Pan gesture recognizer
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        draggableView.addGestureRecognizer(panRecognizer)
        
        // Enable simultaneous gesture recognition
        draggableView.gestureRecognizers?.forEach {
            $0.delegate = self
        }
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPressRecognized = true
        } else if gesture.state == .ended {
            longPressRecognized = false
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard longPressRecognized else { return }

        let translation = gesture.translation(in: view)
        guard let draggedView = gesture.view else { return }
        
        if gesture.state == .began || gesture.state == .changed {
            draggedView.center = CGPoint(x: draggedView.center.x + translation.x,
                                         y: draggedView.center.y + translation.y)
            gesture.setTranslation(.zero, in: view)
        }
    }
}

extension DraggableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
