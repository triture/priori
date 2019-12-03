package priori.scene.view;

import priori.view.builder.PriBuilder;

class PriSceneView extends PriBuilder {

    private var data:Dynamic;

    public function new(data:Dynamic) {
        this.data = data;
        
        super();
    }
    
    @:noCompletion
    inline public function validate():Void this.updateDisplay();

    @:noCompletion
    inline public function revalidate():Void this.updateDisplay();

}
