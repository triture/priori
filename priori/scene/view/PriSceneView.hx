package priori.scene.view;

import priori.view.builder.PriBuilder;

class PriSceneView extends PriBuilder {

    private var data:Dynamic;

    public function new(data:Dynamic) {
        this.data = data;
        
        super();
    }

    @:noCompletion
    @:deprecated("use updateDisplay() instead")
    inline public function validate():Void this.updateDisplay();

    @:noCompletion
    @:deprecated("use updateDisplay() instead")
    inline public function revalidate():Void this.updateDisplay();

}
