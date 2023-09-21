package model;

enum abstract TokenTypes(String) from String to String {
    var NAME = "{project_name}";
    var LANG = "{lang}";
    var META = "{meta}";
    var LINK = "{link}";
    var PRIORI = "{priori}";
    var SEO = "{seo}";
}
