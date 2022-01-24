package kabam.rotmg.stage3D {
import com.adobe.utils.AGALMiniAssembler;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.GraphicsBitmapFill;
import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.Program3D;
import flash.display3D.VertexBuffer3D;
import flash.display3D.textures.Texture;
import flash.geom.Matrix3D;
import flash.utils.ByteArray;

import kabam.rotmg.stage3D.Object3D.Util;
import kabam.rotmg.stage3D.graphic3D.Graphic3D;
import kabam.rotmg.stage3D.proxies.Context3DProxy;

import org.swiftsuspenders.Injector;

public class Renderer {

    public static const STAGE3D_FILTER_PAUSE:uint = 1;

    public static const STAGE3D_FILTER_BLIND:uint = 2;

    public static const STAGE3D_FILTER_DRUNK:uint = 3;

    private static const POST_FILTER_VERTEX_CONSTANTS:Vector.<Number> = new <Number>[1,2,0,0];

    private static const GRAYSCALE_FRAGMENT_CONSTANTS:Vector.<Number> = new <Number>[0.3,0.59,0.11,0];

    private static const BLIND_FRAGMENT_CONSTANTS:Vector.<Number> = new <Number>[0.05,0.05,0.05,0];

    private static const POST_FILTER_POSITIONS:Vector.<Number> = new <Number>[-1,1,0,0,1,1,1,0,1,-1,1,1,-1,-1,0,1];

    private static const POST_FILTER_TRIS:Vector.<uint> = new <uint>[0,2,3,0,1,2];

    public static var inGame:Boolean;


    [Inject]
    public var context3D:Context3DProxy;

    [Inject]
    public var injector:Injector;

    private var tX:Number;

    private var tY:Number;

    private var postProcessingProgram:Program3D;

    private var blurPostProcessing:Program3D;

    private var shadowProgram:Program3D;

    private var graphic3D:Graphic3D;

    private var stageHeight:Number = 800;

    private var stageWidth:Number = 600;

    private var sceneTexture:Texture;

    private var blurFactor:Number = 0.01;

    private var postFilterVertexBuffer:VertexBuffer3D;

    private var postFilterIndexBuffer:IndexBuffer3D;

    protected var vertexShader:String;

    protected var fragmentShader:String;

    protected var blurFragmentConstants:Vector.<Number>;

    protected var projection:Matrix3D;

    public var program2:Program3D;

    private var lastCull:String = "none";

    public function Renderer(r3d:Render3D) {
        this.vertexShader = ["m44 op, va0, vc0","m44 v0, va0, vc8","m44 v1, va1, vc8","mov v2, va2"].join("\n");
        this.fragmentShader = ["tex oc, v2, fs0 <2d,clamp>"].join("\n");
        this.blurFragmentConstants = Vector.<Number>([0.4,0.6,0.4,1.5]);
        super();
        this.setTranslationToTitle();
        r3d.add(this.onRender);
    }

    public function init(_arg1:Context3D) : void {
        this.projection = Util.perspectiveProjection(56,1,0.1,2048);
        var _local2:AGALMiniAssembler = new AGALMiniAssembler();
        _local2.assemble("vertex",this.vertexShader);
        var _local5:AGALMiniAssembler = new AGALMiniAssembler();
        _local5.assemble("fragment",this.fragmentShader);
        this.program2 = context3D.createProgram().getProgram3D();
        this.program2.upload(_local2.agalcode,_local5.agalcode);
        var _local8:AGALMiniAssembler = new AGALMiniAssembler();
        _local8.assemble("vertex","mov op, va0\nadd vt0, vc0.xxxx, va0\ndiv vt0, vt0, vc0.yyyy\nsub vt0.y, vc0.x, vt0.y\nmov v0, vt0\n");
        var _local9:ByteArray = _local8.agalcode;
        _local8.assemble("fragment","tex ft0, v0, fs0 <2d,clamp,linear>\ndp3 ft0.x, ft0, fc0\nmov ft0.y, ft0.x\nmov ft0.z, ft0.x\nmov oc, ft0\n");
        var _local3:ByteArray = _local8.agalcode;
        this.postProcessingProgram = _arg1.createProgram();
        this.postProcessingProgram.upload(_local9,_local3);
        _local8.assemble("vertex","m44 op, va0, vc0\nmov v0, va1\n");
        var _local16:ByteArray = _local8.agalcode;
        _local8.assemble("fragment","sub ft0, v0, fc0\nsub ft0.zw, ft0.zw, ft0.zw\ndp3 ft1, ft0, ft0\nsqt ft1, ft1\ndiv ft1.xy, ft1.xy, fc0.zz\npow ft1.x, ft1.x, fc0.w\nmul ft0.xy, ft0.xy, ft1.xx\ndiv ft0.xy, ft0.xy, ft1.yy\nadd ft0.xy, ft0.xy, fc0.xy\ntex oc, ft0, fs0<2d,clamp>\n");
        var _local15:ByteArray = _local8.agalcode;
        this.blurPostProcessing = _arg1.createProgram();
        this.blurPostProcessing.upload(_local16,_local15);
        _local8.assemble("vertex","m44 op, va0, vc0\nmov v0, va1\nmov v1, va2\n");
        var _local13:ByteArray = _local8.agalcode;
        _local8.assemble("fragment","sub ft0.xy, v1.xy, fc4.xx\nmul ft0.xy, ft0.xy, ft0.xy\nadd ft0.x, ft0.x, ft0.y\nslt ft0.y, ft0.x, fc4.y\nmul oc, v0, ft0.yyyy\n");
        var _local4:ByteArray = _local8.agalcode;
        this.shadowProgram = _arg1.createProgram();
        this.shadowProgram.upload(_local13,_local4);
        this.sceneTexture = _arg1.createTexture(1024,1024,"bgra",true);
        this.postFilterVertexBuffer = _arg1.createVertexBuffer(4,4);
        this.postFilterVertexBuffer.uploadFromVector(POST_FILTER_POSITIONS,0,4);
        this.postFilterIndexBuffer = _arg1.createIndexBuffer(6);
        this.postFilterIndexBuffer.uploadFromVector(POST_FILTER_TRIS,0,6);
        this.graphic3D = this.injector.getInstance(Graphic3D);
    }

    private function onRender(graphics:Vector.<GraphicsBitmapFill>, effId:uint) : void {
        if(WebMain.STAGE.stageWidth != this.stageWidth || WebMain.STAGE.stageHeight != this.stageHeight) {
            this.resizeStage3DBackBuffer();
        }
        if(Renderer.inGame) {
            this.setTranslationToGame();
        } else {
            this.setTranslationToTitle();
        }
        if(effId > 0) {
            this.renderWithPostEffect(graphics,effId);
        } else {
            this.renderScene(graphics);
        }
        this.context3D.present();
    }

    private function resizeStage3DBackBuffer() : void {
        if(WebMain.STAGE.stageWidth > 1 || WebMain.STAGE.stageHeight > 1) {
            WebMain.STAGE.stage3Ds[0].context3D.configureBackBuffer(WebMain.STAGE.stageWidth,WebMain.STAGE.stageHeight,0,false);
            this.stageWidth = WebMain.STAGE.stageWidth;
            this.stageHeight = WebMain.STAGE.stageHeight;
        }
    }

    private function renderWithPostEffect(graphics:Vector.<GraphicsBitmapFill>, effId:uint) : void {
        this.context3D.GetContext3D().setRenderToTexture(this.sceneTexture,true);
        this.renderScene(graphics);
        this.context3D.GetContext3D().setRenderToBackBuffer();
        switch(int(effId) - 1) {
            case 0:
            case 1:
                this.context3D.GetContext3D().setProgram(this.postProcessingProgram);
                this.context3D.GetContext3D().setTextureAt(0,this.sceneTexture);
                this.context3D.GetContext3D().clear();
                this.context3D.GetContext3D().setVertexBufferAt(0,this.postFilterVertexBuffer,0,"float2");
                this.context3D.GetContext3D().setVertexBufferAt(1,null);
                break;
            case 2:
                this.context3D.GetContext3D().setProgram(this.blurPostProcessing);
                this.context3D.GetContext3D().setTextureAt(0,this.sceneTexture);
                this.context3D.GetContext3D().clear();
                this.context3D.GetContext3D().setVertexBufferAt(0,this.postFilterVertexBuffer,0,"float2");
                this.context3D.GetContext3D().setVertexBufferAt(1,this.postFilterVertexBuffer,2,"float2");
        }
        this.context3D.GetContext3D().setVertexBufferAt(2,null);
        switch(int(effId) - 1) {
            case 0:
                this.context3D.setProgramConstantsFromVector("vertex",0,POST_FILTER_VERTEX_CONSTANTS);
                this.context3D.setProgramConstantsFromVector("fragment",0,GRAYSCALE_FRAGMENT_CONSTANTS);
                break;
            case 1:
                this.context3D.setProgramConstantsFromVector("vertex",0,POST_FILTER_VERTEX_CONSTANTS);
                this.context3D.setProgramConstantsFromVector("fragment",0,BLIND_FRAGMENT_CONSTANTS);
                break;
            case 2:
                if(this.blurFragmentConstants[3] <= 0.2 || this.blurFragmentConstants[3] >= 1.8) {
                    this.blurFactor = this.blurFactor * -1;
                }
                this.blurFragmentConstants[3] = this.blurFragmentConstants[3] + this.blurFactor;
                this.context3D.setProgramConstantsFromMatrix("vertex",0,new Matrix3D());
                this.context3D.setProgramConstantsFromVector("fragment",0,this.blurFragmentConstants,this.blurFragmentConstants.length / 4);
        }
        this.context3D.GetContext3D().clear(0,0,0,1);
        this.context3D.GetContext3D().drawTriangles(this.postFilterIndexBuffer);
    }

    private var m3d:Matrix3D = new Matrix3D();
    private var gm3d:Matrix3D;
    private function renderScene(gfxData:Vector.<GraphicsBitmapFill>) : void {
        this.context3D.clear();

        this.gm3d = this.graphic3D.getMatrix3D();
        var gfxLen:int = gfxData.length;
        for (var i:int = 0; i < gfxLen; i++) {
            if (lastCull != "none") {
                this.context3D.GetContext3D().setCulling("none");
                lastCull = "none";
            }

            this.graphic3D.setGraphic(gfxData[i], this.context3D);
            this.m3d.identity();
            this.m3d.append(this.gm3d);
            this.m3d.appendScale(1 / (this.stageWidth / Parameters.data.mscale / 2),
                    1 / (this.stageHeight / Parameters.data.mscale / 2),1);
            this.m3d.appendTranslation(this.tX / (this.stageWidth / Parameters.data.mscale),
                    this.tY / (this.stageHeight / Parameters.data.mscale),0);
            this.context3D.setProgramConstantsFromMatrix("vertex", 0, this.m3d, true);
            this.graphic3D.render(this.context3D);
        }
    }

    private function setTranslationToGame() : void {
        this.tX = -200 * WebMain.STAGE.stageWidth / 800;
        this.tY = Parameters.data.centerOnPlayer?(Camera.CenterRect.y + Camera.CenterRect.height / 2) * 2:Number((Camera.OffCenterRect.y + Camera.OffCenterRect.height / 2) * 2);
    }

    private function setTranslationToTitle() : void {
        this.tY = 0;
        this.tX = 0;
    }
}
}
