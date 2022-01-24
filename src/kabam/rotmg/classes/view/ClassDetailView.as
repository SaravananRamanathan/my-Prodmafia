package kabam.rotmg.classes.view {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import kabam.rotmg.assets.model.Animation;
import kabam.rotmg.assets.services.IconFactory;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.view.SignalWaiter;
import kabam.rotmg.util.components.StarsView;

public class ClassDetailView extends Sprite {

    private static const RIGHT_JUSTIFICATION_STATS:int = 205;

    private static const WIDTH:int = 344;

    private static const TEXT_WIDTH:int = 188;


    private const waiter:SignalWaiter = new SignalWaiter();

    public function ClassDetailView() {
        var _local1:* = null;
        super();
        this.waiter.complete.add(this.layout);
        _local1 = new DropShadowFilter(0, 0, 0, 1, 8, 8);
        this.animContainer = new Sprite();
        this.animContainer.x = 2 * 60;
        addChild(this.animContainer);
        this.classNameText = new TextFieldDisplayConcrete().setSize(20).setColor(0xffffff).setBold(true).setTextWidth(188);
        this.classNameText.filters = [_local1];
        this.waiter.push(this.classNameText.textChanged);
        addChild(this.classNameText);
        this.classDescriptionText = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setTextWidth(188).setWordWrap(true);
        this.classDescriptionText.filters = [_local1];
        this.waiter.push(this.classDescriptionText.textChanged);
        addChild(this.classDescriptionText);
        this.questCompletionText = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setBold(true);
        this.questCompletionText.filters = [_local1];
        this.questCompletionText.setStringBuilder(new LineBuilder().setParams("ClassDetailView.questCompleted"));
        this.waiter.push(this.questCompletionText.textChanged);
        addChild(this.questCompletionText);
        this.levelTitleText = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setBold(true);
        this.levelTitleText.filters = [_local1];
        this.levelTitleText.setStringBuilder(new LineBuilder().setParams("ClassDetailView.levelTitle"));
        this.waiter.push(this.levelTitleText.textChanged);
        addChild(this.levelTitleText);
        this.levelText = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setBold(true);
        this.levelText.filters = [_local1];
        this.waiter.push(this.levelText.textChanged);
        addChild(this.levelText);
        this.fameTitleText = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setBold(true);
        this.fameTitleText.filters = [_local1];
        this.fameTitleText.setStringBuilder(new LineBuilder().setParams("ClassDetailView.fameTitle"));
        this.waiter.push(this.fameTitleText.textChanged);
        addChild(this.fameTitleText);
        this.fameText = new TextFieldDisplayConcrete().setSize(16).setColor(15387756).setBold(true);
        this.fameText.filters = [_local1];
        this.waiter.push(this.fameText.textChanged);
        addChild(this.fameText);
        this.fameIcon = new Bitmap(IconFactory.makeFame());
        this.fameIcon.filters = [_local1];
        addChild(this.fameIcon);
        this.nextGoalText = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setBold(true);
        this.nextGoalText.filters = [_local1];
        this.nextGoalText.setStringBuilder(new LineBuilder().setParams("ClassDetailView.nextGoal"));
        this.nextGoalText.visible = false;
        addChild(this.nextGoalText);
        this.nextGoalDetailText = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff);
        this.nextGoalDetailText.filters = [_local1];
        this.nextGoalDetailText.visible = false;
        addChild(this.nextGoalDetailText);
        this.questCompletedStars = new StarsView();
        addChild(this.questCompletedStars);
    }
    private var classNameText:TextFieldDisplayConcrete;
    private var classDescriptionText:TextFieldDisplayConcrete;
    private var questCompletionText:TextFieldDisplayConcrete;
    private var levelTitleText:TextFieldDisplayConcrete;
    private var levelText:TextFieldDisplayConcrete;
    private var fameTitleText:TextFieldDisplayConcrete;
    private var fameText:TextFieldDisplayConcrete;
    private var fameIcon:Bitmap;
    private var nextGoalText:TextFieldDisplayConcrete;
    private var nextGoalDetailText:TextFieldDisplayConcrete;
    private var questCompletedStars:StarsView;
    private var showNextGoal:Boolean;
    private var animContainer:Sprite;
    private var animation:Animation;

    public function setData(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int):void {
        this.classNameText.setStringBuilder(new LineBuilder().setParams(_arg_1));
        this.classDescriptionText.setStringBuilder(new LineBuilder().setParams(_arg_2));
        this.levelText.setStringBuilder(new StaticStringBuilder(String(_arg_4)));
        this.fameText.setStringBuilder(new StaticStringBuilder(String(_arg_5)));
    }

    public function setNextGoal(_arg_1:String, _arg_2:int):void {
        this.showNextGoal = _arg_2 != -1;
        if (this.showNextGoal) {
            this.nextGoalDetailText.setStringBuilder(new LineBuilder().setParams("ClassDetailView.nextGoalDetail", {
                "goal": String(_arg_2),
                "quest": _arg_1
            }));
            this.nextGoalDetailText.y = this.nextGoalText.y + this.nextGoalText.height;
            this.nextGoalDetailText.x = 172 - this.nextGoalDetailText.width / 2;
            this.waiter.push(this.nextGoalDetailText.textChanged);
            this.waiter.push(this.nextGoalText.textChanged);
        }
    }

    public function setWalkingAnimation(_arg_1:Animation):void {
        this.animation && this.removeAnimation(this.animation);
        this.animation = _arg_1;
        this.animation && this.addAnimation(this.animation);
        this.layout();
    }

    private function removeAnimation(_arg_1:Animation):void {
        _arg_1.stop();
        this.animContainer.removeChild(_arg_1);
    }

    private function addAnimation(_arg_1:Animation):void {
        this.animContainer.addChild(_arg_1);
        _arg_1.start();
    }

    private function layout():void {
        this.classNameText.x = 172 - this.classNameText.width / 2;
        this.classNameText.y = 110;
        this.classDescriptionText.y = this.classNameText.y + this.classNameText.height + 5;
        this.classDescriptionText.x = 172 - this.classDescriptionText.width / 2;
        this.questCompletionText.y = this.classDescriptionText.y + this.classDescriptionText.height + 20;
        this.questCompletionText.x = 205 - this.questCompletionText.width;
        this.questCompletedStars.y = this.questCompletionText.y - 2;
        this.questCompletedStars.x = 223;
        this.levelTitleText.y = this.questCompletionText.y + this.questCompletionText.height + 5;
        this.levelTitleText.x = 205 - this.levelTitleText.width;
        this.levelText.y = this.levelTitleText.y;
        this.levelText.x = 223;
        this.fameTitleText.y = this.levelTitleText.y + this.levelTitleText.height + 5;
        this.fameTitleText.x = 205 - this.fameTitleText.width;
        this.fameText.y = this.fameTitleText.y;
        this.fameText.x = 223;
        this.fameIcon.y = this.fameTitleText.y - 2;
        this.fameIcon.x = this.fameText.x + this.fameText.width + 3;
        this.nextGoalText.y = this.fameTitleText.y + this.fameTitleText.height + 17;
        this.nextGoalText.x = 172 - this.nextGoalText.width / 2;
        this.nextGoalText.visible = this.showNextGoal;
        this.nextGoalDetailText.y = this.nextGoalText.y + this.nextGoalText.height;
        this.nextGoalDetailText.x = 172 - this.nextGoalDetailText.width / 2;
        this.nextGoalDetailText.visible = this.showNextGoal;
    }
}
}
