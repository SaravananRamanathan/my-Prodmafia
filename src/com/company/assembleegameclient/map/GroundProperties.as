package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.TextureData;
import com.company.assembleegameclient.objects.TextureDataConcrete;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;

public class GroundProperties {


    public function GroundProperties(_arg_1:XML) {
        animate_ = new AnimateProperties();
        super();
        this.type_ = int(_arg_1.@type);
        var _local2:String = _arg_1.@id;
        this.id_ = _local2;
        this.displayId_ = _local2;
        if ("DisplayId" in _arg_1) {
            this.displayId_ = _arg_1.DisplayId;
        }
        this.id_ = String(_arg_1.@id);
        this.noWalk_ = "NoWalk" in _arg_1;
        if ("MinDamage" in _arg_1) {
            this.minDamage_ = _arg_1.MinDamage;
        }
        if ("MaxDamage" in _arg_1) {
            this.maxDamage_ = _arg_1.MaxDamage;
        }
        if ("Animate" in _arg_1) {
            this.animate_.parseXML(XML(_arg_1.Animate));
        }
        if ("BlendPriority" in _arg_1) {
            this.blendPriority_ = _arg_1.BlendPriority;
        }
        if ("CompositePriority" in _arg_1) {
            this.compositePriority_ = _arg_1.CompositePriority;
        }
        if ("Speed" in _arg_1) {
            this.speed_ = _arg_1.Speed;
        }
        if ("SlideAmount" in _arg_1) {
            this.slideAmount_ = _arg_1.SlideAmount;
        }
        this.xOffset_ = "XOffset" in _arg_1 ? _arg_1.XOffset : 0;
        this.yOffset_ = "YOffset" in _arg_1 ? _arg_1.YOffset : 0;
        this.push_ = "Push" in _arg_1;
        this.sink_ = "Sink" in _arg_1;
        this.sinking_ = "Sinking" in _arg_1;
        this.randomOffset_ = "RandomOffset" in _arg_1;
        if ("Edge" in _arg_1) {
            this.hasEdge_ = true;
            this.edgeTD_ = new TextureDataConcrete(XML(_arg_1.Edge));
            if ("Corner" in _arg_1) {
                this.cornerTD_ = new TextureDataConcrete(XML(_arg_1.Corner));
            }
            if ("InnerCorner" in _arg_1) {
                this.innerCornerTD_ = new TextureDataConcrete(XML(_arg_1.InnerCorner));
            }
        }
        this.sameTypeEdgeMode_ = "SameTypeEdgeMode" in _arg_1;
        if ("Top" in _arg_1) {
            this.topTD_ = new TextureDataConcrete(XML(_arg_1.Top));
            this.topAnimate_ = new AnimateProperties();
            if ("TopAnimate" in _arg_1) {
                this.topAnimate_.parseXML(XML(_arg_1.TopAnimate));
            }
        }
    }
    public var type_:int;
    public var id_:String;
    public var displayId_:String;
    public var noWalk_:Boolean = true;
    public var minDamage_:int = 0;
    public var maxDamage_:int = 0;
    public var animate_:AnimateProperties;
    public var blendPriority_:int = -1;
    public var compositePriority_:int = 0;
    public var speed_:Number = 1;
    public var xOffset_:Number = 0;
    public var yOffset_:Number = 0;
    public var slideAmount_:Number = 0;
    public var push_:Boolean = false;
    public var sink_:Boolean = false;
    public var sinking_:Boolean = false;
    public var randomOffset_:Boolean = false;
    public var hasEdge_:Boolean = false;
    public var sameTypeEdgeMode_:Boolean = false;
    public var topTD_:TextureData = null;
    public var topAnimate_:AnimateProperties = null;
    private var edgeTD_:TextureData = null;
    private var cornerTD_:TextureData = null;
    private var innerCornerTD_:TextureData = null;
    private var edges_:Vector.<BitmapData> = null;
    private var innerCorners_:Vector.<BitmapData> = null;

    public function getEdges():Vector.<BitmapData> {
        if (!this.hasEdge_ || this.edges_ != null) {
            return this.edges_;
        }
        this.edges_ = new Vector.<BitmapData>(9);
        this.edges_[3] = this.edgeTD_.getTexture(0);
        this.edges_[1] = BitmapUtil.rotateBitmapData(this.edges_[3], 1);
        this.edges_[5] = BitmapUtil.rotateBitmapData(this.edges_[3], 2);
        this.edges_[7] = BitmapUtil.rotateBitmapData(this.edges_[3], 3);
        if (this.cornerTD_ != null) {
            this.edges_[0] = this.cornerTD_.getTexture(0);
            this.edges_[2] = BitmapUtil.rotateBitmapData(this.edges_[0], 1);
            this.edges_[8] = BitmapUtil.rotateBitmapData(this.edges_[0], 2);
            this.edges_[6] = BitmapUtil.rotateBitmapData(this.edges_[0], 3);
        }
        return this.edges_;
    }

    public function getInnerCorners():Vector.<BitmapData> {
        if (this.innerCornerTD_ == null || this.innerCorners_ != null) {
            return this.innerCorners_;
        }
        this.innerCorners_ = this.edges_.concat();
        this.innerCorners_[0] = this.innerCornerTD_.getTexture(0);
        this.innerCorners_[2] = BitmapUtil.rotateBitmapData(this.innerCorners_[0], 1);
        this.innerCorners_[8] = BitmapUtil.rotateBitmapData(this.innerCorners_[0], 2);
        this.innerCorners_[6] = BitmapUtil.rotateBitmapData(this.innerCorners_[0], 3);
        return this.innerCorners_;
    }
}
}
