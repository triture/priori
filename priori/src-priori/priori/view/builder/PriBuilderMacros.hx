package priori.view.builder;

#if macro
import haxe.macro.Expr;
import builder.BuilderMacro;
#end

@:noCompletion
class PriBuilderMacros {

    #if macro
    
    static public function build():Array<Field> {
        var build:BuilderMacro = new BuilderMacro();
        return build.getFields();
    }

    // private static function reorderAttributes(node:Xml):Array<String> {
    //     var att:Iterator<String> = node.attributes();
    //     var result:Array<String> = [];

    //     for (a in att) result.push(a);
        
    //     result.sort(function(a:String, b:String):Int {
    //         if (a < b) return -1;
    //         else if (a > b) return 1;
    //         else return 0;
    //     });
        
    //     for (i in 0 ... result.length) {
    //         if (result[i].indexOf(":") == -1) continue;
    //         var value:Dynamic = node.get(result[i]);
    //         result[i] = result[i].substr(result[i].indexOf(":") + 1);
    //         node.set(result[i], value);
    //     }
        
    //     return result;
    // }

    #end
}
