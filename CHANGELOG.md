## 1.1.2
* Flutter and js package updates.

## 1.1.1

* Correction when building with CanvasKit.
  Previously, the script was injected automatically, but it didn't work when rendering with CanvasKit. To use it, you will need to manually inject it into the 'index.html'.

## 1.1.0

* Added a new widget that displays the camera's transparent background with a focus on the targeting for QR Code scanning.

## 1.0.2

* Fixed an issue when building for platforms other than Web that used the QRCodeWidget.
* Added conditional import to ensure the build is only for Web; otherwise, it will return a SizedBox.

## 1.0.1

* Create Flutter Web Plugin.
* Upgrade Flutter and Dart version.

## 1.0.0

* Initial release.
