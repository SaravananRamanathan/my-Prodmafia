package kabam.rotmg.stage3D.shaders {
import com.adobe.utils.AGALMiniAssembler;

import flash.utils.ByteArray;

public class VertextShader extends AGALMiniAssembler {


    public function VertextShader() {
        super();
        var _local1:AGALMiniAssembler = new AGALMiniAssembler();
        _local1.assemble("vertex", "m44 op, va0, vc0\nadd vt1, va1, vc4\nmov v0, vt1");
        this.vertexProgram = _local1.agalcode;
    }
    private var vertexProgram:ByteArray;

    public function getVertexProgram():ByteArray {
        return this.vertexProgram;
    }
}
}
