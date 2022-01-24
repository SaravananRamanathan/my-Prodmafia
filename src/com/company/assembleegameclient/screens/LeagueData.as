package com.company.assembleegameclient.screens {
public class LeagueData {


    public function LeagueData() {
        super();
    }

    private var _leagueType:int;

    public function get leagueType():int {
        return this._leagueType;
    }

    public function set leagueType(_arg_1:int):void {
        this._leagueType = _arg_1;
    }

    private var _title:String;

    public function get title():String {
        return this._title;
    }

    public function set title(_arg_1:String):void {
        this._title = _arg_1;
    }

    private var _endDate:Date;

    public function get endDate():Date {
        return this._endDate;
    }

    public function set endDate(_arg_1:Date):void {
        this._endDate = _arg_1;
    }

    private var _description:String;

    public function get description():String {
        return this._description;
    }

    public function set description(_arg_1:String):void {
        this._description = _arg_1;
    }

    private var _quote:String;

    public function get quote():String {
        return this._quote;
    }

    public function set quote(_arg_1:String):void {
        this._quote = _arg_1;
    }

    private var _characterId:String;

    public function get characterId():String {
        return this._characterId;
    }

    public function set characterId(_arg_1:String):void {
        this._characterId = _arg_1;
    }

    private var _panelBackgroundId:String;

    public function get panelBackgroundId():String {
        return this._panelBackgroundId;
    }

    public function set panelBackgroundId(_arg_1:String):void {
        this._panelBackgroundId = _arg_1;
    }

    private var _maxCharacters:int;

    public function get maxCharacters():int {
        return this._maxCharacters;
    }

    public function set maxCharacters(_arg_1:int):void {
        this._maxCharacters = _arg_1;
    }
}
}
