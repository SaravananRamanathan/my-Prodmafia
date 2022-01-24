package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.sound.SoundEffectLibrary;

import flash.utils.Dictionary;

public class ObjectProperties {

    internal const unlistedBosses:Vector.<int> = new <int>[1337, 2048, 39 * 60, 2349, 3448, 3449, 3452, 3613, 3622, 4312, 4324, 4325, 4326, 5943, 8200, 24092, 24327, 0x5f1f, 24363, 24587, 29003, 29021, 29039, 29341, 29342, 29723, 29764, 30026, 0xb030, 45371, 45076, 28618, 28619, 0x7fef, 29793];
    private static var groupDict:Dictionary = new Dictionary();
    private static var groupCounter:int = 0;

    public function ObjectProperties(_arg_1:XML) {
        var _local2:int = 0;
        var _local3:* = undefined;
        var _local4:* = undefined;
        projectiles_ = new Dictionary();
        var _local5:* = null;
        var _local6:* = null;
        super();
        if (_arg_1 == null) {
            return;
        }
        this.type_ = int(_arg_1.@type);
        this.id_ = String(_arg_1.@id);
        this.class_ = _arg_1.Class;
        this.displayId_ = this.id_;
        if ("DisplayId" in _arg_1) {
            this.displayId_ = _arg_1.DisplayId;
        }
        this.shadowSize_ = "ShadowSize" in _arg_1 ? _arg_1.ShadowSize : 100;
        this.isPlayer_ = "Player" in _arg_1;
        this.isEnemy_ = "Enemy" in _arg_1;
        this.isQuest_ = "Quest" in _arg_1;
        this.isItem_ = "Item" in _arg_1;
        if (this.isItem_) {
            var stackable:Boolean = false;
            if ("Quantity" in _arg_1 && "ExtraTooltipData" in _arg_1) {
                var _local7:* = _arg_1.ExtraTooltipData.EffectInfo;
                var _local8:int = 0;
                var _local10:* = new XMLList("");
                stackable = int(_arg_1.ExtraTooltipData.EffectInfo.(@name == "Stack limit").@description) - _arg_1.Quantity > 0;
            }
            if (stackable) {
                stackable_ = true;
                stackGroup_ = computeStackGroup(this.id_);
            }
        }
        if ("SlotType" in _arg_1) {
            this.slotType_ = _arg_1.SlotType;
        }
        if ("Tier" in _arg_1) {
            this.tier = _arg_1.Tier;
        }
        this.boss_ = "Quest" in _arg_1;
        if (this.unlistedBosses.indexOf(this.type_) >= 0) {
            this.boss_ = true;
        }
        this.drawOnGround_ = "DrawOnGround" in _arg_1;
        if (this.drawOnGround_ || "DrawUnder" in _arg_1) {
            this.drawUnder_ = true;
        }
        this.occupySquare_ = "OccupySquare" in _arg_1;
        this.fullOccupy_ = "FullOccupy" in _arg_1;
        this.enemyOccupySquare_ = "EnemyOccupySquare" in _arg_1;
        this.static_ = "Static" in _arg_1;
        this.noMiniMap_ = "NoMiniMap" in _arg_1;
        if ("HealthBar" in _arg_1) {
            this.healthBar_ = _arg_1.HealthBar;
        }
        this.noHealthBar_ = "NoHealthBar" in _arg_1;
        this.protectFromGroundDamage_ = "ProtectFromGroundDamage" in _arg_1;
        this.protectFromSink_ = "ProtectFromSink" in _arg_1;
        this.flying_ = "Flying" in _arg_1;
        this.showName_ = "ShowName" in _arg_1;
        this.dontFaceAttacks_ = "DontFaceAttacks" in _arg_1;
        this.dontFaceMovement_ = "DontFaceMovement" in _arg_1;
        this.isGod_ = "God" in _arg_1;
        this.isCube_ = "Cube" in _arg_1;
        this.isPotion_ = "Potion" in _arg_1;
        if ("Z" in _arg_1) {
            this.z_ = _arg_1.Z;
        }
        if ("Color" in _arg_1) {
            this.color_ = _arg_1.Color;
        }
        if ("Size" in _arg_1) {
            _local3 = _arg_1.Size;
            this.maxSize_ = _local3;
            this.minSize_ = _local3;
            if (this.maxSize_ == -1) {
                _local4 = 0;
                this.maxSize_ = _local4;
                this.minSize_ = _local4;
            }
        } else {
            if ("MinSize" in _arg_1) {
                this.minSize_ = _arg_1.MinSize;
            }
            if ("MaxSize" in _arg_1) {
                this.maxSize_ = _arg_1.MaxSize;
            }
            if ("SizeStep" in _arg_1) {
                this.sizeStep_ = _arg_1.SizeStep;
            }
        }
        this.oldSound_ = "OldSound" in _arg_1 ? _arg_1.OldSound : null;
        for each(_local5 in _arg_1.Projectile) {
            _local2 = _local5.@id;
            var projProps:ProjectileProperties = new ProjectileProperties(_local5);
            this.projectiles_[_local2] = projProps;
            if (projProps.maxProjTravel_ > this.maxRange)
                this.maxRange = projProps.maxProjTravel_;
        }
        this.rateOfFire_ = "RateOfFire" in _arg_1 ? _arg_1.RateOfFire : 0;
        this.angleCorrection_ = "AngleCorrection" in _arg_1 ? _arg_1.AngleCorrection * 0.785398163397448 : 0;
        this.rotation_ = "Rotation" in _arg_1 ? _arg_1.Rotation : 0;
        if ("BloodProb" in _arg_1) {
            this.bloodProb_ = _arg_1.BloodProb;
        }
        if ("BloodColor" in _arg_1) {
            this.bloodColor_ = _arg_1.BloodColor;
        }
        if ("ShadowColor" in _arg_1) {
            this.shadowColor_ = _arg_1.ShadowColor;
        }
        var _local14:int = 0;
        var _local13:* = _arg_1.Sound;
        for each(_local6 in _arg_1.Sound) {
            if (this.sounds_ == null) {
                this.sounds_ = {};
            }
            this.sounds_[int(_local6.@id)] = _local6.toString();
        }
        if ("Portrait" in _arg_1) {
            this.portrait_ = new TextureDataConcrete(XML(_arg_1.Portrait));
        }
        if ("WhileMoving" in _arg_1) {
            this.whileMoving_ = new WhileMovingProperties(XML(_arg_1.WhileMoving));
        }
    }
    public var type_:int;
    public var id_:String;
    public var displayId_:String;
    public var shadowSize_:int;
    public var desiredLoot_:Boolean;
    public var isPlayer_:Boolean = false;
    public var isEnemy_:Boolean = false;
    public var isQuest_:Boolean = false;
    public var isItem_:Boolean = false;
    public var drawOnGround_:Boolean = false;
    public var drawUnder_:Boolean = false;
    public var occupySquare_:Boolean = false;
    public var fullOccupy_:Boolean = false;
    public var enemyOccupySquare_:Boolean = false;
    public var static_:Boolean = false;
    public var noMiniMap_:Boolean = false;
    public var noHealthBar_:Boolean = false;
    public var healthBar_:int = 0;
    public var protectFromGroundDamage_:Boolean = false;
    public var protectFromSink_:Boolean = false;
    public var z_:Number = 0;
    public var flying_:Boolean = false;
    public var color_:int = -1;
    public var showName_:Boolean = false;
    public var dontFaceAttacks_:Boolean = false;
    public var dontFaceMovement_:Boolean = false;
    public var bloodProb_:Number = 0;
    public var bloodColor_:uint = 16711680;
    public var shadowColor_:uint = 0;
    public var sounds_:Object = null;
    public var portrait_:TextureData = null;
    public var minSize_:int = 100;
    public var maxSize_:int = 100;
    public var sizeStep_:int = 5;
    public var whileMoving_:WhileMovingProperties = null;
    public var oldSound_:String = null;
    public var projectiles_:Dictionary;
    public var maxRange:Number = -1;
    public var rateOfFire_:Number;
    public var angleCorrection_:Number = 0;
    public var rotation_:Number = 0;
    public var ignored:Boolean;
    public var excepted:Boolean;
    public var isGod_:Boolean;
    public var isCube_:Boolean;
    public var isPotion_:Boolean;
    public var boss_:Boolean = false;
    public var customBoss_:Boolean = false;
    public var stackable_:Boolean;
    public var stackGroup_:int = 0;
    public var slotType_:int = -2147483648;
    public var tier:int = -2147483648;
    public var class_:String;

    public function loadSounds():void {
        var _local1:* = null;
        if (this.sounds_ == null) {
            return;
        }
        var _local3:int = 0;
        var _local2:* = this.sounds_;
        for each(_local1 in this.sounds_) {
            SoundEffectLibrary.load(_local1);
        }
    }

    public function getSize():int {
        if (this.minSize_ == this.maxSize_) {
            return this.minSize_;
        }
        var _local1:int = (this.maxSize_ - this.minSize_) / this.sizeStep_;
        return this.minSize_ + int(Math.random() * _local1) * this.sizeStep_;
    }

    private function computeStackGroup(_arg_1:String):int {
        var _local2:* = null;
        var _local3:int = _arg_1.indexOf(" x");
        if (_local3 != -1) {
            _local2 = _arg_1.substr(0, _local3);
            if (groupDict[_local2] == null) {
                groupCounter = Number(groupCounter) + 1;
                groupDict[_local2] = Number(groupCounter);
            }
            return groupDict[_local2];
        }
        return -1;
    }
}
}

class WhileMovingProperties {


    function WhileMovingProperties(_arg_1:XML) {
        super();
        if ("Z" in _arg_1) {
            this.z_ = _arg_1.Z;
        }
        this.flying_ = "Flying" in _arg_1;
    }
    public var z_:Number = 0;
    public var flying_:Boolean = false;
}
