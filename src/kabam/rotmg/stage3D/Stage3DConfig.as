package kabam.rotmg.stage3D {
import com.company.assembleegameclient.util.Stage3DProxy;
import com.company.assembleegameclient.util.StageProxy;

import flash.events.Event;

import kabam.rotmg.stage3D.graphic3D.Graphic3DHelper;
import kabam.rotmg.stage3D.graphic3D.IndexBufferFactory;
import kabam.rotmg.stage3D.graphic3D.TextureFactory;
import kabam.rotmg.stage3D.graphic3D.VertexBufferFactory;
import kabam.rotmg.stage3D.proxies.Context3DProxy;

import org.swiftsuspenders.Injector;

import robotlegs.bender.framework.api.IConfig;

public class Stage3DConfig implements IConfig {


    public function Stage3DConfig() {
        super();
    }
    [Inject]
    public var stageProxy:StageProxy;
    [Inject]
    public var injector:Injector;
    public var renderer:Renderer;
    private var stage3D:Stage3DProxy;

    public function configure():void {
        this.mapSingletons();
        this.stage3D = this.stageProxy.getStage3Ds(0);
        this.stage3D.addEventListener("context3DCreate", this.onContextCreate);
        this.stage3D.requestContext3D();
    }

    private function mapSingletons():void {
        this.injector.map(Render3D).asSingleton();
        this.injector.map(TextureFactory).asSingleton();
        this.injector.map(IndexBufferFactory).asSingleton();
        this.injector.map(VertexBufferFactory).asSingleton();
    }

    private function onContextCreate(_arg_1:Event):void {
        this.stage3D.removeEventListener("context3DCreate", this.onContextCreate);
        var _local2:Context3DProxy = this.stage3D.getContext3D();
        _local2.configureBackBuffer(800, 10 * 60, 0);
        _local2.setBlendFactors("sourceAlpha", "oneMinusSourceAlpha");
        _local2.setDepthTest(false, "lessEqual");
        this.injector.map(Context3DProxy).toValue(_local2);
        Graphic3DHelper.map(this.injector);
        this.renderer = this.injector.getInstance(Renderer);
        this.renderer.init(_local2.GetContext3D());
    }
}
}
