package com.company.util {
public class ArrayIterator implements IIterator {


    public function ArrayIterator(_arg_1:Array) {
        super();
        this.objects_ = _arg_1;
        this.index_ = 0;
    }
    private var objects_:Array;
    private var index_:int;

    public function reset():void {
        this.index_ = 0;
    }

    public function next():Object {
        var _local1:Number = this.index_;
        this.index_++;
        return this.objects_[_local1];
    }

    public function hasNext():Boolean {
        return this.index_ < this.objects_.length;
    }
}
}
