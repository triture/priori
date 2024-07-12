package priori.view.builder;

#if macro
import haxe.macro.Expr;
import builder.BuilderMacro;

@:noCompletion
class PriBuilderMacros {

    static public function build():Array<Field> {
        var build:BuilderMacro = new BuilderMacro();
        return build.getFields();
    }
    
}

#end