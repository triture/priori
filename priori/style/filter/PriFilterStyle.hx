package priori.style.filter;

class PriFilterStyle {

    /**
    * Applies a blur effect to PriDisplay. A larger value will create more blur.
    *
    * `default : 0`
    **/
    public var blur:Float;

    /**
    * Adjusts the brightness of the PriDisplay.<br>
    * - `0` will make the object completely black.<br>
    * - `1` represents the original PriDisplay rendering.<br>
    * - Values over 1 will provide brighter results.
    *
    * `default : 1`
    **/
    public var brightness:Float;

    /**
    * Adjusts the contrast of the PriDisplay.<br>
    * - `0` will make the object completely black.<br>
    * - `1` represents the original PriDisplay rendering.<br>
    * - Values over 1 will provide less contrast.
    *
    * `default : 1`
    **/
    public var contrast:Float;

    /**
    * Converts the PriDisplay to grayscale.<br>
    * - `0` represents the original rendering.<br>
    * - `1` will make the PriDisplay completely gray.<br>
    *
    * `default : 0`
    **/
    public var grayscale:Float;

    /**
    * Applies a hue modification on colors of the PriDisplay.<br>
    * - `0` and `1` represents the original colors<br>
    * - Any value between 0 and 1, result a hue modification
    *
    * `default : 0`
    **/
    public var hue:Float;

    /**
    * Saturates the colors of the PriDisplay<br>
    * - `0` will make the colors completely un-saturated.<br>
    * - `1` represents the original colors.<br>
    * - Values over 1 provides super-saturated colors.
    *
    * `default : 1`
    **/
    public var saturate:Float;

    @:dox(hide)
    public function new() {
        this.blur = 0;
        this.brightness = 1;
        this.contrast = 1;
        this.grayscale = 0;
        this.hue = 1;
    }

    public function setBlur(value:Float):PriFilterStyle {
        this.blur = value;
        return this;
    }

    public function setBrightness(value:Float):PriFilterStyle {
        this.brightness = value;
        return this;
    }

    public function setContrast(value:Float):PriFilterStyle {
        this.contrast = value;
        return this;
    }

    public function setGrayscale(value:Float):PriFilterStyle {
        this.grayscale = value;
        return this;
    }

    public function setHue(value:Float):PriFilterStyle {
        this.hue = value;
        return this;
    }

    public function toString():String {
        var result:String = "";

        if (this.blur > 0) result += 'blur(${this.blur}px) ';
        if (this.brightness > 0) result += 'brightness(${this.brightness * 100}%) ';
        if (this.contrast > 0) result += 'contrast(${this.contrast * 100}%) ';
        if (this.grayscale > 0) result += 'grayscale${this.grayscale * 100}%) ';
        if (this.hue != 0) result += 'hue-rotate(${360 * this.hue}deg) ';
        if (this.saturate > 0) result += 'saturate(${this.saturate * 100}%) ';

        return result;
    }
}
