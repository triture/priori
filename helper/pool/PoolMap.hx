package helper.pool;

class PoolMap<K, V> {

    private var keys:Array<K> = [];
    private var values:Array<Array<V>> = [];

    public function new() {

    }

    inline private function getKeyIndex(key:K):Int {
        return this.keys.indexOf(key);
    }

    public function getKeyOff(value:V):K {
        for (i in 0 ... this.values.length) {
            if (this.values[i].indexOf(value) > -1) {
                return this.keys[i];
                break;
            }
        }

        return null;
    }

    public function remove(key:K, value:V):Void {
        var index:Int = this.getKeyIndex(key);
        if (index == -1) return;
        this.values[index].remove(value);
    }

    public function exists(value:V):Bool {
        for (i in 0 ... this.values.length) if (this.values[i].indexOf(value) > -1) return true;
        return false;
    }

    public function add(key:K, value:V):Void {
        if (key == null || value == null) return; //throw "values can't be null";

        var index:Int = this.getKeyIndex(key);

        if (index == -1) {
            this.keys.push(key);
            this.values.push([value]);
        } else {
            if (this.values[index].indexOf(value) == -1) {
                this.values[index].push(value);
            }
        }
    }

    public function get(key:K):V {
        var index:Int = this.getKeyIndex(key);

        if (index == -1) return null;

        var itens:Array<V> = this.values[index];
        if (itens.length == 0) return null;

        return itens.shift();
    }
}