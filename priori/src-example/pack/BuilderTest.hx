package pack;

import priori.view.builder.PriBuilder;

@priori('
<priori>
    <imports>
        <priori.view.container.PriContainer alias="Container" />
    </imports>
    <views left="0" right="0" top="0" bottom="0">
        
        <Container id="container" width="300" height="300" centerX="${this.width/2}" >
            <priori.view.PriDisplay />
            <Container width="200" height="200" x="10" y="10" bgColor="#ffff00" >
                <MyTypedDisplay type="<MyTypedDisplay<Bool, PriBuilder>, Container>" id="typed" width="20" height="20" bgColor="#00ff00" />
            </Container>
        </Container>

        <ReRootDisplay id="reroot" y="400" centerX="${this.width/2}" >
            <PriBuilder width="20" height="20" bgColor="0xFF0000" />
            <PriBuilder right="0" width="20" height="20" bgColor="0xFFF200" />
        </ReRootDisplay>

    </views>
</priori>
')
class BuilderTest extends PriBuilder {
    
    override function setup() {
        super.setup();

        this.container.bgColor = 0xF3F3F3;
        
    }
}

