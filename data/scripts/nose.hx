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