package;

import priori.view.builder.PriBuilder;

@priori('
<priori>
    <imports>
        <priori.view.container.PriContainer alias="Container" />
    </imports>
    <views>
        <p:bgColor value="#f3f3f3"/>
        <p:width value="300"/>
        <p:height value="300"/>

        <Container width="200" height="200" x="10" y="10" bgColor="#ffff00" >
            <Container width="20" height="20" bgColor="#00ff00" />
        </Container>

    </views>
</priori>
')
class BuilderTest extends PriBuilder {
    
}