package kabam.rotmg.ui.view {
import com.company.assembleegameclient.screens.AccountScreen;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.SoundIcon;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.model.EnvironmentData;
import kabam.rotmg.ui.view.components.DarkLayer;
import kabam.rotmg.ui.view.components.MenuOptionsBar;

import org.osflash.signals.Signal;

public class TitleView extends Sprite {
    public static var TitleScreenGraphic:Class = TitleView_TitleScreenGraphic;
    public static var queueEmailConfirmation:Boolean = false;
    public static var queuePasswordPrompt:Boolean = false;
    public static var queuePasswordPromptFull:Boolean = false;
    public static var queueRegistrationPrompt:Boolean = false;

    public var playClicked:Signal;
    public var accountClicked:Signal;
    public var legendsClicked:Signal;

    private var versionText:TextFieldDisplayConcrete;
    private var copyrightText:TextFieldDisplayConcrete;
    private var menuOptionsBar:MenuOptionsBar;
    private var data:EnvironmentData;
    private var _buttonFactory:ButtonFactory;

    public function TitleView() {
        super();
        init();
    }

    public function get buttonFactory():ButtonFactory {
        return this._buttonFactory;
    }

    public function init():void {
        this._buttonFactory = new ButtonFactory();
        addChild(new DarkLayer());
        addChild(new TitleScreenGraphic());
        this.menuOptionsBar = this.makeMenuOptionsBar();
        addChild(this.menuOptionsBar);
        addChild(new AccountScreen());
        this.makeChildren();
        addChild(new SoundIcon());
    }

    public function makeText():TextFieldDisplayConcrete {
        var _local1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(12).setColor(0x7f7f7f);
        _local1.filters = [new DropShadowFilter(0, 0, 0)];
        return _local1;
    }

    public function initialize(_arg_1:EnvironmentData):void {
        this.data = _arg_1;
        this.updateVersionText();
    }

    public function putNoticeTagToOption(_arg_1:TitleMenuOption, _arg_2:String, _arg_3:int = 14, _arg_4:uint = 10092390, _arg_5:Boolean = true):void {
        _arg_1.createNoticeTag(_arg_2, _arg_3, _arg_4, _arg_5);
    }

    private function makeMenuOptionsBar():MenuOptionsBar {
        var _local1:TitleMenuOption = this._buttonFactory.getPlayButton();
        var _local3:TitleMenuOption = this._buttonFactory.getAccountButton();
        var _local4:TitleMenuOption = this._buttonFactory.getLegendsButton();
        this.playClicked = _local1.clicked;
        this.accountClicked = _local3.clicked;
        this.legendsClicked = _local4.clicked;
        var _local5:MenuOptionsBar = new MenuOptionsBar();
        _local5.addButton(_local1, "CENTER");
        _local5.addButton(_local3, "LEFT");
        _local5.addButton(_local4, "RIGHT");
        return _local5;
    }

    private function makeChildren():void {
        this.versionText = this.makeText().setHTML(true).setAutoSize("left").setVerticalAlign("middle");
        this.versionText.y = 589.45;
        addChild(this.versionText);
        this.copyrightText = this.makeText().setAutoSize("right").setVerticalAlign("middle");
        this.copyrightText.setStringBuilder(new LineBuilder().setParams("TitleView.Copyright"));
        this.copyrightText.filters = [new DropShadowFilter(0, 0, 0)];
        this.copyrightText.x = 800;
        this.copyrightText.y = 589.45;
        addChild(this.copyrightText);
    }

    private function updateVersionText():void {
        this.versionText.setStringBuilder(new StaticStringBuilder(this.data.buildLabel));
    }
}
}
