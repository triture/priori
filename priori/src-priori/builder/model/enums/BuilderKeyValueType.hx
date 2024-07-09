package builder.model.enums;

enum abstract BuilderKeyValueType(String) {
    var STRING = 'String';
    var DYNAMIC = 'Dynamic';
    var LITERAL = 'Literal';
    var PAINT = 'Paint';

    @:from
    public static function fromString(value:String):BuilderKeyValueType {
        switch (value.toLowerCase()) {
            case 'string' | 's': return BuilderKeyValueType.STRING;
            case 'dynamic' | 'd': return BuilderKeyValueType.DYNAMIC;
            case 'literal' | 'l': return BuilderKeyValueType.LITERAL;
            case 'paint' | 'p': return BuilderKeyValueType.PAINT;
            case _ : return BuilderKeyValueType.DYNAMIC;
        }
    }
}