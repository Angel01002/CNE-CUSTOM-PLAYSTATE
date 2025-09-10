import flixel.util.FlxTimeEventManager;
import flixel.util.FlxTimeEvent;
import flixel.util.FlxTopBars;


var step_flashing:Array<Float> = [
    256.0,  384.0,
    512.0,  1024.0,
    1152.0, 1280.0,
    1408.0, 1536.0,
    1664.0, 1824.0,
    1920.0, 2048.0,
    2064.0
];
var white_back:FunkinSprite;
var black_fade:FunkinSprite;
var topbars:FlxTopBars;

var FlxStepEvent:FlxTimeEventManager;
var FlxBeatEvent:FlxTimeEventManager;

function loadSongEvent():Void
{
    white_back = new FunkinSprite();
    white_back.makeSolid(FlxG.width + 200, FlxG.height + 200, FlxColor.WHITE);
    white_back.cameras = [camGame];
    white_back.scrollFactor.set();
    white_back.zoomFactor = 0;
    white_back.screenCenter();
    
    black_fade = new FunkinSprite();
    black_fade.makeSolid(FlxG.width + 200, FlxG.height + 200, FlxColor.BLACK);
    black_fade.cameras = [camOverlay];
    black_fade.scrollFactor.set();
    black_fade.zoomFactor = 0;
    black_fade.screenCenter();
    
    topbars = new FlxTopBars(FlxG.width, FlxG.height, FlxColor.BLACK);
    topbars.cameras = [camOverlay];
    topbars.scrollFactor.set();
    topbars.defaultType = 'center';
    topbars.defaultEase = FlxEase.cubeOut;
    this.insert(0, topbars);
    
    FlxG.camera.visible = false;
    this.camHUD.visible = false;
    
    FlxG.camera.zoom = 1.3;
    this.camHUD.angle = -20;
    this.camHUD.alpha = 0;
    this.camHUD.y = -300;
    
    // Init GlobalManager
    FlxTimeEvent.initManager();
    
    final change_song_step:Array<Float> = [
        0, 1, 247, 248, 256,
        1520, 1536,1792, 1816,
        1818, 1820, 1824, 2064
    ];
    
    FlxTimeEvent.addChild(new FlxTimeEventManager((_) -> Conductor.curStepFloat), 50, 'child:1:step:float');
    FlxTimeEvent.addChild(new FlxTimeEventManager((_) -> Conductor.curBeatFloat), 40, 'child:2:beat:float');
    
    FlxStepEvent = FlxTimeEvent.globalManager.getChild('child:1:step:float');
    FlxBeatEvent = FlxTimeEvent.globalManager.getChild('child:2:beat:float');
    
    FlxStepEvent.multiple(change_song_step, (_) -> {
        switch(Math.round(_.time))
        {
            case 0:
                trace('step: 0');
            case 1:
                FlxG.camera.visible = true;
                this.camHUD.visible = true;
                topbars.tween(100 / (FlxG.height / 2), 18.525);
                FlxG.camera.zoom = 1.3;
                this.defaultCamZoom = 1.3;
                this.cameraSpeed = 1.5;
                FlxG.camera.fade(FlxColor.BLACK, 18.525, treu, null, true);
                FlxTween.tween(FlxG.camera, {zoom: 0.9}, 18.525, {
                    ease: FlxEase.quadInOut,
                    onComplete: (_) -> this.defaultCamZoom = 0.9;
                });
            default:
        }
    });
}

function update(elapsed:Float):Void
{
    FlxTimeEvent.globalManager.timeUpdate(Conductor.songPosition);
}