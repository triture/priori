package priori.style.shadow;

class PriShadowPresets {

    public static var APPLE_SHADOW(get, null):Array<PriShadowStyle>;
    public static var PAPER_SHADOW(get, null):Array<PriShadowStyle>;
    public static var SLIM_SHADOW(get, null):Array<PriShadowStyle>;
    public static var SIMPLE_INNER_SHADOW(get, null):Array<PriShadowStyle>;


    private static function get_APPLE_SHADOW():Array<PriShadowStyle> {
        return [
            new PriShadowStyle()
            .setHorizontalOffset(0)
            .setVerticalOffset(8)
            .setBlur(30)
            .setSpread(-5)
            .setColor(0x000000)
            .setOpacity(0.7)
            .setType(PriShadowType.OUTLINE)
        ];
    }

    private static function get_PAPER_SHADOW():Array<PriShadowStyle> {
        return [
            new PriShadowStyle()
            .setHorizontalOffset(0)
            .setVerticalOffset(4)
            .setBlur(8)
            .setSpread(0)
            .setColor(0x000000)
            .setOpacity(0.2)
            .setType(PriShadowType.OUTLINE)

            ,

            new PriShadowStyle()
            .setHorizontalOffset(0)
            .setVerticalOffset(6)
            .setBlur(20)
            .setSpread(0)
            .setColor(0x000000)
            .setOpacity(0.2)
            .setType(PriShadowType.OUTLINE)
        ];
    }

    private static function get_SLIM_SHADOW():Array<PriShadowStyle> {
        return [
            new PriShadowStyle()
            .setHorizontalOffset(0)
            .setVerticalOffset(1)
            .setBlur(2)
            .setSpread(0.5)
            .setColor(0x000000)
            .setOpacity(0.3)
            .setType(PriShadowType.OUTLINE)
        ];
    }

    private static function get_SIMPLE_INNER_SHADOW():Array<PriShadowStyle> {
        return [
            new PriShadowStyle()
            .setHorizontalOffset(0)
            .setVerticalOffset(1)
            .setBlur(3)
            .setSpread(0.5)
            .setColor(0x000000)
            .setOpacity(0.18)
            .setType(PriShadowType.INSET)
        ];
    }
}