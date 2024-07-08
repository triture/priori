package builder.model.data;

import builder.model.enums.BuilderElementVisibilityType;

// XML EXAMPLE
// <PriDisplay id="display" x="10" />
// <public:PriDisplay id="display" x="10" />
// <private:PriDisplay id="display" x="10" />
// <PriContainer> <PriDisplay id="display" x="10" /> </PriContainer>

typedef BuilderInstanceData = {
    var name:String;
    var visibility:BuilderElementVisibilityType;
    var properties:Array<BuilderKeyValueData>;
    var children:Array<BuilderInstanceData>;
}