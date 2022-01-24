package kabam.rotmg.ui.view {
import com.company.assembleegameclient.objects.ImageFactory;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.BoostPanelButton;
import com.company.assembleegameclient.ui.ExperienceBoostTimerPopup;
import com.company.assembleegameclient.ui.icons.IconButton;
import com.company.assembleegameclient.ui.icons.IconButtonFactory;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;

import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeSignal;

public class CharacterDetailsView extends Sprite {

    public static const NEXUS_BUTTON:String = "NEXUS_BUTTON";

    public static const OPTIONS_BUTTON:String = "OPTIONS_BUTTON";

    public static const IMAGE_SET_NAME:String = "lofiInterfaceBig";

    public static const NEXUS_IMAGE_ID:int = 6;

    public static const OPTIONS_IMAGE_ID:int = 5;

    public function CharacterDetailsView() {
        gotoNexus = new Signal();
        gotoOptions = new Signal();
        portrait_ = new Bitmap(null);
        nexusClicked = new NativeSignal(button, "click");
        optionsClicked = new NativeSignal(button, "click");
        super();
    }
    public var gotoNexus:Signal;
    public var gotoOptions:Signal;
    public var iconButtonFactory:IconButtonFactory;
    public var imageFactory:ImageFactory;
    public var friendsBtn:IconButton;
    private var portrait_:Bitmap;
    private var button:IconButton;
    private var nameText_:UILabel;
    private var nexusClicked:NativeSignal;
    private var optionsClicked:NativeSignal;
    private var boostPanelButton:BoostPanelButton;
    private var expTimer:ExperienceBoostTimerPopup;
    private var indicator:Sprite;

    public function init(_arg_1:String, _arg_2:String):void {
        this.indicator = new Sprite();
        this.indicator.graphics.beginFill(823807);
        this.indicator.graphics.drawCircle(0, 0, 4);
        this.indicator.graphics.endFill();
        this.indicator.x = 13;
        this.indicator.y = -5;
        this.createPortrait();
        this.createButton(_arg_2);
        this.createNameText(_arg_1);
    }

    public function addInvitationIndicator():void {
        if (this.friendsBtn) {
            this.friendsBtn.addChild(this.indicator);
        }
    }

    public function clearInvitationIndicator():void {
        if (this.indicator && this.indicator.parent) {
            this.indicator.parent.removeChild(this.indicator);
        }
    }

    public function initFriendList(_arg_1:ImageFactory, _arg_2:IconButtonFactory, _arg_3:Function, _arg_4:Boolean):void {
        this.friendsBtn = _arg_2.create(_arg_1.getImageFromSet("lofiInterfaceBig", 13), "", "Social", "", 6);
        this.friendsBtn.x = 146;
        this.friendsBtn.y = 12;
        this.friendsBtn.addEventListener("click", _arg_3);
        addChild(this.friendsBtn);
        if (_arg_4) {
            this.addInvitationIndicator();
        }
    }

    public function createNameText(_arg_1:String):void {
        this.nameText_ = new UILabel();
        this.nameText_.x = 35;
        this.nameText_.y = 6;
        this.setName(_arg_1);
        addChild(this.nameText_);
    }

    public function update(_arg_1:Player):void {
        this.portrait_.bitmapData = _arg_1.getPortrait();
    }

    public function draw(_arg_1:Player):void {
        if (this.expTimer) {
            this.expTimer.update(_arg_1.xpTimer);
        }
        if (_arg_1.tierBoost || int(_arg_1.dropBoost)) {
            this.boostPanelButton = this.boostPanelButton || new BoostPanelButton(_arg_1);
            if (this.portrait_) {
                this.portrait_.x = 13;
            }
            if (this.nameText_) {
                this.nameText_.x = 47;
            }
            this.boostPanelButton.x = 6;
            this.boostPanelButton.y = 5;
            addChild(this.boostPanelButton);
        } else if (this.boostPanelButton) {
            removeChild(this.boostPanelButton);
            this.boostPanelButton = null;
            this.portrait_.x = -2;
            this.nameText_.x = 36;
        }
    }

    public function setName(_arg_1:String):void {
        this.nameText_.text = _arg_1;
        DefaultLabelFormat.characterViewNameLabel(this.nameText_);
    }

    private function createButton(_arg_1:String):void {
        if (_arg_1 == "NEXUS_BUTTON") {
            this.button = this.iconButtonFactory.create(this.imageFactory.getImageFromSet("lofiInterfaceBig", 6), "", "CharacterDetailsView.Nexus", "escapeToNexus", 6);
            this.nexusClicked = new NativeSignal(this.button, "click", MouseEvent);
            this.nexusClicked.add(this.onNexusClick);
        } else if (_arg_1 == "OPTIONS_BUTTON") {
            this.button = this.iconButtonFactory.create(this.imageFactory.getImageFromSet("lofiInterfaceBig", 5), "", "CharacterDetailsView.Options", "options", 6);
            this.optionsClicked = new NativeSignal(this.button, "click", MouseEvent);
            this.optionsClicked.add(this.onOptionsClick);
        }
        this.button.x = 172;
        this.button.y = 12;
        addChild(this.button);
    }

    private function createPortrait():void {
        this.portrait_.x = -2;
        this.portrait_.y = -8;
        addChild(this.portrait_);
    }

    private function onNexusClick(_arg_1:MouseEvent):void {
        this.gotoNexus.dispatch();
    }

    private function onOptionsClick(_arg_1:MouseEvent):void {
        this.gotoOptions.dispatch();
    }
}
}
