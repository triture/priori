package priori.scene.view;

import priori.view.builder.PriBuilder;

class PriSceneView extends PriBuilder {

    private var data:Dynamic;

    public function new(data:Dynamic) {
        this.data = data;
        
        super();
    }
}
