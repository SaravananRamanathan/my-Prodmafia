package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
import com.company.assembleegameclient.objects.animation.Animations;
import com.company.assembleegameclient.objects.animation.AnimationsData;
import com.company.assembleegameclient.objects.particles.ExplosionEffect;
import com.company.assembleegameclient.objects.particles.HitEffect;
import com.company.assembleegameclient.objects.particles.ParticleEffect;
import com.company.assembleegameclient.objects.particles.ShockerEffect;
import com.company.assembleegameclient.objects.particles.SpritesProjectEffect;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.ConditionEffect;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.BitmapUtil;
import com.company.util.CachingColorTransformer;
import com.company.util.ConversionUtil;
import com.company.util.GraphicsUtil;
import com.company.util.MoreColorUtil;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

import io.decagames.rotmg.pets.data.PetsModel;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.messaging.impl.data.WorldPosData;
import kabam.rotmg.stage3D.GraphicsFillExtra;
import kabam.rotmg.text.view.BitmapTextFactory;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class GameObject extends BasicObject {

    protected static const PAUSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);

    protected static const CURSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.redFilterMatrix);

    protected static const IDENTITY_MATRIX:Matrix = new Matrix();

    private static const ZERO_LIMIT:Number = 1.0E-5;

    private static const NEGATIVE_ZERO_LIMIT:Number = -1.0E-5;

    public static const ATTACK_PERIOD:int = 300;

    private static const DEFAULT_HP_BAR_Y_OFFSET:int = 6;

    public static const radius_:Number = 0.5;

    public static function outputPositions(_arg_1:GameObject):String {
        return "X: " + round2(_arg_1.x_) + ", Y: " + round2(_arg_1.y_) + ", pX: " + round2(_arg_1.posAtTick_.x) + ", pY: " + round2(_arg_1.posAtTick_.y) + ", tX: " + round2(_arg_1.tickPosition_.x) + ", tY: " + round2(_arg_1.tickPosition_.y);
    }

    public static function round2(_arg_1:Number):Number {
        return _arg_1 * 100 * 0.01;
    }

    public function GameObject(_arg_1:XML) {
        var _local5:* = 0;
        var _local4:int = 0;
        var _local3:* = undefined;
        iconCache = new Vector.<BitmapData>();
        rangeCache = new Dictionary();
        props_ = ObjectLibrary.defaultProps_;
        condition_ = new <uint>[0, 0];
        posAtTick_ = new Point();
        tickPosition_ = new Point();
        moveVec_ = new Vector3D();
        bitmapFill = new GraphicsBitmapFill(null, null, false, false);
        rangeBitmapFill = new GraphicsBitmapFill(null, null, false, false);
        path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, null);
        vS_ = new Vector.<Number>();
        uvt_ = new Vector.<Number>();
        fillMatrix_ = new Matrix();
        rangeFillMatrix = new Matrix();
        this.hpBarFillMatrix = new Matrix();
        this.hpBarBackFillMatrix = new Matrix();
        super();
        if (_arg_1 == null) {
            return;
        }
        this.objectType_ = int(_arg_1.@type);
        this.props_ = ObjectLibrary.propsLibrary_[this.objectType_];
        hasShadow_ = this.props_.shadowSize_ > 0;
        var _local2:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
        this.texture = _local2.texture_;
        this.mask_ = _local2.mask_;
        this.animatedChar_ = _local2.animatedChar_;
        this.randomTextureData_ = _local2.randomTextureData_;
        if (_local2.effectProps_) {
            this.effect_ = ParticleEffect.fromProps(_local2.effectProps_, this);
        }
        if (this.texture) {
            this.sizeMult_ = this.texture.height * 0.125;
        }
        var _local6:AnimationsData = ObjectLibrary.typeToAnimationsData_[this.objectType_];
        if (_local6) {
            this.animations_ = new Animations(_local6);
        }
        z_ = this.props_.z_;
        this.flying = this.props_.flying_;
        if ("MaxHitPoints" in _arg_1) {
            _local3 = _arg_1.MaxHitPoints;
            this.maxHP_ = _local3;
            this.hp_ = _local3;
        }
        if ("Defense" in _arg_1) {
            this.defense_ = _arg_1.Defense;
        }
        if ("SlotTypes" in _arg_1) {
            this.slotTypes_ = ConversionUtil.toIntVector(_arg_1.SlotTypes);
            this.equipment_ = new Vector.<int>(this.slotTypes_.length);
            _local5 = uint(this.equipment_.length);
            _local4 = 0;
            while (_local4 < _local5) {
                this.equipment_[_local4] = -1;
                _local4++;
            }
            this.lockedSlot = new Vector.<int>(this.slotTypes_.length);
        }
        if ("Tex1" in _arg_1) {
            this.tex1Id_ = _arg_1.Tex1;
        }
        if ("Tex2" in _arg_1) {
            this.tex2Id_ = _arg_1.Tex2;
        }
        if ("StunImmune" in _arg_1) {
            this.isStunImmuneVar = true;
        }
        if ("ParalyzeImmune" in _arg_1) {
            this.isParalyzeImmuneVar = true;
        }
        if("SlowedImmune" in _arg_1) {
            this.isSlowedImmuneVar = true;
        }
        if ("DazedImmune" in _arg_1) {
            this.isDazedImmuneVar = true;
        }
        if ("StasisImmune" in _arg_1) {
            this.isStasisImmune_ = true;
        }
        if ("Invincible" in _arg_1) {
            this.isInvincibleXML = true;
        }
        this.props_.loadSounds();
    }
    public var nameBitmapData_:BitmapData = null;
    public var shockEffect:ShockerEffect;
    public var spritesProjectEffect:SpritesProjectEffect;
    public var statusFlash_:StatusFlashDescription = null;
    public var name_:String;
    public var facing_:Number = 0;
    public var flying:Boolean = false;
    public var attackAngle_:Number = 0;
    public var attackStart_:int = 0;
    public var animatedChar_:AnimatedChar = null;
    public var texture:BitmapData = null;
    public var mask_:BitmapData = null;
    public var randomTextureData_:Vector.<TextureData> = null;
    public var effect_:ParticleEffect = null;
    public var animations_:Animations = null;
    public var dead_:Boolean = false;
    public var deadCounter_:uint = 0;
    public var texturingCache_:Dictionary = null;
    public var maxHP_:int = 200;
    public var hp_:int = 200;
    public var size_:int = 100;
    public var level_:int = -1;
    public var defense_:int = 0;
    public var slotTypes_:Vector.<int> = null;
    public var equipment_:Vector.<int> = null;
    public var lockedSlot:Vector.<int> = null;
    public var supporterPoints:int = 0;
    public var isInteractive_:Boolean = false;
    public var objectType_:int;
    public var sinkLevel:int = 0;
    public var hallucinatingTexture_:BitmapData = null;
    public var flash:FlashDescription = null;
    public var connectType_:int = -1;
    public var fakeBag_:Boolean;
    public var hasShock:Boolean;
    public var isQuiet:Boolean;
    public var isWeak:Boolean;
    public var isSlowed:Boolean;
    public var isSick:Boolean;
    public var isDazed:Boolean;
    public var isStunned:Boolean;
    public var isBlind:Boolean;
    public var isDrunk:Boolean;
    public var isBleeding:Boolean;
    public var isConfused:Boolean;
    public var isStunImmune:Boolean;
    public var isInvisible:Boolean;
    public var isParalyzed:Boolean;
    public var isSpeedy:Boolean;
    public var isNinjaSpeedy:Boolean;
    public var isHallucinating:Boolean;
    public var isHealing:Boolean;
    public var isDamaging:Boolean;
    public var isBerserk:Boolean;
    public var isPaused:Boolean;
    public var isStasis:Boolean;
    public var isInvincible:Boolean;
    public var isInvulnerable:Boolean;
    public var isArmored:Boolean;
    public var isArmorBroken:Boolean;
    public var isArmorBrokenImmune:Boolean;
    public var isSlowedImmune:Boolean;
    public var isSlowedImmuneVar:Boolean;
    public var isUnstable:Boolean;
    public var isShowPetEffectIcon:Boolean;
    public var isDarkness:Boolean;
    public var isParalyzeImmune:Boolean;
    public var isDazedImmune:Boolean;
    public var isPetrified:Boolean;
    public var isPetrifiedImmune:Boolean;
    public var isCursed:Boolean;
    public var isCursedImmune:Boolean;
    public var isSilenced:Boolean;
    public var isExposed:Boolean;
    public var mobInfoShown:Boolean;
    public var footer_:Boolean;
    public var lastPercent_:int;
    public var myPet:Boolean;
    public var jittery:Boolean = false;
    public var iconCache:Vector.<BitmapData>;
    public var rangeCache:Dictionary;
    public var props_:ObjectProperties;
    public var condition_:Vector.<uint>;
    public var posAtTick_:Point;
    public var tickPosition_:Point;
    public var moveVec_:Vector3D;
    protected var portrait_:BitmapData = null;
    protected var tex1Id_:int = 0;
    protected var tex2Id_:int = 0;
    protected var lastTickUpdateTime_:int = 0;
    public var myLastTickId_:int = -1;
    protected var shadowGradientFill_:GraphicsGradientFill = null;
    protected var shadowPath_:GraphicsPath = null;
    protected var bitmapFill:GraphicsBitmapFill;
    protected var rangeBitmapFill:GraphicsBitmapFill;
    protected var path_:GraphicsPath;
    protected var vS_:Vector.<Number>;
    protected var uvt_:Vector.<Number>;
    protected var fillMatrix_:Matrix;
    protected var rangeFillMatrix:Matrix;
    private var nameFill_:GraphicsBitmapFill = null;
    private var namePath_:GraphicsPath = null;
    private var isShocked:Boolean;
    private var isShockedTransformSet:Boolean = false;
    private var isCharging:Boolean;
    private var isChargingTransformSet:Boolean = false;
    private var nextBulletId_:uint = 1;
    private var sizeMult_:Number = 1;
    private var isStasisImmune_:Boolean = false;
    private var isInvincibleXML:Boolean = false;
    private var isStunImmuneVar:Boolean = false;
    private var isParalyzeImmuneVar:Boolean = false;
    private var isDazedImmuneVar:Boolean = false;
    protected var hpBarFillMatrix:Matrix;
    protected var hpBarBackFillMatrix:Matrix;
    private var hpBarBackFill:GraphicsBitmapFill = null;
    private var hpBarFill:GraphicsBitmapFill = null;
    private var icons_:Vector.<BitmapData> = null;
    private var iconFills_:Vector.<GraphicsBitmapFill> = null;
    private var iconPaths_:Vector.<GraphicsPath> = null;
    private var lastCon1:uint = 0;
    private var lastCon2:uint = 0;
    private var previousArmored:Boolean = false;
    private var previousArmorBroken:Boolean = false;
    private var previousCursed:Boolean = false;
    private var previousPetrified:Boolean = false;
    private var previousExposed:Boolean = false;

    override public function dispose():void {
        super.dispose();
        this.texture = null;
        if (this.portrait_) {
            this.portrait_.dispose();
            this.portrait_ = null;
        }
        this.clearTextureCache();
        this.texturingCache_ = null;
        this.slotTypes_ = null;
        this.equipment_ = null;
        this.lockedSlot = null;
        if (this.nameBitmapData_) {
            this.nameBitmapData_.dispose();
            this.nameBitmapData_ = null;
        }
        this.nameFill_ = null;
        this.namePath_ = null;
        this.bitmapFill = null;
        this.path_.commands = null;
        this.path_.data = null;
        this.vS_ = null;
        this.uvt_ = null;
        this.fillMatrix_ = null;
        this.rangeFillMatrix = null;
        this.icons_ = null;
        this.iconFills_ = null;
        this.iconPaths_ = null;
        this.shadowGradientFill_ = null;
        if (this.shadowPath_) {
            this.shadowPath_.commands = null;
            this.shadowPath_.data = null;
            this.shadowPath_ = null;
        }
        this.footer_ = false;
        for each (var tex:BitmapData in this.rangeCache)
            tex.dispose();
        this.rangeCache = null;
    }

    override public function addTo(_arg1:Map, _arg2:Number, _arg3:Number):Boolean {
        map_ = _arg1;
        this.posAtTick_.x = (this.tickPosition_.x = _arg2);
        this.posAtTick_.y = (this.tickPosition_.y = _arg3);
        if (!this.moveTo(_arg2, _arg3)) {
            trace("nulling map")
            map_ = null;
            return false;
        }
        if (this.effect_ != null) {
            map_.addObj(this.effect_, _arg2, _arg3);
        }
        return true;
    }

    override public function removeFromMap():void {
        if (square && this.props_.static_) {
            if (square.obj_ == this) {
                square.obj_ = null;
            }
            square = null;
        }
        if (this.effect_) {
            map_.removeObj(this.effect_.objectId_);
        }
        super.removeFromMap();
        this.dispose();
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean {
        var _local6:int = 0;
        var _local5:Number = NaN;
        var _local4:Number = NaN;
        var _local3:Boolean = false;
        if (Parameters.data.showMobInfo) {
            if (!this.mobInfoShown && this.props_.isEnemy_) {
                this.mobInfo("" + this.objectType_);
                this.mobInfoShown = true;
            }
        } else {
            this.mobInfoShown = false;
        }
        if (!(this.moveVec_.x == 0 && this.moveVec_.y == 0)) {
            if (this.myLastTickId_ < map_.gs_.gsc_.lastTickId_) {
                this.moveVec_.x = 0;
                this.moveVec_.y = 0;
                this.moveTo(this.tickPosition_.x, this.tickPosition_.y);
            } else {
                _local6 = _arg_1 - this.lastTickUpdateTime_;
                _local5 = this.posAtTick_.x + _local6 * this.moveVec_.x;
                _local4 = this.posAtTick_.y + _local6 * this.moveVec_.y;
                this.moveTo(_local5, _local4);
                _local3 = true;
            }
        }
        if (this.props_.whileMoving_) {
            if (!_local3) {
                z_ = this.props_.z_;
                this.flying = this.props_.flying_;
            } else {
                z_ = this.props_.whileMoving_.z_;
                this.flying = this.props_.whileMoving_.flying_;
            }
        }
        return true;
    }

    override public function draw(gfx:Vector.<GraphicsBitmapFill>, _arg_2:Camera, time:int):void {
        var tex:BitmapData;
        var _local4:Number = NaN;
        tex = this.getTexture(_arg_2, time);
        if (!tex)
            return;

        var _local10:Boolean = this.props_ && (this.props_.isEnemy_ || this.props_.isPlayer_) && !this.isInvincible && (this.props_.isPlayer_ || !this.isInvulnerable) && !this.props_.noMiniMap_;
        if (this.props_.drawOnGround_) {
            if (Parameters.lowCPUMode || square.faces_.length == 0)
                return;

            this.path_.data = square.faces_[0].face.vout_;
            this.bitmapFill.bitmapData = tex;
            square.baseTexMatrix_.calculateTextureMatrix(this.path_.data);
            this.bitmapFill.matrix = square.baseTexMatrix_.tToS_;
            gfx.push(this.bitmapFill);
            return;
        }

        if (this.props_ && !this.isInvincible) {
            if (this.props_.isEnemy_ && !this.props_.noMiniMap_) {
                _local10 = true;
            } else if (this.props_.isPlayer_) {
                if (this == this.map_.player_) {
                    _local10 = true;
                } else if (Parameters.data.showHPBarOnAlly) {
                    _local10 = true;
                }
            }
        }
        var width:int = tex.width;
        var height:int = tex.height;
        var sink:int = square.sink + this.sinkLevel;
        if (sink > 0 && this.flying) {
            sink = 0;
        }
        if (sink != 0) {
            GraphicsFillExtra.setSinkLevel(this.bitmapFill, Math.max(sink / height * 1.65 - 0.02, 0));
            sink = -sink + 0.02;
        } else if (sink == 0 && GraphicsFillExtra.getSinkLevel(this.bitmapFill) != 0) {
            GraphicsFillExtra.clearSink(this.bitmapFill);
        }
        this.vS_.length = 0;
        this.vS_.push(posS_[3] - width / 2,
                posS_[4] - height + sink,
                posS_[3] + width / 2,
                posS_[4] - height + sink,
                posS_[3] + width / 2,
                posS_[4],
                posS_[3] - width / 2,
                posS_[4]);
        if (!(Parameters.data.alphaOnOthers && this.props_.isPlayer_ && this != this.map_.player_)) {
            if (this.flash != null) {
                if (!this.flash.doneAt(time)) {
                    this.flash.applyGPU(tex, time);
                } else {
                    this.flash = null;
                    GraphicsFillExtra.clearColorTransform(tex);
                }
            } else if (GraphicsFillExtra.getColorTransform(tex) != null) {
                GraphicsFillExtra.clearColorTransform(tex);
            }
        }
        if(this.statusFlash_ != null) {
            if(!this.statusFlash_.doneAt(time)) {
                this.statusFlash_.applyGPUTextureColorTransform(tex,time);
            } else {
                this.statusFlash_ = null;
            }
        }
        this.bitmapFill.bitmapData = tex;
        this.fillMatrix_.identity();
        this.fillMatrix_.translate(this.vS_[0], this.vS_[1]);
        this.bitmapFill.matrix = this.fillMatrix_;
        gfx.push(this.bitmapFill);
        var localPlayer:Player = this.map_.player_;
        if (Parameters.data.showRange && localPlayer.objectId_ == this.objectId_
                && localPlayer.range != -1) {
            var rangeTex:BitmapData = this.getRangeCircle(this.map_.player_.range);
            this.rangeFillMatrix.identity();
            var fakeSink:int = sink == 0 ? -30 : sink; // it's otherwise off-center vertically, another fun magic number
            this.rangeFillMatrix.translate(posS_[3] - rangeTex.width / 2,
                    posS_[4] - rangeTex.height / 2 + fakeSink);
            this.rangeBitmapFill.bitmapData = rangeTex;
            this.rangeBitmapFill.matrix = this.rangeFillMatrix;
            gfx.push(this.rangeBitmapFill);
        }
        if (Parameters.data.alphaOnOthers && this.props_.isPlayer_ && this != this.map_.player_) {
            return;
        }
        if (!this.isPaused && (this.condition_[0] || uint(this.condition_[1])) && !(this is Pet)) {
            this.drawConditionIcons(gfx, _arg_2, time);
        }
        if (this.props_.showName_ && this.name_ && this.name_.length != 0) {
            this.drawName(gfx, _arg_2, false);
        }
        if (_local10) {
            if ((tex.getPixel32(tex.width * 0.25, tex.height * 0.25) | tex.getPixel32(tex.width * 0.5, tex.height * 0.5) | tex.getPixel32(tex.width * 3 / 4, tex.height * 3 / 4)) >> 24 != 0) {
                hasShadow_ = true;
                if (this.props_.healthBar_ != -1 && this.bHPBarParamCheck()) {
                    this.drawHpBar(gfx, !!this.props_.healthBar_ ? this.props_.healthBar_ : (this.props_.isPlayer_ && this != map_.player_ ? 13 : 0));
                }
            } else {
                hasShadow_ = false;
            }
        }
        if (!this.dead_ && Parameters.data.showDamageOnEnemy) {
            if (this.footer_) {
                _local4 = Parameters.dmgCounter[this.objectId_];
                if (_local4 != this.lastPercent_) {
                    _local4 = int(_local4 / this.maxHP_ * 100);
                    this.name_ = _local4 + "%";
                    this.lastPercent_ = _local4;
                    this.nameBitmapData_ = null;
                    this.drawName(gfx, _arg_2, true);
                }
            } else {
                _local4 = Parameters.dmgCounter[this.objectId_];
                if (!isNaN(_local4) && _local4 > 0) {
                    _local4 = int(_local4 / this.maxHP_ * 100);
                    this.name_ = _local4 + "%";
                    this.lastPercent_ = _local4;
                    this.drawName(gfx, _arg_2, true);
                    this.footer_ = true;
                }
            }
        }
    }

    public function updateStatuses():void {
        isPaused = isPaused_();
        isStasis = isStasis_();
        isInvincible = isInvincible_();
        isInvulnerable = isInvulnerable_();
        isArmored = isArmored_();
        isArmorBroken = isArmorBroken_();
        isArmorBrokenImmune = isArmorBrokenImmune_();
        isStunImmune = isStunImmune_();
        isSlowedImmune = isSlowedImmune_();
        isShowPetEffectIcon = isShowPetEffectIcon_();
        isParalyzeImmune = isParalyzeImmune_();
        isDazedImmune = isDazedImmune_();
        isPetrified = isPetrified_();
        isPetrifiedImmune = isPetrifiedImmune_();
        isCursed = isCursed_();
        isCursedImmune = isCursedImmune_();
    }

    public function damageWithDefense(_arg_1:int, _arg_2:int, _arg_3:Boolean, _arg_4:Vector.<uint>):int {
        var _local7:uint = _arg_4[0];
        var _local6:uint = _arg_4[1];
        if (_arg_3 || (_local7 & 67108864) != 0) {
            _arg_2 = 0;
        } else if ((_local7 & 33554432) != 0) {
            _arg_2 = _arg_2 * 2;
        }
        if ((_local6 & 131072) != 0) {
            _arg_2 = _arg_2 - 20;
        }
        var _local5:int = Math.max(_arg_1 * 0.15, _arg_1 - _arg_2);
        if ((_local7 & 16777216) != 0) {
            _local5 = 0;
        }
        if ((_local6 & 8) != 0) {
            _local5 = _local5 * 0.9;
        }
        if ((_local6 & 64) != 0) {
            _local5 = _local5 * 1.2;
        }
        return _local5;
    }

    public function setObjectId(_arg_1:int):void {
        var _local2:* = null;
        objectId_ = _arg_1;
        if (this.randomTextureData_) {
            _local2 = this.randomTextureData_[objectId_ % this.randomTextureData_.length];
            this.texture = _local2.texture_;
            this.mask_ = _local2.mask_;
            this.animatedChar_ = _local2.animatedChar_;
        }
    }

    public function setTexture(_arg_1:int):void {
        var _local2:TextureData = ObjectLibrary.typeToTextureData_[_arg_1];
        this.texture = _local2.texture_;
        this.mask_ = _local2.mask_;
        this.animatedChar_ = _local2.animatedChar_;
    }

    public function setAltTexture(_arg_1:int):void {
        var _local3:* = null;
        var _local2:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
        if (_arg_1 == 0) {
            _local3 = _local2;
        } else {
            _local3 = _local2.getAltTextureData(_arg_1);
            if (_local3 == null) {
                return;
            }
        }
        this.texture = _local3.texture_;
        this.mask_ = _local3.mask_;
        this.animatedChar_ = _local3.animatedChar_;
        if (this.effect_) {
            trace("removed eff ", this.effect_.objectId_)
            this.map_.removeObj(this.effect_.objectId_);
            this.effect_ = null;
        }
        if (_local3.effectProps_ && !Parameters.data.noParticlesMaster) {
            this.effect_ = ParticleEffect.fromProps(_local3.effectProps_, this);
            if (this.map_) {
                this.map_.addObj(this.effect_, x_, y_);
            }
        }
    }

    public function setTex1(_arg_1:int):void {
        if (_arg_1 == this.tex1Id_) {
            return;
        }
        this.tex1Id_ = _arg_1;
        this.texturingCache_ = new Dictionary();
        this.portrait_ = null;
    }

    public function setTex2(_arg_1:int):void {
        if (_arg_1 == this.tex2Id_) {
            return;
        }
        this.tex2Id_ = _arg_1;
        this.texturingCache_ = new Dictionary();
        this.portrait_ = null;
    }

    public function playSound(_arg_1:int):void {
        SoundEffectLibrary.play(this.props_.sounds_[_arg_1]);
    }

    public function isQuiet_():Boolean {
        return (this.condition_[0] & 2) != 0;
    }

    public function isWeak_():Boolean {
        return (this.condition_[0] & 4) != 0;
    }

    public function isSlowed_():Boolean {
        return (this.condition_[0] & 8) != 0;
    }

    public function isSick_():Boolean {
        return (this.condition_[0] & 16) != 0;
    }

    public function isDazed_():Boolean {
        return (this.condition_[0] & 32) != 0;
    }

    public function isStunned_():Boolean {
        return (this.condition_[0] & 64) != 0;
    }

    public function isBlind_():Boolean {
        if ((256 & Parameters.data.ccdebuffBitmask) > 0) {
            return false;
        }
        return (this.condition_[0] & 128) != 0;
    }

    public function isDrunk_():Boolean {
        if ((1024 & Parameters.data.ccdebuffBitmask) > 0) {
            return false;
        }
        return (this.condition_[0] & 512) != 0;
    }

    public function isBleeding_():Boolean {
        return (this.condition_[0] & 32768) != 0;
    }

    public function isConfused_():Boolean {
        if ((2048 & Parameters.data.ccdebuffBitmask) > 0) {
            return false;
        }
        return (this.condition_[0] & 1024) != 0;
    }

    public function isStunImmune_():Boolean {
        return (this.condition_[0] & 2048) != 0 || this.isStunImmuneVar;
    }

    public function isInvisible_():Boolean {
        return (this.condition_[0] & 4096) != 0;
    }

    public function isParalyzed_():Boolean {
        return (this.condition_[0] & 8192) != 0;
    }

    public function isSpeedy_():Boolean {
        return (this.condition_[0] & 16384) != 0;
    }

    public function isNinjaSpeedy_():Boolean {
        return (this.condition_[0] & 268435456) != 0;
    }

    public function isHallucinating_():Boolean {
        if ((512 & Parameters.data.ccdebuffBitmask) > 0) {
            return false;
        }
        return (this.condition_[0] & 256) != 0;
    }

    public function isHealing_():Boolean {
        return (this.condition_[0] & 131072) != 0;
    }

    public function isDamaging_():Boolean {
        return (this.condition_[0] & 262144) != 0;
    }

    public function isBerserk_():Boolean {
        return (this.condition_[0] & 524288) != 0;
    }

    public function isPaused_():Boolean {
        return (this.condition_[0] & 1048576) != 0;
    }

    public function isStasis_():Boolean {
        return (this.condition_[0] & 2097152) != 0;
    }

    public function isInvincible_():Boolean {
        return this.isInvincibleXML || (this.condition_[0] & 8388608) != 0;
    }

    public function isInvulnerable_():Boolean {
        return (this.condition_[0] & 16777216) != 0;
    }

    public function isArmored_():Boolean {
        return (this.condition_[0] & 33554432) != 0;
    }

    public function isArmorBroken_():Boolean {
        return (this.condition_[0] & 67108864) != 0;
    }

    public function isStasisImmune():Boolean {
        return this.isStasisImmune_ || (this.condition_[0] & 4194304) != 0;
    }

    public function isArmorBrokenImmune_():Boolean {
        return (this.condition_[0] & 65536) != 0;
    }

    public function isSlowedImmune_() : Boolean {
        return this.isSlowedImmuneVar || (this.condition_[1] & 1) != 0;
    }

    public function isUnstable_():Boolean {
        if ((1073741824 & Parameters.data.ccdebuffBitmask) > 0) {
            return false;
        }
        return (this.condition_[0] & 536870912) != 0;
    }

    public function isShowPetEffectIcon_():Boolean {
        return (this.condition_[1] & 37) != 0;
    }

    public function isDarkness_():Boolean {
        if ((-2147483648 & Parameters.data.ccdebuffBitmask) > 0) {
            return false;
        }
        return (this.condition_[1] & 1073741824) != 0;
    }

    public function isParalyzeImmune_():Boolean {
        return this.isParalyzeImmuneVar || (this.condition_[1] & 4) != 0;
    }

    public function isDazedImmune_():Boolean {
        return this.isDazedImmuneVar || (this.condition_[1] & 2) != 0;
    }

    public function isPetrified_():Boolean {
        return (this.condition_[1] & 8) != 0;
    }

    public function isPetrifiedImmune_():Boolean {
        return (this.condition_[1] & 16) != 0;
    }

    public function isCursed_():Boolean {
        return (this.condition_[1] & 64) != 0;
    }

    public function isCursedImmune_():Boolean {
        return (this.condition_[1] & 128) != 0;
    }

    public function isSilenced_():Boolean {
        return (this.condition_[1] & 65536) != 0;
    }

    public function isExposed_():Boolean {
        return (this.condition_[1] & 131072) != 0;
    }

    public function isInspired() : Boolean {
        return (this.condition_[1] & 0x8000000) != 0;
    }

    public function isSafe(_arg_1:int = 20):Boolean {
        var _local4:int = 0;
        var _local3:int = 0;
        var _local2:* = null;
        var _local6:int = 0;
        var _local5:* = map_.goDict_;
        for each(_local2 in map_.goDict_) {
            if (_local2 is Character && _local2.props_.isEnemy_) {
                _local4 = x_ > _local2.x_ ? x_ - _local2.x_ : Number(_local2.x_ - x_);
                _local3 = y_ > _local2.y_ ? y_ - _local2.y_ : Number(_local2.y_ - y_);
                if (_local4 < _arg_1 && _local3 < _arg_1) {
                    return false;
                }
            }
        }
        return true;
    }

    public function getName():String {
        return this.name_ == null || this.name_ == "" ? ObjectLibrary.typeToDisplayId_[this.objectType_] : this.name_;
    }

    public function getColor():uint {
        if (this.props_.color_ != -1) {
            return this.props_.color_;
        }
        return BitmapUtil.mostCommonColor(this.texture);
    }

    public function getBulletId():uint {
        var _local1:uint = this.nextBulletId_;
        this.nextBulletId_ = (this.nextBulletId_ + 1) % 128;
        return _local1;
    }

    public function distTo(_arg_1:WorldPosData):Number {
        var _local2:Number = _arg_1.x_ - x_;
        var _local3:Number = _arg_1.y_ - y_;
        return Math.sqrt(_local2 * _local2 + _local3 * _local3);
    }

    public function toggleShockEffect(_arg_1:Boolean):void {
        if (_arg_1) {
            this.isShocked = true;
        } else {
            this.isShocked = false;
            this.isShockedTransformSet = false;
        }
    }

    public function toggleChargingEffect(_arg_1:Boolean):void {
        if (_arg_1) {
            this.isCharging = true;
        } else {
            this.isCharging = false;
            this.isChargingTransformSet = false;
        }
    }

    public function moveTo(_arg_1:Number, _arg_2:Number):Boolean {
        var _local3:Square = map_.getSquare(_arg_1, _arg_2);
        if (_local3 == null) {
            return false;
        }
        x_ = _arg_1;
        y_ = _arg_2;
        if (this.props_.static_) {
            if (square) {
                square.obj_ = null;
            }
            _local3.obj_ = this;
        }
        square = _local3;
        return true;
    }

    public function footer(_arg_1:String):void {
        var _local2:CharacterStatusText = new CharacterStatusText(this, 0xffffff, -1);
        _local2.setText(_arg_1);
        map_.mapOverlay_.addStatusText(_local2);
        this.footer_ = _local2;
    }

    public function mobInfo(_arg_1:String):void {
        var _local2:CharacterStatusText = new CharacterStatusText(this, 0xffffff, 0x7fffffff);
        _local2.setText(_arg_1);
        map_.mapOverlay_.addStatusText(_local2);
    }

    public function onGoto(_arg_1:Number, _arg_2:Number, _arg_3:int):void {
        this.moveTo(_arg_1, _arg_2);
        this.lastTickUpdateTime_ = _arg_3;
        this.tickPosition_.x = _arg_1;
        this.tickPosition_.y = _arg_2;
        this.posAtTick_.x = _arg_1;
        this.posAtTick_.y = _arg_2;
        this.moveVec_.x = 0;
        this.moveVec_.y = 0;
    }

    public function onTickPos(_arg_1:Number, _arg_2:Number, _arg_3:int, _arg_4:int):void {
        if (this.myLastTickId_ < map_.gs_.gsc_.lastTickId_) {
            this.moveTo(this.tickPosition_.x, this.tickPosition_.y);
        }
        this.lastTickUpdateTime_ = map_.gs_.lastUpdate_;
        this.tickPosition_.x = _arg_1;
        this.tickPosition_.y = _arg_2;
        this.posAtTick_.x = x_;
        this.posAtTick_.y = y_;
        this.moveVec_.x = (this.tickPosition_.x - this.posAtTick_.x) / _arg_3;
        this.moveVec_.y = (this.tickPosition_.y - this.posAtTick_.y) / _arg_3;
        this.myLastTickId_ = _arg_4;
        _arg_1 = Math.atan2(this.moveVec_.y, this.moveVec_.x);
        _arg_2 = _arg_1;
        this.jittery = _arg_2 > _arg_1 + 0.785398163397448 || _arg_2 < _arg_1 - 0.785398163397448;
    }

    public function damage(_arg_1:Boolean, _arg_2:int, _arg_3:Vector.<uint>, _arg_4:Boolean, _arg_5:Projectile, _arg_6:Boolean = false):void {
        var _local15:int = 0;
        var _local14:int = 0;
        var _local9:* = undefined;
        var _local11:Boolean = false;
        var _local7:Boolean = false;
        var _local8:int = 0;
        var _local16:* = null;
        var _local12:CharacterStatusText = null;
        var _local13:* = null;
        var _local17:* = null;
        var _local10:* = null;
        if (_arg_4) {
            this.dead_ = true;
        } else if (_arg_3) {
            _arg_4 = !Parameters.data.ignoreStatusText;
            _local15 = 0;
            var _local20:int = 0;
            var _local19:* = _arg_3;
            for each(_local14 in _arg_3) {
                _local16 = null;
                if (_arg_5 && _arg_5.projProps_.isPetEffect_ && _arg_5.projProps_.isPetEffect_[_local14]) {
                    _local13 = StaticInjectorContext.getInjector().getInstance(PetsModel);
                    _local17 = _local13.getActivePet();
                    if (_local17) {
                        _local16 = ConditionEffect.effects_[_local14];
                        if (_arg_4) {
                            this.showConditionEffectPet(_local15, _local16.name_);
                        }
                        _local15 = _local15 + 500;
                    }
                } else {
                    _local8 = !!_arg_6 ? 0xff00ff : 16711680;
                    var _local18:* = _local14;
                    switch (_local18) {
                        case ConditionEffect.NOTHING:
                            break;
                        case ConditionEffect.WEAK:
                        case ConditionEffect.SICK:
                        case ConditionEffect.BLIND:
                        case ConditionEffect.HALLUCINATING:
                        case ConditionEffect.DRUNK:
                        case ConditionEffect.CONFUSED:
                        case ConditionEffect.STUN_IMMUNE:
                        case ConditionEffect.INVISIBLE:
                        case ConditionEffect.SPEEDY:
                        case ConditionEffect.BLEEDING:
                        case ConditionEffect.STASIS_IMMUNE:
                        case ConditionEffect.NINJA_SPEEDY:
                        case ConditionEffect.UNSTABLE:
                        case ConditionEffect.DARKNESS:
                        case ConditionEffect.PETRIFIED_IMMUNE:
                            _local16 = ConditionEffect.effects_[_local14];
                            break;
                        case ConditionEffect.QUIET:
                            if (this.map_.player_ == this) {
                                this.map_.player_.mp_ = 0;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            break;
                        case ConditionEffect.STASIS:
                            if (this.isStasisImmune_) {
                                _local12 = new CharacterStatusText(this, 0xff0000, 50 * 60);
                                _local12.setText("Immune");
                                map_.mapOverlay_.addStatusText(_local12);
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            break;
                        case ConditionEffect.SLOWED:
                            if (this.isSlowedImmune) {
                                if (_arg_4) {
                                    _local12 = new CharacterStatusText(this, _local8, 50 * 60);
                                    _local12.setText("Immune");
                                    this.map_.mapOverlay_.addStatusText(_local12);
                                    break;
                                }
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            break;
                        case ConditionEffect.ARMOR_BROKEN:
                            if (this.isArmorBrokenImmune) {
                                if (_arg_4) {
                                    _local12 = new CharacterStatusText(this, _local8, 50 * 60);
                                    _local12.setText("Immune");
                                    this.map_.mapOverlay_.addStatusText(_local12);
                                    break;
                                }
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            break;
                        case ConditionEffect.STUNNED:
                            if (this.isStunImmune) {
                                if (_arg_4) {
                                    _local12 = new CharacterStatusText(this, _local8, 50 * 60);
                                    _local12.setText("Immune");
                                    this.map_.mapOverlay_.addStatusText(_local12);
                                    break;
                                }
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            this.isStunned = true;
                            break;
                        case ConditionEffect.DAZED:
                            if (this.isDazedImmune) {
                                if (_arg_4) {
                                    _local12 = new CharacterStatusText(this, _local8, 50 * 60);
                                    _local12.setText("Immune");
                                    this.map_.mapOverlay_.addStatusText(_local12);
                                    break;
                                }
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            this.isDazed = true;
                            break;
                        case ConditionEffect.PARALYZED:
                            if (this.isParalyzeImmune) {
                                if (_arg_4) {
                                    _local12 = new CharacterStatusText(this, _local8, 50 * 60);
                                    _local12.setText("Immune");
                                    this.map_.mapOverlay_.addStatusText(_local12);
                                    break;
                                }
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            this.isParalyzed = true;
                            break;
                        case ConditionEffect.PETRIFIED:
                            if (this.isPetrifiedImmune) {
                                if (_arg_4) {
                                    _local12 = new CharacterStatusText(this, _local8, 50 * 60);
                                    _local12.setText("Immune");
                                    this.map_.mapOverlay_.addStatusText(_local12);
                                    break;
                                }
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            this.isPetrified = true;
                            break;
                        case ConditionEffect.CURSE:
                            if (this.isCursedImmune) {
                                if (_arg_4) {
                                    _local12 = new CharacterStatusText(this, _local8, 50 * 60);
                                    _local12.setText("Immune");
                                    this.map_.mapOverlay_.addStatusText(_local12);
                                    break;
                                }
                                break;
                            }
                            _local16 = ConditionEffect.effects_[_local14];
                            break;
                        case ConditionEffect.GROUND_DAMAGE:
                            _local7 = true;
                            break;
                    }
                    if (_local16) {
                        if (_local14 < 32) {
                            if ((this.condition_[0] | _local16.bit_) != this.condition_[0]) {
                                this.condition_[0] = this.condition_[0] | _local16.bit_;
                            } else {
                                continue;
                            }
                        } else if ((this.condition_[1] | _local16.bit_) != this.condition_[1]) {
                            this.condition_[1] = this.condition_[1] | _local16.bit_;
                        } else {
                            continue;
                        }
                        _local10 = _local16.localizationKey_;
                        if (!Parameters.data.ignoreStatusText) {
                            this.showConditionEffect(_local15, _local10);
                        }
                        _local15 = _local15 + 500;
                    }
                }
            }
        }
        if (!(this.props_.isEnemy_ && Parameters.data.disableEnemyParticles) && !(!this.props_.isEnemy_ && Parameters.data.disablePlayersHitParticles) && this.texture) {
            if (!Parameters.data.liteParticle) {
                _local9 = this.getBloodComposition(this.objectType_, this.texture, this.props_.bloodProb_, this.props_.bloodColor_);
                if (this.dead_) {
                    map_.addObj(new ExplosionEffect(_local9, this.size_, 30), x_, y_);
                } else if (_arg_5) {
                    map_.addObj(new HitEffect(_local9, this.size_, 10, _arg_5.angle_, _arg_5.projProps_.speed_), x_, y_);
                } else {
                    map_.addObj(new ExplosionEffect(_local9, this.size_, 10), x_, y_);
                }
            } else {
                _local9 = this.getBloodComposition(this.objectType_, this.texture, this.props_.bloodProb_, this.props_.bloodColor_);
                if (this.dead_) {
                    map_.addObj(new ExplosionEffect(_local9, this.size_, 30), x_, y_);
                } else if (_arg_5) {
                    map_.addObj(new HitEffect(_local9, this.size_, 10, _arg_5.angle_, _arg_5.projProps_.speed_), x_, y_);
                } else {
                    map_.addObj(new ExplosionEffect(_local9, this.size_, 10), x_, y_);
                }
            }
        }
        if (!_arg_1 && (Parameters.data.noEnemyDamage && this.props_.isEnemy_ || Parameters.data.noAllyDamage && this.props_.isPlayer_)) {
            return;
        }
        if (_arg_2 > 0 && !this.dead_ && this.map_) {
            if (Parameters.data.autoDecrementHP && this != this.map_.player_) {
                this.hp_ = this.hp_ - _arg_2;
            }
            _local11 = this.isArmorBroken || _arg_5 && _arg_5.projProps_.armorPiercing_ || _local7 || _arg_6;
            this.showDamageText(_arg_2, _local11);
        }
    }

    public function showConditionEffect(_arg_1:int, _arg_2:String):void {
        var _local3:CharacterStatusText = null;
        if (this.texture) {
            _local3 = new CharacterStatusText(this, 0xff0000, 50 * 60, _arg_1);
            _local3.setText(_arg_2);
            map_.mapOverlay_.addStatusText(_local3);
        }
    }

    public function showConditionEffectPet(_arg_1:int, _arg_2:String):void {
        var _local3:CharacterStatusText = null;
        if (this.texture) {
            _local3 = new CharacterStatusText(this, 0xff0000, 50 * 60, _arg_1);
            _local3.setText("Pet " + _arg_2);
            map_.mapOverlay_.addStatusText(_local3);
        }
    }

    public function showDamageText(_arg_1:int, _arg_2:Boolean):void {
        var _local3:String = null;
        var _local4:CharacterStatusText = null;
        if (this.texture) {
            _local3 = "-" + _arg_1;
            if (!Parameters.data.dynamicHPcolor) {
                _local4 = new CharacterStatusText(this, !!_arg_2 ? 0x9000ff : 16711680, 1000);
            } else {
                _local4 = new CharacterStatusText(this, !!_arg_2 ? 0x9000ff : Character.green2redu((this.hp_ - _arg_1) * 100 / this.maxHP_), 1000);
            }
            _local4.setText(_local3);
            map_.mapOverlay_.addStatusText(_local4);
        }
    }

    public function drawName(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:Boolean):void {
        if (Parameters.lowCPUMode) {
            return;
        }
        if (this.nameBitmapData_ == null) {
            this.nameBitmapData_ = this.makeNameBitmapData();
            this.nameFill_ = new GraphicsBitmapFill(null, new Matrix(), false, false);
        }
        var _local4:int = this.nameBitmapData_.width * 0.5 + 1;
        var _local6:Vector.<Number> = new Vector.<Number>();
        _local6.length = 0;
        if (_arg_3) {
            _local6.push(posS_[0] - _local4, posS_[1] + 12, posS_[0] + _local4, posS_[1] + 12, posS_[0] + _local4, posS_[1] + 42, posS_[0] - _local4, posS_[1] + 42);
        } else {
            _local6.push(posS_[0] - _local4, posS_[1], posS_[0] + _local4, posS_[1], posS_[0] + _local4, posS_[1] + 30, posS_[0] - _local4, posS_[1] + 30);
        }
        this.nameFill_.bitmapData = this.nameBitmapData_;
        var _local7:Matrix = this.nameFill_.matrix;
        _local7.identity();
        _local7.translate(_local6[0], _local6[1]);
        _arg_1.push(this.nameFill_);
    }

    public function useAltTexture(_arg_1:String, _arg_2:int):void {
        this.texture = AssetLibrary.getImageFromSet(_arg_1, _arg_2);
        this.sizeMult_ = this.texture.height * 0.125;
    }

    public function getPortrait():BitmapData {
        var _local1:* = null;
        var _local2:int = 0;
        if (this.portrait_ == null) {
            _local1 = this.props_.portrait_ != null ? this.props_.portrait_.getTexture() : this.texture;
            _local2 = 4 / _local1.width * 100;
            this.portrait_ = TextureRedrawer.resize(_local1, this.mask_, _local2, true, this.tex1Id_, this.tex2Id_);
            this.portrait_ = GlowRedrawer.outlineGlow(this.portrait_, 0);
        }
        return this.portrait_;
    }

    public function setAttack(_arg_1:int, _arg_2:Number):void {
        this.attackAngle_ = _arg_2;
        this.attackStart_ = getTimer();
    }

    public function drawConditionIcons(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
        var _local9:Number = NaN;
        var _local8:Number = NaN;
        var _local5:int = 0;
        var _local7:int = 0;
        var _local10:* = null;
        var _local14:* = null;
        var _local4:* = null;
        var _local13:* = null;
        var _local15:int = _arg_3 * 0.002;
        if (this.icons_ == null) {
            this.icons_ = new Vector.<BitmapData>();
            this.iconFills_ = new Vector.<GraphicsBitmapFill>();
            this.iconPaths_ = new Vector.<GraphicsPath>();
            this.icons_.length = 0;
            _local5 = this.condition_[0];
            _local7 = this.condition_[1];
            ConditionEffect.getConditionEffectIcons(_local5, this.icons_, _local15);
            ConditionEffect.getConditionEffectIcons2(_local7, this.icons_, _local15);
        } else {
            _local5 = this.condition_[0];
            _local7 = this.condition_[1];
            if (this.lastCon1 != _local5 || this.lastCon2 != _local7) {
                this.lastCon1 = _local5;
                this.lastCon2 = _local7;
                this.icons_.length = 0;
                ConditionEffect.getConditionEffectIcons(_local5, this.icons_, _local15);
                ConditionEffect.getConditionEffectIcons2(_local7, this.icons_, _local15);
            }
        }
        var _local11:Number = this.posS_[3];
        var _local12:Number = this.vS_[1];
        var _local6:int = this.icons_.length;
        _arg_3 = 0;
        while (_arg_3 < _local6) {
            _local10 = this.icons_[_arg_3];
            if (_arg_3 >= this.iconFills_.length) {
                this.iconFills_.push(new GraphicsBitmapFill(null, new Matrix(), false, false));
                this.iconPaths_.push(new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>()));
                _local6 = this.icons_.length;
            }
            _local14 = this.iconFills_[_arg_3];
            _local4 = this.iconPaths_[_arg_3];
            _local14.bitmapData = _local10;
            _local9 = _local11 - _local10.width * _local6 * 0.5 + _arg_3 * _local10.width;
            _local8 = _local12 - _local10.height * 0.5;
            _local4.data.length = 0;
            (_local4.data as Vector.<Number>).push(_local9, _local8, _local9 + _local10.width, _local8, _local9 + _local10.width, _local8 + _local10.height, _local9, _local8 + _local10.height);
            _local13 = _local14.matrix;
            _local13.identity();
            _local13.translate(_local9, _local8);
            _arg_1.push(_local14);
            _arg_3++;
        }
    }

    public function clearTextureCache():void {
        var _local5:* = null;
        var _local2:* = null;
        var _local1:* = null;
        var _local4:* = null;
        var _local3:* = null;
        if (this.texturingCache_ != null) {
            for each(_local5 in this.texturingCache_) {
                _local2 = _local5 as BitmapData;
                if (_local2 != null) {
                    _local2.dispose();
                } else {
                    _local1 = _local5 as Dictionary;
                    for each(_local4 in _local1) {
                        _local3 = _local4 as BitmapData;
                        if (_local3 != null) {
                            _local3.dispose();
                        }
                    }
                }
            }
        }
        this.texturingCache_ = new Dictionary();
    }

    public function toString():String {
        return "[" + getQualifiedClassName(this) + " id: " + objectId_ + " itemType: " + ObjectLibrary.typeToDisplayId_[this.objectType_] + " pos: " + x_ + ", " + y_ + "]";
    }

    public function setSize(_arg_1:int):void {
        if (_arg_1 == this.size_) {
            return;
        }
        this.size_ = _arg_1;
        this.texturingCache_ = new Dictionary();
        this.portrait_ = null;
    }

    protected function makeNameBitmapData():BitmapData {
        var _local1:StringBuilder = new StaticStringBuilder(this.name_);
        var _local2:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
        return _local2.make(_local1, 16, 0xffffff, true, IDENTITY_MATRIX, true);
    }

    protected function getHallucinatingTexture():BitmapData {
        if (this.hallucinatingTexture_ == null) {
            this.hallucinatingTexture_ = AssetLibrary.getImageFromSet("lofiChar8x8", int(Math.random() * 239));
        }
        return this.hallucinatingTexture_;
    }

    protected function getRangeCircle(rangeOverride:Number = -1) : BitmapData {
        // magic number, really not sure why the 0.7 is needed, prob some scaling issue
        // between gameobjects and tiles (75px @ 1 mscale)
        var range2px:Number = (rangeOverride == -1 ? this.props_.maxRange : rangeOverride)
                * 75 * 0.7;
        if (rangeCache[range2px])
            return rangeCache[range2px];

        var rangeSprite:Sprite = new Sprite();
        rangeSprite.graphics.lineStyle(5, 0xFF00FF);
        rangeSprite.graphics.drawCircle(0, 0, range2px);

        var tex:BitmapData = new BitmapData(rangeSprite.width, rangeSprite.height, true, 0x000000);
        var bounds:Rectangle = rangeSprite.getBounds(rangeSprite);
        var m:Matrix = new Matrix();
        m.translate(-bounds.x, -bounds.y);
        tex.draw(rangeSprite, m);

        rangeCache[range2px] = tex;
        return tex;
    }

    protected function getTexture(_arg_1:Camera, _arg_2:int):BitmapData {
        var _local7:* = NaN;
        var _local4:int = 0;
        var _local3:int = 0;
        var _local11:int = 0;
        var _local5:* = null;
        var _local6:* = null;
        var _local10:* = null;
        var _local13:* = null;
        var _local8:* = null;
        if (this is Pet) {
            _local6 = this as Pet;
            if (this.condition_[0] != 0 && !this.isPaused) {
                if (_local6.skinId != 0x8090) {
                    _local6.setSkin(0x8090);
                }
            } else if (!_local6.isDefaultAnimatedChar) {
                _local6.setDefaultSkin();
            }
        }
        var _local9:BitmapData = this.texture;
        var _local12:int = this.size_;
        if (this is Container && Parameters.data.bigLootBags && (this as Container).drawMeBig_) {
            _local12 = 200;
        }
        if (_local9.height == 64)
            _local12 = 25;
        if (this.animatedChar_) {
            _local7 = 0;
            _local4 = 0;
            if (_arg_2 < this.attackStart_ + 5 * 60) {
                if (!this.props_.dontFaceAttacks_) {
                    this.facing_ = this.attackAngle_;
                }
                _local7 = Number((_arg_2 - this.attackStart_) % 300 / 300);
                _local4 = 2;
            } else if (this.moveVec_.x != 0 || this.moveVec_.y != 0) {
                _local3 = 0.5 / this.moveVec_.length;
                _local3 = _local3 + (400 - _local3 % 400);
                if (this.moveVec_.x > 0.00001 || this.moveVec_.x < -0.00001 || this.moveVec_.y > 0.00001 || this.moveVec_.y < -0.00001) {
                    if (!this.props_.dontFaceMovement_) {
                        this.facing_ = Math.atan2(this.moveVec_.y, this.moveVec_.x);
                    }
                    _local4 = 1;
                } else {
                    _local4 = 0;
                }
                _local7 = Number(_arg_2 % _local3 / _local3);
            }
            _local10 = this.animatedChar_.imageFromFacing(this.facing_, _arg_1, _local4, _local7);
            _local9 = _local10.image_;
            _local5 = _local10.mask_;
        } else if (this.animations_) {
            _local13 = this.animations_.getTexture(_arg_2);
            if (_local13) {
                _local9 = _local13;
            }
        }
        if (this.props_.drawOnGround_) {
            return _local9;
        }
        if (_arg_1.isHallucinating_) {
            _local11 = _local9 == null ? 8 : _local9.width;
            _local9 = this.getHallucinatingTexture();
            _local5 = null;
            _local12 = this.size_ * Math.min(1.5, _local11 / _local9.width);
        }
        if (!(this is Pet)) {
            if (this.isStasis || this.isPetrified) {
                _local9 = CachingColorTransformer.filterBitmapData(_local9, PAUSED_FILTER);
            }
        }
        if (this.tex1Id_ == 0 && this.tex2Id_ == 0) {
            if (this.isCursed && Parameters.data.curseIndication) {
                _local9 = TextureRedrawer.redraw(_local9, _local12, false, 0xff0000);
            } else {
                _local9 = TextureRedrawer.redraw(_local9, _local12, false, 0, true, 5, 0);
            }
        } else {
            _local8 = null;
            if (this.texturingCache_ == null) {
                this.texturingCache_ = new Dictionary();
            } else {
                _local8 = this.texturingCache_[_local9];
            }
            if (_local8 == null) {
                _local8 = TextureRedrawer.resize(_local9, _local5, _local12, false, this.tex1Id_, this.tex2Id_);
                _local8 = GlowRedrawer.outlineGlow(_local8, 0);
                this.texturingCache_[_local9] = _local8;
            }
            _local9 = _local8;
        }
        if (_local6 && !this.myPet && Parameters.data.alphaOnOthers && !map_.isPetYard) {
            _local9 = CachingColorTransformer.alphaBitmapData(_local9, Parameters.data.alphaMan);
        }
        return _local9;
    }

    protected function drawHpBar(param1:Vector.<GraphicsBitmapFill>, param2:int = 6) : void {
        var _loc7_:Number = NaN;
        var _loc3_:Number = NaN;
        var _loc6_:uint = 0;
        if (this.hpBarFill == null || this.hpBarBackFill == null) {
            this.hpBarFill = new GraphicsBitmapFill();
            this.hpBarBackFill = new GraphicsBitmapFill();
        }
        if (this.hp_ > this.maxHP_)
            this.maxHP_ = this.hp_;
        this.hpBarBackFill.bitmapData = TextureRedrawer.redrawSolidSquare(1118481,42,7,-1);
        var _loc4_:int = posS_[0];
        var _loc5_:int = posS_[1];
        this.hpBarBackFillMatrix.identity();
        this.hpBarBackFillMatrix.translate(_loc4_ - 20 - 1 - 5,_loc5_ + param2 - 1);
        this.hpBarBackFill.matrix = this.hpBarBackFillMatrix;
        param1.push(this.hpBarBackFill);
        var _loc8_:int = this.hp_;
        if (_loc8_ > 0) {
            _loc7_ = _loc8_ / this.maxHP_;
            _loc3_ = _loc7_ * 40;
            _loc6_ = Character.green2redu(_loc7_ * 100);
            this.hpBarFill.bitmapData = TextureRedrawer.redrawSolidSquare(_loc6_,_loc3_,5,-1);
            this.hpBarFillMatrix.identity();
            this.hpBarFillMatrix.translate(_loc4_ - 20 - 5,_loc5_ + param2);
            this.hpBarFill.matrix = this.hpBarFillMatrix;
            param1.push(this.hpBarFill);
        }
    }

    private function bHPBarParamCheck():Boolean {
        return Parameters.data.HPBar == 1
                || Parameters.data.HPBar == 2 && this.props_.isEnemy_
                || Parameters.data.HPBar == 3 && (this == map_.player_ || this.props_.isEnemy_)
                || Parameters.data.HPBar == 4 && this == map_.player_
                || Parameters.data.HPBar == 5 && this.props_.isPlayer_;
    }
}
}
