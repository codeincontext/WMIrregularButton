WMIrregularButton
=================

The standard UIButton is a rectangle. If you want a button of a different shape (eg: buttons around a central circle), you're kinda stuck. You could use a non-square button image, but the button's bounds would still be an outer rectangle - blocking elements behind from receiving clicks.

Well WMIrregularButton is a drop-in replacement for UIButton that is a little bit smarter. It uses your button image as a mask, so that the button's touch area is only the shape you've defined in your image. Anywhere on the button's image that's transparent will allow presses to pass through to controls behind.

Usage
-----

It's a subclass of UIButton, so you can just swap out the class name and it will do its job with no further configuration. It works with Interface Builder (and Storyboards) just as well as if you're manually creating your views.

All you have to do is set the button image. It determines the button's shape from the non-transparent areas in the image.
