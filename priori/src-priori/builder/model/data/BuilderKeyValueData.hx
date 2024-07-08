package builder.model.data;

abstract BuilderKeyValueData({key:String, value:String}) {
 
    public function new(key:String, value:String) {
        this = {key: key, value: value};
    }

    public function getKey():String return this.key;
    public function getValue():String return this.value;
    
}