package io.decagames.rotmg.dailyQuests.view.list {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.scroll.UIScrollbar;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.tabs.TabButton;
    import io.decagames.rotmg.ui.tabs.UITab;
    import io.decagames.rotmg.ui.tabs.UITabs;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class DailyQuestsList extends Sprite {
        
        public static const QUEST_TAB_LABEL: String = "Quests";
        
        public static const EVENT_TAB_LABEL: String = "Events";
        
        public static const SCROLL_BAR_HEIGHT: int = 345;
        
        public function DailyQuestsList() {
            super();
            this.init();
        }
        
        private var questLinesPosition: int = 0;
        private var eventLinesPosition: int = 0;
        private var questsContainer: Sprite;
        private var eventsContainer: Sprite;
        private var eventsTab: TabButton;
        private var contentTabs: SliceScalingBitmap;
        private var contentInset: SliceScalingBitmap;
        private var _dailyQuestElements: Vector.<DailyQuestListElement>;
        private var _eventQuestElements: Vector.<DailyQuestListElement>;
        
        private var _tabs: UITabs;
        
        public function get tabs(): UITabs {
            return this._tabs;
        }
        
        public function get list(): Sprite {
            return this.questsContainer;
        }
        
        public function addIndicator(_arg_1: Boolean): void {
            this.eventsTab = this._tabs.getTabButtonByLabel("Events");
            if (this.eventsTab) {
                this.eventsTab.showIndicator = _arg_1;
                this.eventsTab.clickSignal.add(this.onEventsClick);
            }
        }
        
        public function addQuestToList(_arg_1: DailyQuestListElement): void {
            if (!this._dailyQuestElements) {
                this._dailyQuestElements = new Vector.<DailyQuestListElement>(0);
            }
            _arg_1.x = 10;
            _arg_1.y = this.questLinesPosition * 35;
            this.questsContainer.addChild(_arg_1);
            this.questLinesPosition++;
            this._dailyQuestElements.push(_arg_1);
        }
        
        public function addEventToList(_arg_1: DailyQuestListElement): void {
            if (!this._eventQuestElements) {
                this._eventQuestElements = new Vector.<DailyQuestListElement>(0);
            }
            _arg_1.x = 10;
            _arg_1.y = this.eventLinesPosition * 35;
            this.eventsContainer.addChild(_arg_1);
            this.eventLinesPosition++;
            this._eventQuestElements.push(_arg_1);
        }
        
        public function clearQuestLists(): void {
            var _local1: * = null;
            while (this.questsContainer.numChildren > 0) {
                _local1 = this.questsContainer.removeChildAt(0) as DailyQuestListElement;
                _local1 = null;
            }
            this.questLinesPosition = 0;
            while (this.eventsContainer.numChildren > 0) {
                _local1 = this.eventsContainer.removeChildAt(0) as DailyQuestListElement;
                _local1 = null;
            }
            this.eventLinesPosition = 0;
        }
        
        public function getCurrentlySelected(_arg_1: String): DailyQuestListElement {
            var _local2: * = null;
            var _local4: * = null;
            var _local3: * = null;
            if (_arg_1 == "Quests") {
                for each(_local4 in this._dailyQuestElements) {
                    if (_local4.isSelected) {
                        _local2 = _local4;
                    }
                }
            } else if (_arg_1 == "Events") {
                var _local8: int = 0;
                var _local7: * = this._eventQuestElements;
                for each(_local3 in this._eventQuestElements) {
                    if (_local3.isSelected) {
                        _local2 = _local3;
                        break;
                    }
                }
            }
            return _local2;
        }
        
        private function init(): void {
            this.createContentTabs();
            this.createContentInset();
            this.createTabs();
        }
        
        private function createTabs(): void {
            this._tabs = new UITabs(230, true);
            this._tabs.addTab(this.createQuestsTab(), true);
            this._tabs.addTab(this.createEventsTab());
            this._tabs.y = 1;
            addChild(this._tabs);
        }
        
        private function createContentInset(): void {
            this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 230);
            this.contentInset.height = 6 * 60;
            this.contentInset.y = 35;
            addChild(this.contentInset);
        }
        
        private function createContentTabs(): void {
            this.contentTabs = TextureParser.instance.getSliceScalingBitmap("UI", "tab_inset_content_background", 230);
            this.contentTabs.height = 45;
            addChild(this.contentTabs);
        }
        
        private function createQuestsTab(): UITab {
            var _local3: * = null;
            var _local4: UITab = new UITab("Quests");
            var _local2: Sprite = new Sprite();
            this.questsContainer = new Sprite();
            this.questsContainer.x = this.contentInset.x;
            this.questsContainer.y = 10;
            _local2.addChild(this.questsContainer);
            var _local1: UIScrollbar = new UIScrollbar(345);
            _local1.mouseRollSpeedFactor = 1;
            _local1.scrollObject = _local4;
            _local1.content = this.questsContainer;
            _local2.addChild(_local1);
            _local1.x = this.contentInset.x + this.contentInset.width - 25;
            _local1.y = 7;
            _local3 = new Sprite();
            _local3.graphics.beginFill(0);
            _local3.graphics.drawRect(0, 0, 230, 345);
            _local3.x = this.questsContainer.x;
            _local3.y = this.questsContainer.y;
            this.questsContainer.mask = _local3;
            _local2.addChild(_local3);
            _local4.addContent(_local2);
            return _local4;
        }
        
        private function createEventsTab(): UITab {
            var _local4: * = null;
            _local4 = new UITab("Events");
            var _local2: Sprite = new Sprite();
            this.eventsContainer = new Sprite();
            this.eventsContainer.x = this.contentInset.x;
            this.eventsContainer.y = 10;
            _local2.addChild(this.eventsContainer);
            var _local1: UIScrollbar = new UIScrollbar(345);
            _local1.mouseRollSpeedFactor = 1;
            _local1.scrollObject = _local4;
            _local1.content = this.eventsContainer;
            _local2.addChild(_local1);
            _local1.x = this.contentInset.x + this.contentInset.width - 25;
            _local1.y = 7;
            var _local3: Sprite = new Sprite();
            _local3.graphics.beginFill(0);
            _local3.graphics.drawRect(0, 0, 230, 345);
            _local3.x = this.eventsContainer.x;
            _local3.y = this.eventsContainer.y;
            this.eventsContainer.mask = _local3;
            _local2.addChild(_local3);
            _local4.addContent(_local2);
            return _local4;
        }
        
        private function onEventsClick(_arg_1: BaseButton): void {
            if (TabButton(_arg_1).hasIndicator) {
                TabButton(_arg_1).showIndicator = false;
            }
        }
    }
}
