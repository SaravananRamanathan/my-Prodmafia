package kabam.rotmg.game.view {
import kabam.rotmg.game.model.QuestModel;
import kabam.rotmg.ui.signals.RealmHeroesSignal;
import kabam.rotmg.ui.signals.RealmOryxSignal;
import kabam.rotmg.ui.signals.RealmQuestLevelSignal;
import kabam.rotmg.ui.signals.RealmServerNameSignal;
import kabam.rotmg.ui.signals.ToggleRealmQuestsDisplaySignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class RealmQuestsDisplayMediator extends Mediator {


    public function RealmQuestsDisplayMediator() {
        super();
    }
    [Inject]
    public var view:RealmQuestsDisplay;
    [Inject]
    public var realmHeroesSignal:RealmHeroesSignal;
    [Inject]
    public var realmQuestLevelSignal:RealmQuestLevelSignal;
    [Inject]
    public var realmOryxSignal:RealmOryxSignal;
    [Inject]
    public var toggleRealmQuestsDisplay:ToggleRealmQuestsDisplaySignal;
    [Inject]
    public var questModel:QuestModel;
    [Inject]
    public var realmServerNameSignal:RealmServerNameSignal;

    override public function initialize():void {
        this.realmHeroesSignal.add(this.onRealmHeroes);
        this.realmQuestLevelSignal.add(this.onRealmQuestLevel);
        this.realmOryxSignal.add(this.onOryxKill);
        this.realmServerNameSignal.add(this.onServerName);
        this.toggleRealmQuestsDisplay.add(this.onToggleDisplay);
        this.initView();
    }

    private function onServerName(_arg_1:String):void {
        this.view.realmName = _arg_1;
    }

    private function initView():void {
        this.view.requirementsStates = this.questModel.requirementsStates;
        this.view.init();
        if (this.questModel.previousRealm == "Realm of the Mad God" && this.view.requirementsStates[1]) {
            this.view.remainingHeroes = 0;
        }
    }

    private function onToggleDisplay():void {
        this.view.toggleOpenState();
    }

    private function onOryxKill():void {
        this.view.setOryxCompleted();
        this.questModel.requirementsStates = this.view.requirementsStates;
        this.questModel.hasOryxBeenKilled = true;
    }

    private function onRealmQuestLevel(_arg_1:int):void {
        this.view.level = _arg_1;
        this.questModel.requirementsStates = this.view.requirementsStates;
    }

    private function onRealmHeroes(_arg_1:int):void {
        if (!this.view.requirementsStates[1]) {
            this.questModel.remainingHeroes = _arg_1;
            this.view.remainingHeroes = _arg_1;
            this.questModel.requirementsStates = this.view.requirementsStates;
        }
    }
}
}
