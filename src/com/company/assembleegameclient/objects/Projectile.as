package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.engine3d.Point3D;
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.map.Map;
    import com.company.assembleegameclient.map.Square;
    import com.company.assembleegameclient.objects.particles.HitEffect;
    import com.company.assembleegameclient.objects.particles.SparkParticle;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.FreeList;
    import com.company.assembleegameclient.util.RandomUtil;
    import com.company.util.GraphicsUtil;
    import com.company.util.Hit;
    import com.company.util.Trig;
    
    import flash.display.BitmapData;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsGradientFill;
    import flash.display.GraphicsPath;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    
    import kabam.rotmg.messaging.impl.GameServerConnection;
    
    public class Projectile extends BasicObject {
        
        private static var objBullIdToObjId_: Dictionary = new Dictionary();
    
        public var props_: ObjectProperties;
        public var containerProps_: ObjectProperties;
        public var projProps_: ProjectileProperties;
        public var texture_: BitmapData;
        public var bulletId_: uint;
        public var bIdMod2Flip_: int;
        public var bIdMod4Flip_: int;
        public var phase_: Number;
        public var ownerId_: int;
        public var containerType_: int;
        public var bulletType_: uint;
        public var damagesEnemies_: Boolean;
        public var damagesPlayers_: Boolean;
        public var damage_: int;
        public var sound_: String;
        public var startX_: Number;
        public var startY_: Number;
        public var startTime_: int;
        public var halfway_: Number;
        public var angle_: Number = 0;
        public var lifetime_: Number = 1.0;
        public var sinAngle_: Number;
        public var cosAngle_: Number;
        public var multiHitDict_: Dictionary;
        public var multiHitVec: Vector.<int>;
        public var p_: Point3D;
        public var lifeMul_: Number;
        public var speedMul_: Number;
        public var projHasConditions: Boolean;
        protected var shadowGradientFill_: GraphicsGradientFill;
        protected var shadowPath_: GraphicsPath;
        private var staticPoint_: Point;
        private var staticVector3D_: Vector3D;
        
        public static function findObjId(param1: int, param2: uint): int {
            return objBullIdToObjId_[param2 << 24 | param1];
        }
        
        public static function getNewObjId(param1: int, param2: uint): int {
            var _local3: int = getNextFakeObjectId();
            objBullIdToObjId_[param2 << 24 | param1] = _local3;
            return _local3;
        }
        
        public static function removeObjId(param1: int, param2: uint): void {
        }
        
        public static function dispose(): void {
            objBullIdToObjId_ = new Dictionary();
        }
        
        public function Projectile() {
            this.p_ = new Point3D(100);
            this.staticPoint_ = new Point();
            this.staticVector3D_ = new Vector3D();
            this.shadowGradientFill_ = new GraphicsGradientFill("radial", [0, 0], [0.5, 0], null, new Matrix());
            this.shadowPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>());
            super();
        }
        
        override public function addTo(param1: Map, param2: Number, param3: Number): Boolean {
            var _local4: Player = null;
            this.startX_ = param2;
            this.startY_ = param3;
            if (!super.addTo(param1, param2, param3)) {
                return false;
            }
            if (!this.containerProps_.flying_ && square.sink) {
                this.z_ = 0.1;
            } else {
                _local4 = param1.goDict_[this.ownerId_] as Player;
                if (_local4 != null && _local4.sinkLevel > 0) {
                    this.z_ = 0.5 - 0.4 * (_local4.sinkLevel / 18);
                }
            }
            return true;
        }
        
        override public function removeFromMap(): void {
            super.removeFromMap();
            removeObjId(this.ownerId_, this.bulletId_);
            this.multiHitDict_ = null;
            this.multiHitVec = null;
            FreeList.deleteObject(this);
        }
        
        override public function update(param1: int, param2: int): Boolean {
            var _local10: * = undefined;
            var _local17: * = null;
            var _local3: * = false;
            var _local15: Boolean = false;
            var _local8: Boolean = false;
            var _local5: int = 0;
            var _local9: * = false;
            var _local7: * = null;
            var _local11: * = null;
            var _local13: * = undefined;
            var _local6: * = 0;
            var _local4: * = 0;
            var _local14: int = param1 - this.startTime_;
            if (_local14 > this.lifetime_) {
                return false;
            }
            var _local16: GameServerConnection = this.map_.gs_.gsc_;
            var _local12: Point = this.staticPoint_;
            this.positionAt(_local14, _local12);
            if (!moveTo(_local12.x, _local12.y) || this.square.tileType == 0xffff) {
                if (this.damagesPlayers_) {
                    _local16.squareHit(param1, this.bulletId_, this.ownerId_);
                } else if (this.square.obj_) {
                    if (!Parameters.data.noParticlesMaster || !Parameters.data.liteParticle) {
                        if (!this.texture_) {
                            _local10 = getColors(this.texture_);
                            this.map_.addObj(new HitEffect(_local10, 100, 3, this.angle_, this.projProps_.speed_), _local12.x, _local12.y);
                        }
                    }
                }
                return false;
            }
            _local17 = this.map_.player_;
            if (!(this.ownerId_ == _local17.objectId_ && Parameters.data.PassesCover)) {
                _local7 = this.square.obj_;
                if (_local7) {
                    _local11 = _local7.props_;
                    if ((!_local11.isEnemy_ || !this.damagesEnemies_) && (_local11.enemyOccupySquare_ || !this.projProps_.passesCover_ && _local11.occupySquare_)) {
                        if (this.damagesPlayers_) {
                            _local16.otherHit(param1, this.bulletId_, this.ownerId_, _local7.objectId_);
                        } else if (!Parameters.data.noParticlesMaster) {
                            if (!this.texture_) {
                                _local10 = getColors(this.texture_);
                                this.map_.addObj(new HitEffect(_local10, 100, 3, this.angle_, this.projProps_.speed_), _local12.x, _local12.y);
                            }
                        }
                        return false;
                    }
                }
            }
            _local7 = getHit(_local12.x, _local12.y);
            if (_local7) {
                _local3 = _local17 != null;
                _local15 = _local7.props_.isEnemy_;
                _local8 = _local3 && !_local17.isPaused && (this.damagesPlayers_ || _local15 && this.ownerId_ == _local17.objectId_);
                if (_local8) {
                    _local5 = _local7.damageWithDefense(this.damage_, _local7.defense_, this.projProps_.armorPiercing_, _local7.condition_);
                    _local9 = _local7.hp_ <= _local5;
                    if (_local7 == _local17) {
                        if (_local17.subtractDamage(_local5, param1)) {
                            return false;
                        }
                        _local13 = this.projProps_.effects_;
                        if (_local13) {
                            _local14 = _local13.length;
                            _local3 = false;
                            _local6 = uint(0);
                            while (_local6 < _local14) {
                                _local4 = uint(_local13[_local6]);
                                if (_local4 > 32) {
                                    _local4 = uint(1 << _local4 & Parameters.data.ssdebuffBitmask2);
                                } else {
                                    _local4 = uint(1 << _local4 - 32 & Parameters.data.ssdebuffBitmask);
                                }
                                if (_local4 > 0) {
                                    _local3 = true;
                                }
                                _local6++;
                            }
                            if (_local3) {
                                _local7.damage(true, _local5, null, false, this);
                            } else {
                                _local7.damage(true, _local5, this.projProps_.effects_, false, this);
                                this.map_.gs_.hitQueue.push(new Hit(this.bulletId_, this.ownerId_));
                            }
                        } else {
                            _local7.damage(true, _local5, this.projProps_.effects_, false, this);
                            this.map_.gs_.hitQueue.push(new Hit(this.bulletId_, this.ownerId_));
                        }
                    } else if (_local7.props_.isEnemy_) {
                        if (_local7.props_.isCube_ && Parameters.data.fameBlockCubes || !_local7.props_.isGod_ && Parameters.data.fameBlockGodsOnly) {
                            return true;
                        }
                        _local16.enemyHit(param1, this.bulletId_, _local7.objectId_, _local9);
                        _local7.damage(true, _local5, this.projProps_.effects_, _local9, this);
                        if (isNaN(Parameters.dmgCounter[_local7.objectId_])) {
                            Parameters.dmgCounter[_local7.objectId_] = 0;
                        }
                        var _local18: * = _local7.objectId_;
                        var _local19: * = Parameters.dmgCounter[_local18] + _local5;
                        Parameters.dmgCounter[_local18] = _local19;
                    } else if (!projProps_.multiHit_) {
                        _local16.otherHit(param1, this.bulletId_, this.ownerId_, _local7.objectId_);
                    }
                }
                if (this.projProps_.multiHit_) {
                    this.multiHitDict_[_local7.objectId_] = true;
                } else {
                    return false;
                }
            }
            return true;
        }
        
        override public function draw(param1: Vector.<GraphicsBitmapFill>, param2: Camera, param3: int): void {
            var _local5: * = NaN;
            var _local6: int = 0;
            var _local8: int = 0;
            if (!Parameters.drawProj_) {
                return;
            }
            var _local4: BitmapData = this.texture_;
            if (!Parameters.data.noRotate) {
                _local5 = Number(props_.rotation_ == 0 ? 0 : Number(param3 / this.props_.rotation_));
            } else {
                _local5 = 0;
            }
            this.staticVector3D_.x = this.x_;
            this.staticVector3D_.y = this.y_;
            this.staticVector3D_.z = this.z_;
            var _local7: Number = (this.projProps_.faceDir_ || Parameters.data.projFace) ?
                    getDirectionAngle(param3) : Number(this.angle_);
            var _local9: Number = this.projProps_.noRotation_ ? param2.angleRad_ + props_.angleCorrection_ : Number(_local7 - param2.angleRad_ + this.props_.angleCorrection_ + _local5);
            p_.draw(param1, this.staticVector3D_, _local9, param2.wToS_, param2, _local4);
            if (this.projProps_.particleTrail_ && !(Parameters.data.noParticlesMaster || Parameters.data.liteParticle)) {
                _local8 = 0;
                while (_local8 < 3) {
                    if (!(this.map_ != null && this.map_.player_.objectId_ != this.ownerId_) || !(this.projProps_.particleTrailIntensity_ == -1 && Math.random() * 100 > this.projProps_.particleTrailIntensity_)) {
                        this.map_.addObj(new SparkParticle(100, this.projProps_.particleTrailColor_, this.projProps_.particleTrailLifetimeMS != -1 ? this.projProps_.particleTrailLifetimeMS : 10 * 60, 0.5, RandomUtil.plusMinus(3), RandomUtil.plusMinus(3)), this.x_, this.y_);
                    }
                    _local8++;
                }
            }
        }
        
        public function reset(param1: int, param2: int, param3: int, param4: int, param5: Number, param6: int, param7: String = "", param8: String = "", param9: Number = 1.0, param10: Number = 1.0, param11: ObjectProperties = null, param12: ProjectileProperties = null): void {
            var _local15: Number = NaN;
            clear();
            this.containerType_ = param1;
            this.bulletType_ = param2;
            this.ownerId_ = param3;
            this.bulletId_ = param4;
            this.bIdMod2Flip_ = !!(this.bulletId_ % 2) ? 1 : -1;
            this.bIdMod4Flip_ = this.bulletId_ % 4 < 2 ? 1 : -1;
            this.phase_ = this.bulletId_ % 2 == 0 ? 0 : 3.14159265358979;
            this.angle_ = Trig.boundToPI(param5);
            this.sinAngle_ = Math.sin(this.angle_);
            this.cosAngle_ = Math.cos(this.angle_);
            this.startTime_ = param6;
            this.lifeMul_ = param9;
            this.speedMul_ = param10;
            this.objectId_ = getNewObjId(this.ownerId_, this.bulletId_);
            z_ = 0.5;
            if (param11 == null) {
                this.containerProps_ = ObjectLibrary.propsLibrary_[this.containerType_];
            } else {
                this.containerProps_ = param11;
            }
            if (param12 == null) {
                this.projProps_ = this.containerProps_.projectiles_[param2];
            } else {
                this.projProps_ = param12;
            }
            this.lifetime_ = this.projProps_.lifetime_ * param9;
            this.halfway_ = this.lifetime_ * this.projProps_.speed_ * 0.5;
            this.projHasConditions = this.projProps_.effects_;
            var _local14: String = param7 != "" && this.projProps_.objectId_ == param8 ? param7 : this.projProps_.objectId_;
            this.props_ = ObjectLibrary.getPropsFromId(_local14);
            this.hasShadow_ = this.props_.shadowSize_ > 0;
            var _local13: TextureData = ObjectLibrary.typeToTextureData_[this.props_.type_];
            this.texture_ = _local13.getTexture(this.objectId_);
            this.damagesPlayers_ = this.containerProps_.isEnemy_;
            this.damagesEnemies_ = !this.damagesPlayers_;
            this.sound_ = this.containerProps_.oldSound_;
            this.multiHitDict_ = !!this.projProps_.multiHit_ ? new Dictionary() : null;
            this.multiHitVec = !!this.projProps_.multiHit_ ? new Vector.<int>(0) : null;
            if (this.projProps_.size_ >= 0) {
                _local15 = this.projProps_.size_;
            } else {
                _local15 = ObjectLibrary.getSizeFromType(this.containerType_);
            }
            this.p_.setSize(_local15 * 0.01 * 8);
            this.damage_ = 0;
        }
        
        public function setDamage(param1: int): void {
            this.damage_ = param1;
        }
        
        public function moveTo(param1: Number, param2: Number): Boolean {
            var _local3: Square = map_.getSquare(param1, param2);
            if (_local3 == null) {
                return false;
            }
            this.x_ = param1;
            this.y_ = param2;
            this.square = _local3;
            return true;
        }
        
        public function getHit(x: Number, y: Number): GameObject {
            var xDelta: Number = NaN;
            var yDelta: Number = NaN;
            var dist: Number = NaN;
            var minDist: Number = Number.MAX_VALUE;
            var bestPlayer: GameObject = null;
            var go: GameObject = null;
            if (this.damagesEnemies_) {
                for each (go in this.map_.vulnEnemyDict_) {
                    if (!(go.isInvulnerable && Parameters.data.passThroughInvuln && !this.projHasConditions)
                            && !(go.props_.ignored && !Parameters.data.damageIgnored)
                            && !(go.props_.isCube_ && Parameters.data.fameBlockCubes)
                            && !(go.props_.isGod_ && Parameters.data.fameBlockGodsOnly)) {
                        xDelta = go.x_ > x ? go.x_ - x : Number(x - go.x_);
                        if (xDelta <= 0.5) {
                            yDelta = go.y_ > y ? go.y_ - y : y - go.y_;
                            if (yDelta <= 0.5 && !(this.projProps_.multiHit_
                                    && this.multiHitDict_[go.objectId_]))
                                return go;
                        }
                    }
                }
            } else if (this.damagesPlayers_) {
                for each (go in this.map_.vulnPlayerDict_) {
                    if (!(this.projProps_.multiHit_ && this.multiHitDict_[go.objectId_])) {
                        xDelta = go.x_ > x ? go.x_ - x : x - go.x_;
                        if (xDelta <= 0.5) {
                            yDelta = go.y_ > y ? go.y_ - y : y - go.y_;
                            if (yDelta <= 0.5) {
                                if (!(this.projProps_.multiHit_ && this.multiHitDict_[go.objectId_])
                                        && go == this.map_.player_)
                                    return go;
                                
                                dist = xDelta * xDelta + yDelta * yDelta;
                                if (dist < minDist) {
                                    minDist = dist;
                                    bestPlayer = go;
                                }
                            }
                        }
                    }
                }
            }
            
            return bestPlayer;
        }
        
        private function positionAt_clean(param1: int, param2: Point): void {
            var _local8: Number = NaN;
            var _local5: Number = NaN;
            var _local6: Number = NaN;
            var _local4: Number = NaN;
            param2.x = this.startX_;
            param2.y = this.startY_;
            var _local7: Number = param1 * this.projProps_.speed_ * this.speedMul_;
            var _local3: Number = this.bulletId_ % 2 == 0 ? 0 : 3.14159265358979;
            if (this.projProps_.wavy_) {
                _local8 = this.angle_ + 0.0490873852123405 * Math.sin(_local3 + 18.8495559215388 * param1 / 1000);
                param2.x = param2.x + _local7 * Math.cos(_local8);
                param2.y = param2.y + _local7 * Math.sin(_local8);
            } else if (this.projProps_.parametric_) {
                _local8 = param1 / this.lifetime_ * 6.28318530717959;
                _local5 = Math.sin(_local8) * (!!(this.bulletId_ % 2) ? 1 : -1);
                _local6 = Math.sin(2 * _local8) * (this.bulletId_ % 4 < 2 ? 1 : -1);
                param2.x = param2.x + (_local5 * this.cosAngle_ - _local6 * this.sinAngle_) * this.projProps_.magnitude_;
                param2.y = param2.y + (_local5 * this.sinAngle_ + _local6 * this.cosAngle_) * this.projProps_.magnitude_;
            } else {
                if (this.projProps_.boomerang_) {
                    if (_local7 > this.halfway_) {
                        _local7 = this.halfway_ - (_local7 - this.halfway_);
                    }
                }
                param2.x = param2.x + _local7 * this.cosAngle_;
                param2.y = param2.y + _local7 * this.sinAngle_;
                if (this.projProps_.amplitude_ != 0) {
                    _local4 = this.projProps_.amplitude_ * Math.sin(_local3 + param1 / this.lifetime_ * this.projProps_.frequency_ * 6.28318530717959);
                    param2.x = param2.x + _local4 * Math.cos(this.angle_ + 1.5707963267949);
                    param2.y = param2.y + _local4 * Math.sin(this.angle_ + 1.5707963267949);
                }
            }
        }
        
        private function positionAt(param1: int, param2: Point): void {
            var _local7: Number = NaN;
            var _local4: Number = NaN;
            var _local5: Number = NaN;
            var _local3: Number = NaN;
            param2.x = this.startX_;
            param2.y = this.startY_;
            var _local6: Number = param1 * this.projProps_.speed_ * this.speedMul_;
            if (this.projProps_.wavy_) {
                _local7 = this.angle_ + 0.0490873852123405 * Math.sin(this.phase_ + 18.8495559215388 * param1 * 0.001);
                param2.x = param2.x + _local6 * Math.cos(_local7);
                param2.y = param2.y + _local6 * Math.sin(_local7);
            } else if (this.projProps_.parametric_) {
                _local7 = param1 / this.lifetime_ * 6.28318530717959;
                _local4 = Math.sin(_local7) * this.bIdMod2Flip_;
                _local5 = Math.sin(2 * _local7) * this.bIdMod4Flip_;
                param2.x = param2.x + (_local4 * this.cosAngle_ - _local5 * this.sinAngle_) * this.projProps_.magnitude_;
                param2.y = param2.y + (_local4 * this.sinAngle_ + _local5 * this.cosAngle_) * this.projProps_.magnitude_;
            } else {
                if (this.projProps_.boomerang_) {
                    if (_local6 > this.halfway_) {
                        _local6 = this.halfway_ - (_local6 - this.halfway_);
                    }
                }
                param2.x = param2.x + _local6 * this.cosAngle_;
                param2.y = param2.y + _local6 * this.sinAngle_;
                if (this.projProps_.amplitude_ != 0) {
                    _local3 = this.projProps_.amplitude_ * Math.sin(this.phase_ + param1 / this.lifetime_ * this.projProps_.frequency_ * 6.28318530717959);
                    param2.x = param2.x + _local3 * Math.cos(this.angle_ + 1.5707963267949);
                    param2.y = param2.y + _local3 * Math.sin(this.angle_ + 1.5707963267949);
                }
            }
        }
        
        private function getDirectionAngle(param1: int): Number {
            var _local2: int = param1 - this.startTime_;
            var _local3: Point = new Point();
            this.positionAt(_local2 + 16, _local3);
            var _local4: Number = _local3.x - x_;
            var _local5: Number = _local3.y - y_;
            return Math.atan2(_local5, _local4);
        }
    }
}
