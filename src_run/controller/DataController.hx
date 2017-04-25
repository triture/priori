package controller;

import StringTools;
import model.PrioriDataVO;
import helper.Validation;

class DataController {

    public function new() {

    }

    public function parseData(json:Dynamic):PrioriDataVO {
        var result:PrioriDataVO = {};
        result.file = "";
        result.name = "PRIORI";
        result.lang = "en";
        result.meta = [];
        result.link = [];
        result.dependencies = [];
        result.src = [];
        result.output = "build";
        result.template = "template";
        result.main = "Main";

        if (Validation.isString(json.project_name)) result.name = StringTools.trim(json.project_name);
        if (Validation.isString(json.lang)) result.lang = StringTools.trim(json.lang);
        if (Validation.isString(json.output)) result.output = StringTools.trim(json.output);
        if (Validation.isString(json.template)) result.template = StringTools.trim(json.template);
        if (Validation.isString(json.main)) result.main = StringTools.trim(json.main);

        result.meta = result.meta.concat(Validation.parseStringArray(json.meta));
        result.link = result.link.concat(Validation.parseStringArray(json.link));
        result.dependencies = result.dependencies.concat(Validation.parseStringArray(json.dependencies));
        result.src = result.src.concat(Validation.parseStringArray(json.src));

        return result;
    }
}
