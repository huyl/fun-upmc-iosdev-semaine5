Exercice «MiniNav»
====================

Semaine: 5

Cours: [Programmation sur iPhone et iPad]

[Programmation sur iPhone et iPad]:
https://www.france-universite-numerique-mooc.fr/courses/UPMC/18001/Trimestre_2_2014/about

Établissement: [Université Pierre & Marie Curie](http://www.upmc.fr/)

Plateforme de MOOC: [FUN](https://www.france-universite-numerique-mooc.fr/)

![Screen capture](MiniNavScreencap.gif)

Compilation
-----------

Pour compiler:

- Il faut ouvrir le fichier `owned-MiniNav.xcworkspace/`, pas
le project `owned-MiniNav.xcodeproj/`.
-  Il faut être sûr de bien sélectionner le projet `owned-MiniNav` en haut de
   la fenêtre avant de compiler.

Techniques
----------

Fonctionnalité :

- WebView
  - historique qui émule Chrome
  - remote fetch
  - local web page
- Toolbar
- AlertView
- Universelle
- Rotation
- iOS6 & 7 (handling of statusbar)

Structure :

- NSUserDefaults
- Organisation [Model-View-ViewModel
  (MVVM)](http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/)
- Style [Functional Reactive Programming](http://en.wikipedia.org/wiki/Functional_reactive_programming) au travers de ReactiveCocoaA
  - Highlight: button is enabled based on state of some property
  - Highlight: conversion of delegate selector call into a signal
- L'interface est construise programmatiquement; pas de Storyboard / Interface Builder
- Auto-Layout
- ARC, à cause de ReactiveCocoa et presque [tout le
  monde](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml?showone=Automatic_Reference_Counting__ARC_#Automatic_Reference_Counting__ARC_) l'utilise.
- Notation pointée (dot notation), parce que c'est idiomatique (comme l'explique
  [Google](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml?showone=Properties#Properties) et 
  [NY
  Times](https://github.com/NYTimes/objective-c-style-guide#dot-notation-syntax))

Librairies :

- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) :
pour UI binding et le style Functional Reactive Programming
- [Masonry](https://github.com/cloudkite/Masonry) :
pour créer facilement les contraintes pour Auto-Layout
- [cocoapods](http://cocoapods.org/) : pour gérer les paquets comme Masonry

Credits
-------

Some icons by
[pixeden](http://www.pixeden.com/media-icons/tab-bar-icons-ios-7).

License
-------

The MIT License (MIT)

Copyright (c) 2014 huyl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
