package controller;

import helper.Helper;
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
        result.gitHash = this.getGitHash();

        if (Validation.isString(json.project_name)) result.name = StringTools.trim(json.project_name);
        if (Validation.isString(json.lang)) result.lang = StringTools.trim(json.lang);
        if (Validation.isString(json.output)) result.output = StringTools.trim(json.output);
        if (Validation.isString(json.template)) result.template = StringTools.trim(json.template);
        if (Validation.isString(json.main)) result.main = StringTools.trim(json.main);
        if (Validation.isString(json.hash)) result.gitHash = StringTools.trim(json.hash);

        result.meta = result.meta.concat(Validation.parseStringArray(json.meta));
        result.link = result.link.concat(Validation.parseStringArray(json.link));
        result.dependencies = result.dependencies.concat(Validation.parseStringArray(json.dependencies));
        result.src = result.src.concat(Validation.parseStringArray(json.src));

        return result;
    }

    private function getGitHash():String {
        try {
            if (!PrioriRunModel.getInstance().args.noHash) {
                var projectPath:String = PrioriRunModel.getInstance().args.currPath;

                var result:String = Helper.g().process.run("git", ["--git-dir", projectPath + "/.git", "rev-parse", "HEAD"]);
                if (result != null && result.length == 0) return null;
                result = result.split("\n").join("").split(" ").join("");
                result = StringTools.urlEncode(result);

                return result;
            }
        } catch (e:Dynamic) {}

        return null;
    }
}
