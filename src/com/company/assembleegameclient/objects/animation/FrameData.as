package com.company.assembleegameclient.objects.animation {
    import com.company.assembleegameclient.objects.TextureData;
    import com.company.assembleegameclient.objects.TextureDataConcrete;

    public class FrameData {
        public function FrameData(_arg_1:XML) {
            super();
            this.time_ = _arg_1.@time * 1000;
            this.textureData_ = new TextureDataConcrete(_arg_1);
        }
        public var time_:int;
        public var textureData_:TextureData;
    }
}
