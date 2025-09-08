import flixel.util.FlxDestroyUtil.IFlxDestroyable;


class FlxTimeEvent implements IFlxDestroyable
{
    public static var globalManager:FlxTimeEventManager;
    
    /**
     * Crea y añade un TimeEvent al manager global.
     * Este evento se dispara solo una vez que llega al tiempo establecido.
     * @param time Indica el momento a disparar este evento.
     * @param callback Una función a dispara al llegar al tiempo establecido.
     * @return TimeEvent
     */
    public static function event(time:Float, callback:TimeEvent->Void):TimeEvent
    {
        return globalManager.event(time, callback);
    }
    
    /**
     * Crea y añade un IntervalEvent al maanager global.
     * Este evento se dispara cada intervalo de tiempo según el loops mandado.
     * @param start Indica el inicio y primer disparo.
     * @param inter Indica el intervalo entre cada disparo.
     * @param loops Indica cuantas veces repetir el intervalo.
     * @param callback Una función a disparar en cada intervalo.
     * @return IntervalEvent
     */
    public static function interval(start:Float, inter:Float, loops:Int, callback:IntervalEvent->Void):IntervalEvent
    {
        return globalManager.interval(start, inter, loops, callback);
    }
}


class FlxTimeEventManager extends FlxBasic
{
}