import flixel.util.FlxTimeEventManager;
import flixel.util.FlxTimeEvent;
import flixel.util.FlxTopBars;
import StringBuf;

var FlxStepEvent:FlxTimeEventManager;
var FlxBeatEvent:FlxTimeEventManager;
var FlxMeasEvent:FlxTimeEventManager;

var steps_flashing:Array<Float> = [416, 672, 928, 1216, 1472, 1728];
var initHudVisible:Bool = FlxG.random.bool();
var black_back:FunkinSprite;
var topbars:FlxTopBars;

function loadSongEvent():Void
{
    black_back = new FunkinSprite();
    black_back.makeSolid(FlxG.width + 200, FlxG.height + 200, FlxColor.BLACK);
    black_back.scrollFactor.set();
    black_back.zoomFactor = 0;
    black_back.screenCenter();
    
    topbars = new FlxTopBars(FlxG.width, FlxG.height, FlxColor.BLACK);
    topbars.scrollFactor.set();
    topbars.zoomFactor = 0;
    topbars.cameras = [this.camOverlay];
    topbars.defaultType = 'middle';
    topbars.defaultEase = FlxEase.cubeOut;
    this.insert(0, topbars);
    
    FlxG.camera.visible = false;
    this.camHUD.visible = false;
    
    this.strumLines.forEach(function(strumLine:StrumLine):Void
    {
        for (k => char in strumLine.characters)
        {
            if (char == null)
                continue;
            
            char.visible = !(k >= 1 || strumLine.ID >= 2);
            char.active = char.visible;
            char.exists = char.visible;
        }
    });
    
    FlxStepEvent = new FlxTimeEventManager();
    FlxBeatEvent = new FlxTimeEventManager();
    FlxMeasEvent = new FlxTimeEventManager();
    
    final change_song_step:Array<Float> = [1, 64, 122, 352, 416, 1198, 1456, 1472, 1984, 2192];
    FlxStepEvent.multiple(change_song_step, function(_:MultipleEvent):Void
    {
        switch(Math.round(_.currentTime))
        {
            case 1:
                FlxG.camera.visible = true;
                this.camHUD.visible = initHudVisible;
                this.camOther.fade(FlxColor.BLACK, 10.67, true, null, true);
            case 64:
                FlxTween.tween(FlxG.camera, {zoom: 1.4}, 9.33, {
                    ease: FlxEase.smoothStepInOut
                });
            case 122:
                this.camHUD.visible = true;
                if (!initHudVisible) {
                    this.camHUD.alpha = 0;
                    FlxTween.tween(this.camHUD, {alpha: 1}, 1);
                }
            case 352:
                FlxTween.tween(FlxG.camera, {zoom: 1.4}, 5.33, {
                    ease: FlxEase.smoothStepInOut,
                    onComplete: function(_:FlxTween):Void {
                        FlxG.camera.visible = false;
                        this.camHUD.visible = false;
                    }
                });
            case 416:
                FlxG.camera.visible = true;
                this.camHUD.visible = true;
                this.health = this.maxHealth / 2;
            case 1198:
                tweenSongLength(152000, 198390, 3);
                FlxTween.tween(FlxG.camera, {zoom: 1.5}, 3, {
                    ease: FlxEase.quadInOut,
                    onComplete: function(_:FlxTween):Void {
                        AppleFilterBlack(true);
                        if (PibbyOptions.cameraFlashing)
                            this.camOverlay.flash(FlxColor.WHITE, 1, null, true);
                    }
                });
                topbars.tween('middle', {vep: 100 / (FlxG.height / 2)}, 3, FlxEase.cubeOut);
            case 1456:
                tweenSongLength(198390, this.inst.length, 1.92);
            case 1472:
                AppleFilterBlack(false);
            case 1984:
                topbars.tween('middle', {vep: 0}, 2, FlxEase.cubeOut);
            case 2192:
                FlxTween.tween(FlxG.camera, {zoom: 1.4}, 6.63, {
                    ease: FlxEase.quadInOut,
                    onComplete: function(_:FlxTween):Void {
                        FlxG.camera.visible = false;
                        this.camHUD.visible = false;
                    }
                });
            default:
                trace('FlxStepEvent<(MultipleEvent)> => time indefinided: ' + _.currentTime);
        }
    });
    
    FlxStepEvent.multiple(steps_flashing, function(_:MultipleEvent):Void
    {
        if (!PibbyOptions.cameraFlashing)
            return;
        var currentTime:Int = Math.round(_.currentTime);
        var cam:FlxCamera = this.camOverlay;
        var time:Float = 1.0;
        // Verificacion de tiempo real y evento.
        if (Conductor.curStep == 416 && currentTime == 416)
            cam = this.camOther;
        if (Conductor.curStep == 1472 && currentTime == 1472)
            time = 1.5;
        if (cam != null) {
            cam.flash(FlxColor.WHITE, time, null, true);
            if (PibbyOptions.debugMode) {
                var camName:String = 'indefinided';
                if (cam == this.camOverlay) camName = 'camOverlay';
                if (cam == this.camOther) camName = 'camOther';
                var result:StringBuf = new StringBuf();
                result.add('(');
                result.add('Time: ' + currentTime);
                result.add(' | ');
                result.add('FlashTime: ' + time);
                result.add(' | ');
                result.add('CamName: ' + camName);
                rsultt.add(')');
                trace('FlxStepEvent<(MultipleEvent)> flashing values: ' + value);
            }
            return;
        }
        // cam == null.
        trace('FlxStepEvent<(MultipleEvent)> => cam target indefinided in step: ' + currentTime);
    });
    
    FlxBeatEvent.shiftRangeLoop(168, 128, 72, 2, function(_:ShiftRangeLoopEvent):Void
    {
        if (!Options.camZoomOnBeat) return;
        FlxG.camera.zoom += 0.015;
        this.camHUD.zoom += 0.030;
    });
    
    FlxMeasEvent.range(0, this.inst.length, function(_:RangeEvent):Void
    {
        if (isCamStopPos) return;
        
        var i:Int = this.events.length;
        var t:Int = this.curCameraTarget;
        while(i >= 0 && this.events[i].time <= Conductor.songPosition + Conductor.stepCrochet) {
            if (this.events[i].name == 'Camera Movement')
                t = this.events[i].params[0];
            i--;
        }
        switch(t) {
            case 0: this.defaultCamZoom = 1.2;
            case 1: this.defaultCamZoom = 0.9;
            default:
                trace('FlxMeasEvent<(RangeEvent)> => zoom target indefinided: ' + t);
        }
    });
    
    FlxStepEvent.start(0, 0.01);
    FlxBeatEvent.start(0, 0.01);
    FlxMeasEvent.start(0, 0.01);
}

// se ejecuta en cada `Step` de la musica
// Llamada por defecto 4 veces entre cada `Beat`.
function stepHit(step:Int):Void {
    FlxStepEvent.timeUpdate(step);
}
// Se ejecuta en cada `Beat` de la musica.
// Se llama segun el `BPM` de la musica.
// Si el `BPM` es 100, se llama 100 veces por minuto.
function beatHit(beat:Int):Void {
    FlxBeatEvent.timeUpdate(beat);
}
// Se ejecuta en cada `Section` de la musica.
// Llamada por defecto una vez cada 4 `Beats`.
function measureHit(measure:Int):Void {
    FlxMeasEvent.timeUpdate(measure);
}

function update(elapsed:Float):Void {
    
}

function destroy():Void {
    FlxStepEvent.destroy();
    FlxBeatEvent.destroy();
    FlxMeasEvent.destroy();
}

/**
 * Metodo para cambiar visualmente el largo real de la cancion.
 * @param StartValue Indica el tiempo del cual iniciar.
 * @param EndValue Indica el tiempo al cual llegar.
 * @param TimeValue Indica el tiempo para terminar.
 * @param Ease Una suavidad opcional para la interpolacion.
 */
function tweenSongLength(StartValue:Float, EndValue:Float, TimeValue:Float, ?Ease:Float->Float):Void
{
    FlxTween.cancelTweensOf(this, ['songLength']);
    this.songLength = StartValue;
    FlxTween.tween(this, {songLength: EndValue}, TimeValue, {
        ease: ease,
        onComplete: (_) -> this.songLength = EndValue
    });
}

/**
 * Metodo para Inciar un efecto BadApple basico.
 * Ademas oculta los objetos del escenario definidos en `this.stage.stageSprites`.
 * Color:
 * ---------------------
 * - Characters: `WHITE`
 * - Background: 'BLACK'
 * ---------------------
 * @param IsEnabled Indica si activar el effecto.
 */
function AppleFilterBlack(IsEnabled:Bool):Void
{
    if (black_back == null) return;
    
    // Reseteo
    this.remove(black_back, true);
    black_back.kill();
    FlxG.camera.bgColor = FlxColor.TRANSPARENT;
    
    var i:Int = this.members.length;
    for (id => strumLine in this.strumLines.members)
    {
        if (strumLine == null) continue;
        for (k => char in strumLine.characters)
        {
            if (char == null) continue;
            var color:FlxColor = char.color;
            if (IsEnabled) {
                char.setColorTransform(0.0, 0.0, 0.0, char.alpha, 255, 255, 255, 0);
            }
            else {
                char.setColorTransform(1.0, 1.0, 1.0, char.alpha, 0, 0, 0, 0);
            }
            char.color = color;
            // Index
            var j:Int = this.members.indexOf(char);
            // resumen: si `j` es menor que `i` y `j` no es `-1` entonces: `i = j`, de lo contrario no hay cambio.
            i = (j >= 0) ? (i > j ? j : i) : i;
        }
    }
    // Escenario visible?
    for (key => sprite in this.stage.stageSprites)
    {
        if (sprite == null) continue;
        if (IsEnabled) sprite.kill();
        else sprite.revive();
    }
    // Insertar Black BG
    if (!IsEnabled) return;
    this.insert(i >= 0 ? i : 0, black_back);
    black_back.revive();
    // Ummm?
    FlxG.camera.bgColor = FlxColor.BLACK;
}
