package kabam.rotmg.arena.component {
import com.company.assembleegameclient.ui.GuildText;
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.display.Bitmap;

import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class AbridgedPlayerTooltip extends ToolTip {


    public function AbridgedPlayerTooltip(_arg_1:ArenaLeaderboardEntry) {
        var _local3:* = null;
        var _local2:Bitmap = new Bitmap();
        _local2.bitmapData = _arg_1.playerBitmap;
        _local2.scaleX = 0.75;
        _local2.scaleY = 0.75;
        _local2.y = 5;
        addChild(_local2);
        var _local5:StaticTextDisplay = new StaticTextDisplay();
        _local5.setSize(14).setBold(true).setColor(0xffffff);
        _local5.setStringBuilder(new StaticStringBuilder(_arg_1.name));
        _local5.x = 40;
        _local5.y = 5;
        addChild(_local5);
        if (_arg_1.guildName) {
            _local3 = new GuildText(_arg_1.guildName, _arg_1.guildRank);
            _local3.x = 40;
            _local3.y = 20;
            addChild(_local3);
        }
        super(0x363636, 0.5, 0xffffff, 1);
        var _local4:EquippedGrid = new EquippedGrid(null, _arg_1.slotTypes, null);
        _local4.x = 5;
        _local4.y = !!_local3 ? _local3.y + _local3.height - 5 : 55;
        _local4.setItems(_arg_1.equipment);
        addChild(_local4);
    }
}
}
