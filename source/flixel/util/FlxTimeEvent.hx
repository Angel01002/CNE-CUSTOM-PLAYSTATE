import flixel.util.FlxDestroyUtil.IFlxDestroyable;


class FlxTimeEvent implements IFlxDestroyable
{
    /**
     * Administrador global para `FlxTimeEvent`.
     */
    public static var globalManager:FlxTimeEventManager;
    
    /**
     * ```haxe
     * FlxTimeEvent.event(10000, (_) -> FlxG.camera.flash());
     * ```
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
     * ```haxe
     * FlxTimeEvent.interval(50000, 5000, 36, (_) -> FlxG.camera.angle += 10);
     * ```
     * Crea y añade un IntervalEvent al manager global.
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
    
    /**
     * ```haxe
     * FlxTimeEvent.multiple([1000, 12000, 34000, 50000, 60000, 100000], (_) -> mySprite.visible = true);
     * FlxTimeEvent.multiple([0, 5000, 25000, 40000, 55000, 80000], (_) -> mySprite.visible = false);
     * ```
     * Crea y añade un MultipleEvent al manager global.
     * Este evento se dispara en cada tiempo establecido en el array.
     * @param times Un arreglo con múltiples tiempos.
     * @param callback Una función a disparar en cada tiempo establecido.
     * @return MultipleEvent
     */
    public static function multiple(times:Array<Float>, callback:MultipleEvent->Void):MultipleEvent
    {
        return globalManager.multiple(times, callback);
    }

    /**
     * ```haxe
     * FlxTimeEvent.range(10000, 5000, (_) -> obj.x += 10);
     * ```
     * Crea y añade un RangeEvent al manager global.
     * Este evento se dispara siempre que el tiempo esté dentro del rango establecido.
     * @param start Indica el tiempo de inicio.
     * @param length Indica la longitud del rango.
     * @param callback Una función a disparar mientras el evento se encuentre en el rango establecido.
     * @return RangeEvent
     */
    public static function range(start:Float, length:Float, callback:RangeEvent->Void):RangeEvent
    {
        return globalManager.range(start, length, callback);
    }
    
    /**
     * ```haxe
     * FlxTimeEvent.tween(40000, 20000, {
     *     ease: FlxEase.linear,
     *     onStart: (_) -> {
     *         FlxG.camera.x = 0;
     *         FlxG.camera.y = 0;
     *         mySprite.angle = 0;
     *     },
     *     onUpdate: (_) -> {
     *         mySprite.angle = 0 + 360 * FlxEase.backInOut(_.scale);
     *         FlxG.camera.x = 0 + FlxG.width * _.scale;
     *         FlxG.camera.y = 0 + FlxG.height * _.scale;
     *     },
     *     onComplete: (_) -> {
     *         _.type = FlxTimeEventType.PERSIST;
     *     }
     * });
     * ```
     * Crea y añade un TweenEvent al manager global.
     * Este evento es similar al `range()` pero sirve para crear una interpolacion en base al tiempo objetivo.
     * @param start Indica es tiempo de inicio.
     * @param length Indica la longitud del rango.
     * @param options Un objeto con algunas opciones comunes de un tween.
     * @return TweenEvent
     */
    public static function tween(start:Float, length:Float, options:TweenEventOptions):TweenEvent
    {
        return globalManager.tween(start, length, options);
    }
}


class FlxTimeEventManager extends FlxBasic
{
}