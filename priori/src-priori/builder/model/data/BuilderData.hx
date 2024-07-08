package builder.model.data;

import builder.model.data.BuilderInstanceData;

// XML EXAMPLE
// <priori>
//     <imports>
//         <haxe.io.Bytes alias="Bytes" />
//     </imports>
//     <views>
//         <PriDisplay id="display" x="10" />
//         <PriContainer> <PriDisplay id="display" x="10" /> </PriContainer>
//     </views>
// </priori>
typedef BuilderData = {

    var imports:Array<BuilderImportData>;
    var views:Array<BuilderInstanceData>;
    var properties:Array<BuilderKeyValueData>;

}