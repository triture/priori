package helper;

class ArrayHelper {

    public static function indexOfByFieldValue<T>(a:Array<T>, field:String, fieldValue:Dynamic):Int {
        var i:Int = 0;
        var n:Int = a.length;
        var val:T = null;
        var result:Int = -1;

        while (i < n) {

            val = Reflect.getProperty(a[i], field);

            if (val == fieldValue) {
                result = i;
                i = n;
            }

            i++;
        }

        return result;
    }

    public static function getItemByFieldValue<T>(a:Array<T>, field:String, fieldValue:Dynamic):T {
        var index:Int = indexOfByFieldValue(a, field, fieldValue);
        var result:T = null;

        if (index > -1) {
            result = a[index];
        }

        return result;
    }
}
