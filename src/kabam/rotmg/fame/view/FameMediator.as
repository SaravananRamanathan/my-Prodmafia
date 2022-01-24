package kabam.rotmg.fame.view {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.TextureData;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.TextureRedrawer;

import flash.display.BitmapData;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.core.signals.GotoPreviousScreenSignal;
import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.core.signals.TrackPageViewSignal;
import kabam.rotmg.death.model.DeathModel;
import kabam.rotmg.fame.model.FameModel;
import kabam.rotmg.fame.service.RequestCharacterFameTask;
import kabam.rotmg.legends.view.LegendsView;
import kabam.rotmg.messaging.impl.incoming.Death;

import robotlegs.bender.bundles.mvcs.Mediator;

public class FameMediator extends Mediator {


    public function FameMediator() {
        super();
    }
    [Inject]
    public var view:FameView;
    [Inject]
    public var fameModel:FameModel;
    [Inject]
    public var deathModel:DeathModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var setScreen:SetScreenSignal;
    [Inject]
    public var gotoPrevious:GotoPreviousScreenSignal;
    [Inject]
    public var track:TrackPageViewSignal;
    [Inject]
    public var task:RequestCharacterFameTask;
    [Inject]
    public var factory:CharacterFactory;
    private var isFreshDeath:Boolean;
    private var death:Death;

    override public function initialize():void {
        this.view.closed.add(this.onClosed);
        this.track.dispatch("/fame");
        this.setViewDataFromDeath();
        this.requestFameData();
    }

    override public function destroy():void {
        this.view.closed.remove(this.onClosed);
        this.view.clearBackground();
        this.death && this.death.disposeBackground();
        this.task.finished.removeAll();
        if (this.view.remainingChallengerCharacters) {
            this.view.remainingChallengerCharacters.text = "";
            this.view.remainingChallengerCharacters = null;
        }
    }

    private function setViewDataFromDeath():void {
        this.isFreshDeath = this.deathModel.getIsDeathViewPending();
        this.view.setIsAnimation(this.isFreshDeath);
        this.death = this.deathModel.getLastDeath();
        if (this.death && this.death.background) {
            this.view.setBackground(this.death.background);
        }
    }

    private function requestFameData():void {
        this.task.accountId = this.fameModel.accountId;
        this.task.charId = this.fameModel.characterId;
        this.task.finished.addOnce(this.onFameResponse);
        this.task.start();
    }

    private function onFameResponse(_arg_1:RequestCharacterFameTask, _arg_2:Boolean, _arg_3:String = ""):void {
        var _local4:BitmapData = this.makeIcon();
        this.view.setCharacterInfo(_arg_1.name, _arg_1.level, _arg_1.type);
        this.view.setDeathInfo(_arg_1.deathDate, _arg_1.killer);
        this.view.setIcon(_local4);
        this.view.setScore(_arg_1.totalFame, _arg_1.xml);
        if (this.isFreshDeath && this.seasonalEventModel.isChallenger) {
            this.seasonalEventModel.remainingCharacters = this.seasonalEventModel.remainingCharacters - 1;
            if (this.seasonalEventModel.remainingCharacters < 0) {
                this.seasonalEventModel.remainingCharacters = 0;
            }
            this.view.addRemainingChallengerCharacters(this.seasonalEventModel.remainingCharacters);
        }
    }

    private function makeIcon():BitmapData {
        if (this.isFreshDeath && this.death.isZombie) {
            return this.makeZombieTexture();
        }
        return this.makeNormalTexture();
    }

    private function makeNormalTexture():BitmapData {
        return this.factory.makeIcon(this.task.template, this.task.size, this.task.texture1, this.task.texture2);
    }

    private function makeZombieTexture():BitmapData {
        var _local3:TextureData = ObjectLibrary.typeToTextureData_[this.death.zombieType];
        var _local2:AnimatedChar = _local3.animatedChar_;
        var _local1:MaskedImage = _local2.imageFromDir(0, 0, 0);
        return TextureRedrawer.resize(_local1.image_, _local1.mask_, 250, true, this.task.texture1, this.task.texture2);
    }

    private function onClosed():void {
        if (this.isFreshDeath) {
            this.setScreen.dispatch(new LegendsView());
        } else {
            this.gotoPrevious.dispatch();
        }
    }
}
}
