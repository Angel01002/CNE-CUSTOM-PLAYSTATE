var finishedTimeEvents:Array<FlxTimeEvent> = null;

for (event in _events)
{
    if (!event.active)
        continue;
    if (!event.finished)
        event.update(curTime);
    if (event.finished)
    {
        if (finishedTimeEvents == null)
            finishedTimeEvents = [];
        finishedTimeEvents.push(event);
    }
}

if (finishedTimeEvents != null)
{
    while(finishedTimeEvents.length > 0)
    {
        finishedTimeEvents.shift().finish();
    }
}





function test():Void
{
    /**
     * @param time
     * @param listener
     * @return FlxTimeOnceEvent
     */
    FlxTimeEvent.once(100, function(_):Void {
        FlxG.camera.flash(FlxColor.WHITE, 2.0, null, true);
    });
    
    /**
     * @param start
     * @param interval
     * @param loops
     * @param listener
     * @return FlxTimeIntervalEvent
     */
    FlxTimeEvent.interval(100, 5, 10, function(_):Void {
        FlxG.camera.zoom += 0.0015;
    });
    
    /**
     * @param start
     * @param length
     * @param interval
     * @param listener
     * @return FlxTimeRadionicEvent
     */
    FlxTimeEvent.radionic(100, 150, 5, function(_):Void {
        
    });
    
    /**
     * @param times
     * @param listener
     * @return FlxTimeMultipleEvent
     */
    FlxTimeEvent.multiple([0, 10, 50], function(_):Void {
        
    });
    
    /**
     * @param start
     * @param length
     * @param listener
     * @return FlxTimeRangeEvent
     */
    FlxTimeEvent.range(0, 100, function(_):Void {
        
    });
    
    /**
     * @param start
     * @param interval
     * @param loops
     * @param globalInterval
     * @param globalLoops
     * @param listener
     * @return FlxTimeShiftIntervalLoop
     */
    FlxTimeEvent.shiftIntervalLoop(200, 5, 2, 10, 5, function(_):Void {
        
    });
    
    /**
     * @param start
     * @param length
     * @param interval
     * @param globalInterval
     * @param globalLoops
     * @param listener
     * @return FlxTimeShiftRadionicLoop
     */
    FlxTimeEvent.shiftRadionicLoop(100, 100, 5, 50, 4, function(_):Void {
        
    });
    
    /**
     * @param start
     * @param length
     * @param globalInterval
     * @param globalLoops
     * @param listener
     * @return FlxTimeShiftRangeLoop
     */
    FlxTimeEvent.shiftRangeLoop(100, 100, 100, 5, function(_):Void {
        trace('');
    });
    
    /**
     * @param start
     * @param length
     * @param options
     * @return FlxTimeTweenEvent
     */
    FlxTimeEvent.tween(100, 50, {
        ease: FlxEase.linear,
        onStart: function(_):Void {
            trace('tween start');
        },
        onUpdate: function(_):Void {
            trace('tween scale: ${FlxEase.backInOut(_.scale)}');
        },
        onComplete: function(_):Void {
            trace('tween completed');
        }
    });
    
    /**
     * @param start
     * @param length
     * @param fromValue
     * @param toValue
     * @param options
     */
    FlxTimeEvent.num(100, 50, 0, 100, {
        ease: FlxEase.quadInOut,
        onStart: function(_):Void {
            trace('num start');
        },
        onUpdate: function(_):Void {
            trace('num value: ${_.value}');
        },
        onComplete: function(_):Void {
            trace('num complete');
        }
    });
}