//
//  ForcePressGestureRecognizer.swift
//  ForcePressGestureRecognizer
//
//  Created by Thomas Zhao on 9/22/15.
//  Copyright © 2015 Thomas Zhao. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

/// A concrete subclass of UIGestureRecognizer that continuously recognizes 3D Touch gestures on supported iOS devices.
@available(iOS 9.0, *)
@objc(TRZForcePressGestureRecognizer)
public class ForcePressGestureRecognizer: UIGestureRecognizer {

    /**
      Relative force is defined as UITouch.force divided by UITouch.maximumPossibleForce.

      Valid values are in the range 0.0 to 1.0, inclusive. The default value is 0.5.
    */
    public var minimumRelativeForceRequired: CGFloat = 0.5 {
        didSet {
            if minimumRelativeForceRequired < 0 {
                minimumRelativeForceRequired = 0
            } else if minimumRelativeForceRequired > 1 {
                minimumRelativeForceRequired = 1
            }
        }
    }

    /**
      The number of fingers that must be pressed on the view for the gesture to be recognized.

      The default number of fingers is 1.
    */
    public var numberOfTouchesRequired: Int = 1 {
        didSet {
            if numberOfTouchesRequired < 1 {
                numberOfTouchesRequired = 1
            }
        }
    }

    /**
      While the state of the recognizer is Changed, contains the relative forces of the current touches.
      This value is otherwise nil.
    */
    public var relativeForces:[CGFloat]?

    /**
      The average relative force among all current touches, or 0 if the state of the recognizer is not Changed.
    */
    public var averageRelativeForce: CGFloat {
        if let forces = self.relativeForces {
            return forces.reduce(0, combine: +) / CGFloat(forces.count)
        }
        return 0
    }

    private var inProgress:Bool { return state == .Began || state == .Changed }
    private lazy var currentTouches = Set<UITouch>()

    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)

        relativeForces = nil

        currentTouches.unionInPlace(touches)

        //We only start recognizing if *exactly* numberOfTouchesRequired of touches begin simultaneously
        if !inProgress && currentTouches.count == touches.count && currentTouches.count == numberOfTouchesRequired {
            state = .Began
        } else if inProgress {
            currentTouches.removeAll()
            state = .Cancelled
        }

    }

    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)

        if inProgress {
            relativeForces = touches.map({ $0.force / $0.maximumPossibleForce })

            let numberOfTouchesSuccessful = relativeForces!.filter({ $0 > minimumRelativeForceRequired }).count

            if numberOfTouchesSuccessful == numberOfTouchesRequired {
                currentTouches.removeAll()
                state = .Ended
            } else {
                state = .Changed
            }
        }
    }

    public override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)

        if inProgress {
            currentTouches.removeAll()
            relativeForces = nil
            state = .Cancelled
        } else {
            currentTouches.subtractInPlace(touches)
        }
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)

        if inProgress {
            currentTouches.removeAll()
            relativeForces = nil
            state = .Cancelled
        } else {
            currentTouches.subtractInPlace(touches)
        }
    }
}