package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.RandomUtil;
import com.company.util.PointUtil;

import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

public class Camera {

    private const MAX_JITTER:Number = 0.5;
    private const JITTER_BUILDUP_MS:int = 10000;
    public static var CenterRect:Rectangle = new Rectangle(-300, -325, 10 * 60, 10 * 60);
    public static var OffCenterRect:Rectangle = new Rectangle(-300, -450, 10 * 60, 10 * 60);

    public function Camera() {
        pp_ = new PerspectiveProjection();
        wToS_ = new Matrix3D();
        wToV_ = new Matrix3D();
        vToS_ = new Matrix3D();
        nonPPMatrix_ = new Matrix3D();
        p_ = new Vector3D();
        f_ = new Vector3D();
        u_ = new Vector3D();
        r_ = new Vector3D();
        rd_ = new Vector.<Number>(16, true);
        super();
        this.pp_.focalLength = 3;
        this.pp_.fieldOfView = 48;
        this.nonPPMatrix_.appendScale(50, 50, 50);
        this.f_.x = 0;
        this.f_.y = 0;
        this.f_.z = -1;
    }
    public var x_:Number;
    public var y_:Number;
    public var z_:Number;
    public var angleRad_:Number;
    public var clipRect_:Rectangle;
    public var pp_:PerspectiveProjection;
    public var maxDist_:Number;
    public var maxDistSq_:Number;
    public var isHallucinating_:Boolean = false;
    public var wToS_:Matrix3D;
    public var wToV_:Matrix3D;
    public var vToS_:Matrix3D;
    public var nonPPMatrix_:Matrix3D;
    public var p_:Vector3D;
    public var yaw:Number = 0;
    private var f_:Vector3D;
    private var u_:Vector3D;
    private var r_:Vector3D;
    private var isJittering_:Boolean = false;
    private var jitter_:Number = 0;
    private var rd_:Vector.<Number>;

    public function configureCameraXYZ(param1:Number, param2:Number, param3:Number, param4:Point, param5:Boolean) : void {
        var _local6:Number = PointUtil.distanceXY(param1,param2,param4.x,param4.y) * Parameters.data.mouseCameraMultiplier;
        var _local7:Number = Math.atan2(param4.y - param2,param4.x - param1);
        var _local9:Number = Math.cos(_local7) * _local6 + param1;
        var _local8:Number = Math.sin(_local7) * _local6 + param2;
        this.configure(_local9,_local8,param3,Parameters.data.cameraAngle,this.correctViewingArea(Parameters.data.centerOnPlayer));
        this.isHallucinating_ = param5;
    }

    public function configureCamera(_arg_1:GameObject, _arg_2:Boolean):void {
        var _local3:Rectangle = this.correctViewingArea(Parameters.data.centerOnPlayer);
        this.configure(_arg_1.x_, _arg_1.y_, _arg_1.z_, Parameters.data.cameraAngle, _local3);
        this.isHallucinating_ = _arg_2;
    }

    public function startJitter():void {
        this.isJittering_ = true;
        this.jitter_ = 0;
    }

    public function update(_arg_1:Number):void {
        if (this.isJittering_ && this.jitter_ < 0.5) {
            this.jitter_ = this.jitter_ + _arg_1 * 0.5 / 10000;
            if (this.jitter_ > 0.5) {
                this.jitter_ = 0.5;
            }
        }
    }

    public function configure(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Rectangle):void {
        if (this.isJittering_) {
            _arg_1 = _arg_1 + RandomUtil.plusMinus(this.jitter_);
            _arg_2 = _arg_2 + RandomUtil.plusMinus(this.jitter_);
        }
        this.x_ = _arg_1;
        this.y_ = _arg_2;
        this.z_ = _arg_3;
        this.angleRad_ = _arg_4;
        this.clipRect_ = _arg_5;
        this.p_.x = _arg_1;
        this.p_.y = _arg_2;
        this.p_.z = _arg_3;
        this.r_.x = Math.cos(this.angleRad_);
        this.r_.y = Math.sin(this.angleRad_);
        this.r_.z = 0;
        this.u_.x = Math.cos(this.angleRad_ + 1.5707963267949);
        this.u_.y = Math.sin(this.angleRad_ + 1.5707963267949);
        this.u_.z = 0;
        this.rd_[0] = this.r_.x;
        this.rd_[1] = this.u_.x;
        this.rd_[2] = this.f_.x;
        this.rd_[3] = 0;
        this.rd_[4] = this.r_.y;
        this.rd_[5] = this.u_.y;
        this.rd_[6] = this.f_.y;
        this.rd_[7] = 0;
        this.rd_[8] = this.r_.z;
        this.rd_[9] = -1;
        this.rd_[10] = this.f_.z;
        this.rd_[11] = 0;
        this.rd_[12] = -this.p_.dotProduct(this.r_);
        this.rd_[13] = -this.p_.dotProduct(this.u_);
        this.rd_[14] = -this.p_.dotProduct(this.f_);
        this.rd_[15] = 1;
        this.wToV_.rawData = this.rd_;
        this.vToS_ = this.nonPPMatrix_;
        this.wToS_.identity();
        this.wToS_.append(this.wToV_);
        this.wToS_.append(this.vToS_);
        var _local6:Number = this.clipRect_.width * 0.01;
        var _local7:Number = this.clipRect_.height * 0.01;
        this.maxDist_ = Math.sqrt(_local6 * _local6 + _local7 * _local7) + 1;
        this.maxDistSq_ = this.maxDist_ * this.maxDist_;
    }

    public function correctViewingArea(center:Boolean):Rectangle {
        var _local3:Number = WebMain.STAGE.stageWidth / Parameters.data.mscale;
        var _local4:Number = WebMain.STAGE.stageHeight / Parameters.data.mscale;
        var _local2:Number = 200 * WebMain.STAGE.stageWidth / 800;
        CenterRect = new Rectangle(-(_local3 - _local2) / 2, -_local4 * 13 / 24, _local3, _local4);
        OffCenterRect = new Rectangle(-(_local3 - _local2) / 2, -_local4 * 3 / 4, _local3, _local4);
        return center ? CenterRect : OffCenterRect;
    }
}
}
