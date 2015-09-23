# TRZForcePressGestureRecognizer
A UIGestureRecognizer subclass that recognizes 3D/Force Touches on iPhone 6s (Plus). For some reason Apple doesn't provide one in UIKit.

## Warning!
Since the iPhone 6s hasn't been released yet and the simulator doesn't support Force Touch, I have no idea if this actually works or not. Use at your own risk.

## Usage
Copy ForcePressGestureRecognizer.swift to your project and use like any other UIGestureRecognizer subclass:

```swift
let forcePressRecognizer = ForcePressGestureRecognizer(target: self, action: "didRecognizeForcePress:")
view.addGestureRecognizer(forcePressRecognizer)
...
func didRecognizeForcePress(forcePressRecognizer: ForcePressGestureRecognizer) {
    if (forcePressRecognizer.state == .Ended) {
        //3D Touch recognized, do cool stuff
    }
}
```

To specify how hard the user has to press before the gesture is considered complete, specify the minimum relative force necessary:

```swift
forcePressRecognizer.minimumRelativeForce = 0.25
```

Relative force is defined as UITouch.force / UITouch.maximumPossibleForce, so it has a valid range of 0.0 to 1.0. The default value of minimumRelativeForce is 0.5 (though I'm not sure if that is reasonable or not).

## Advanced

You can specify how many fingers need to be placed for the gesture to kick in by setting the `numberOfTouchesRequired` property. If `numberOfTouchesRequired` is set to 2, for example, the user needs to press down simultaneously with exactly 2 fingers. Placing down additional fingers or removing fingers from the screen will cancel the gesture. In addition, *each finger* must be pressed past the minimum relative force for the gesture to complete.

Since this is a continuous gesture, you can get the relative forces while the gesture recognizer is in the changed state by reading from the relativeForces property. In the most common case of just one finger, use the `averageRelativeForce` property to determine how hard the user is pressing. See the sample project for more details.