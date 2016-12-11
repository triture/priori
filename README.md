![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat) ![Haxelib Version](https://img.shields.io/github/tag/triture/priori.svg?style=flat&label=haxelib)

![PRIORI](http://priori.triture.com/wiki/priorilogo.png)

Build Single Page Application only using Haxe? Priori is the answer.

Priori helps you to create cross-browser web apps for desktops, tablets and smartphones using all benefits of the modern, high level, strictly typed programming language that you already know - and love.

## Demonstration
- Live version: (http://priori.triture.com/example/)
- Example project on github: (https://github.com/triture/priori-example)

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

## Documentation
Check the Priori api documentation ***under construction*** on (http://priori.triture.com/dox).

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
- Full Documentation ** 02% Completed**
- ~~Rotation property for PriDisplay~~ **Done**
- ~~Scale property for PriDisplay~~ **Done**
- ~~9 Slice Images~~ **Done**
- ~~Shadow property~~ **Done**
- Background Images
- ~~Better Border Support (Current version is buggy)~~ **Done**
- Full compatibilty for Android and IOs devices
- Youtube, Vimeo and other video streaming (?) support
- ~~Better performance for PriDataGrid~~ **Done**
- ~~Fix scroller on mobile devices~~ **Done**
- Remove JQuery dependency for better performance
- Better accessibility for Priori Apps
- Better support for Mouse and Keyboard events
- Form Container
- Form validation support
- Several bug fixes

## Changelog
### 0.3.0 - 12/11/2016
- New Feature : Scale and Rotation
- Updated jQuery version to 2.2.1
- Keep jquery and dom reference after kill method

### 0.2.0 - 12/02/2016
- New Feature : Shadow property
- New Feature : PressEnter event for form elements
- New Feature : Tooltip property
- New Feature : Mouse enable / disable property
- New Feature : selected index property for combo box
- New Feature : PriFormTextArea
- Improvements : Better way to handle parent objects
- Bugfix : Child visibility
- Several small fix

### 0.1.2 - 06/02/2016
- Bugfix : Wrong PriDataGrid max scroll value on Firefox.

### 0.1.1 - 05/27/2016
- Bugfix : Small fix for PriNineSlice  

### 0.1.0 - 05/25/2016  
- New Feature : PriNineSlice component for nine-sliced images! [WHAT IS IT?](http://rwillustrator.blogspot.com.br/2007/04/understanding-9-slice-scaling.html)  

### 0.0.5 - 05/18/2016  
- Improvements : Better performance for PriDataGrid - thousands of rows working fine [working fine](http://priori.triture.com/example)  
- Some smallfixs  

### 0.0.4 - 05/10/2016  
- Bugfix: Wrong detection for android devices  
- Bugfix: Audio not loading on ios devices  

### 0.0.3 - 05/08/2016  
- Bugfix : cannot get values from disabled form elements  
- Improvements : Better border support. * Still need more tests  
- Change Class names :  
    - BorderStyle to PriBorderStyle  
    - BorderType to PriBorderType  

