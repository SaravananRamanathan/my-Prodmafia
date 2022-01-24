package kabam.rotmg.fame.service {
import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
import com.company.util.DateFormatterReplacement;

import flash.events.TimerEvent;
import flash.utils.Timer;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.assets.model.CharacterTemplate;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

public class RequestCharacterFameTask extends BaseTask {


    public function RequestCharacterFameTask() {
        timer = new Timer(150);
        super();
    }
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var classes:ClassesModel;
    public var accountId:String;
    public var charId:int;
    public var xml:XML;
    public var name:String;
    public var level:int;
    public var type:int;
    public var deathDate:String;
    public var killer:String;
    public var totalFame:int;
    public var template:CharacterTemplate;
    public var texture1:int;
    public var texture2:int;
    public var size:int;
    public var timer:Timer;
    private var errorRetry:Boolean = false;

    override protected function startTask():void {
        this.timer.addEventListener("timer", this.sendFameRequest);
        this.timer.start();
    }

    private function getDataPacket():Object {
        var _local1:* = {};
        _local1.accountId = this.accountId;
        _local1.charId = this.accountId == "" ? -1 : this.charId;
        return _local1;
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.parseFameData(_arg_2);
        } else {
            this.onFameError(_arg_2);
        }
    }

    private function parseFameData(_arg_1:String):void {
        this.xml = new XML(_arg_1);
        this.parseXML();
        completeTask(true);
    }

    private function parseXML():void {
        var _local3:* = null;
        var _local2:* = null;
        var _local1:* = null;
        var _local4:* = this.xml.Char;
        var _local5:int = 0;
        var _local7:* = new XMLList("");
        _local3 = this.xml.Char.(@id == charId)[0];
        this.name = _local3.Account.Name;
        this.level = _local3.Level;
        this.type = _local3.ObjectType;
        this.deathDate = this.getDeathDate();
        this.killer = this.xml.KilledBy || "";
        this.totalFame = this.xml.TotalFame;
        _local2 = this.classes.getCharacterClass(_local3.ObjectType);
        _local1 = "Texture" in _local3 ? _local2.skins.getSkin(_local3.Texture) : _local2.skins.getDefaultSkin();
        this.template = _local1.template;
        this.texture1 = "Tex1" in _local3 ? _local3.Tex1 : 0;
        this.texture2 = "Tex2" in _local3 ? _local3.Tex2 : 0;
        this.size = !!_local1.is16x16 ? 140 : Number(250);
    }

    private function getDeathDate():String {
        var _local3:Number = this.xml.CreatedOn * 1000;
        var _local2:Date = new Date(_local3);
        var _local1:DateFormatterReplacement = new DateFormatterReplacement();
        _local1.formatString = "MMMM D, YYYY";
        return _local1.format(_local2);
    }

    private function onFameError(_arg_1:String):void {
        if (this.errorRetry == false) {
            this.errorRetry = true;
            this.timer = new Timer(10 * 60);
            this.timer.addEventListener("timer", this.sendFameRequest);
            this.timer.start();
        } else {
            this.errorRetry = false;
            this.openDialog.dispatch(new ErrorDialog(_arg_1));
        }
    }

    private function sendFameRequest(_arg_1:TimerEvent):void {
        this.client.setMaxRetries(8);
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("char/fame", this.getDataPacket());
        this.timer.removeEventListener("timer", this.sendFameRequest);
        this.timer.stop();
        this.timer = null;
    }
}
}
