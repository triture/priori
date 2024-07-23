package priori.font;

import js.html.FontFaceLoadStatus;
import js.html.FontFaceDescriptors;
import js.html.FontFace;

class PriFontProvider {
    
    // SINGLETON
    private static var instance: PriFontProvider;
    public static function get(): PriFontProvider {
        if (instance == null) instance = new PriFontProvider();
        return instance;
    }

    // CLASS
    private var fonts:Array<FontFace>;
    private var canAddFonts:Bool;

    private function new() {
        this.fonts = [];
        this.canAddFonts = true;
    }

    public function addFont(family:String, src:String, ?descriptors:FontFaceDescriptors):Void {
        if (!this.canAddFonts) throw "Cannot add fonts after loading";

        var font:FontFace = new FontFace(family, src, descriptors);
        js.Browser.document.fonts.add(font);

        this.fonts.push(font);
    }

    public function load(onLoad:()->Void):Void {
        if (!this.canAddFonts) return;
        this.canAddFonts = false;

        for (font in this.fonts) font.load();

        this.checkFontsIsLoaded(onLoad);
    }

    private function checkFontsIsLoaded(onLoad:()->Void) {
        var allFontsLoaded:Bool = true;
        
        for (f in this.fonts) {
            if (f.status == FontFaceLoadStatus.LOADING) {
                allFontsLoaded = false;
                break;
            }
        }

        if (allFontsLoaded) onLoad();
        else haxe.Timer.delay(this.checkFontsIsLoaded.bind(onLoad), 20);
    }

}