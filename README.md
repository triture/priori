![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat) ![Haxelib Version](https://img.shields.io/github/tag/triture/priori.svg?style=flat&label=haxelib)

# Priori

Build Single Page Application only using Haxe? Priori is the answer.

Priori helps you to create cross-browser web apps for desktops, tablets and smartphones using all benefits of the modern, high level, strictly typed programming language that you already know - and love.

## Simple to use
If you are familiar with OpenfFL, you will feel at home. Otherwise, you can check our [example project](https://github.com/triture/priori-example) to start your experimentations.

**Create New Project**
```
haxelib run priori create
```

**Compile Project**
```
haxelib run priori build
```
Optional Parameters:
- -f : priori.json file name
- -p : source path
- -D : Any -D flag will be passed to the haxe compiler

## Instalation
Requires [Haxe](http://haxe.org) 3.2.1+.

* **Step one:** install jQueryExtern lib via [haxelib](http://haxe.org/doc/haxelib/using_haxelib): `haxelib install jQueryExtern`
* **Step two:** install Priori lib: `haxelib install priori`

You can also install aditional priori libs:
- [Bootstrap for Priori](https://github.com/triture/priori-bootstrap): `haxelib install priori-bootstrap`  
- [Font Awesome for Priori](https://github.com/triture/priori-fontawesome): `haxelib install priori-fontawesome`  
- [Scene Manager for Priori](https://github.com/triture/priori-scenemanager): `haxelib install priori-scenemanager`  

## Priori Example Project
Check out some Priori [examples](https://github.com/triture/priori-example).

## Priori Roadmap for 1.0.0 Release Version
- Full Documentation
- Rotation property for PriDisplay
- Scale property for PriDisplay
- 9 Slice Images
- Background Images
- Better Border Support (Current version is buggy)
- Full compatibilty for Android and IOs devices
- Youtube, Vimeo and other video streaming (?) support
- Better performance for PriDataGrid
- Fix scroller on mobile devices
- Remove JQuery dependency for better performance
- Several bug fixes

## Changelog
### 0.0.3 - 05/08/2016
- Bugfix : cannot get values from disabled form elements
- Improvements : Better border support. * Still need more tests.
- Change Class names :
    - BorderStyle to PriBorderStyle
    - BorderType to PriBorderType

### 0.0.4 - 05/10/2016
- Bugfix: Wrong detection for android devices;
- Bugfix: Audio not loading on ios devices;
