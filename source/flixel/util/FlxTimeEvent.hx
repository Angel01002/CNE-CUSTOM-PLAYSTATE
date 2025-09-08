import flixel.util.FlxDestroyUtil.IFlxDestroyable;


class FlxTimeEvent implements IFlxDestroyable
{
    public static var globalManager:FlxTimeEventManager;
    
    /**
     * Crea y añade un TimeEvent al manager global.
     * Este evento se dispara solo una vez que llega al tiempo establecido.
     * @param time Indica el momento a disparar este evento.
     * @param callback Un evento que se dispara al llegar al tiempo establecido.
     * @return TimeEvent
     */
    public static function event(time:Float, callback:TimeEvent->Void):TimeEvent
    {
        return globalManager.event(time, callback);
    }
}


class FlxTimeEventManager extends FlxBasic
{
}