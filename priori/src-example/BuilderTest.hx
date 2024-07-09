package;

import priori.view.builder.PriBuilder;

@priori('
<priori>
    <imports>
        <priori.view.container.PriContainer alias="Container" />
    </imports>
    <views left="0" right="0" top="0" bottom="0">

        <Container id="container" width="300" height="300" centerX="${this.width/2}" >
            <Container width="200" height="200" x="10" y="10" bgColor="#ffff00" >
                <Container width="20" height="20" bgColor="#00ff00" />
            </Container>
        </Container>

    </views>
</priori>
')
class BuilderTest extends PriBuilder {
    
    override function setup() {
        super.setup();

        this.container.bgColor = 0xF3F3F3;
    }
}