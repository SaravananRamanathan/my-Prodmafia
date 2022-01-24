package com.company.assembleegameclient.util {
public class Currency {

    public static const INVALID:int = -1;

    public static const GOLD:int = 0;

    public static const FAME:int = 1;

    public static const GUILD_FAME:int = 2;

    public static const FORTUNE:int = 3;

    public static function typeToName(_arg_1:int):String {
        switch (int(_arg_1)) {
            case 0:
                return "Gold";
            case 1:
                return "Fame";
            case 2:
                return "Guild Fame";
            case 3:
                return "Fortune Token";
        }

        return "Unknown Currency";
    }

    public function Currency() {
        super();
    }
}
}
