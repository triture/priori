package pack;

import priori.view.builder.PriBuilder;

@priori('
<priori>
    <views width="300" height="300" bgColor="0xCCCCCC" root="inner" >
        <PriBuilder id="inner" bgColor="0xAAAAAA" left="30" top="30" right="30" bottom="30" />
        <PriBuilder id="reroot_box" right="0" width="20" height="20" bgColor="0xFFF200" />
    </views>
</priori>
')
class ReRootDisplay extends PriBuilder {
    
    override function setup() {
        super.setup();
    }
}

