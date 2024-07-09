package builder.model.enums;

enum abstract BuilderKeyValueType(String) {
    var STRING = 'String';
    var DYNAMIC = 'Dynamic';
    var LITERAL = 'Literal';

    @:from
    public static function fromString(value:String):BuilderKeyValueType {
        switch (value.toLowerCase()) {
            case 'string': return BuilderKeyValueType.STRING;
            case 'dynamic': return BuilderKeyValueType.DYNAMIC;
            case 'literal': return BuilderKeyValueType.LITERAL;
            case _ : return BuilderKeyValueType.DYNAMIC;
        }
    }
}