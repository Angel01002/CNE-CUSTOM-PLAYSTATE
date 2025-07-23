import flixel.math.FlxBasePoint;
import flixel.util.FlxAxes;
import flixel.util.FlxStringUtil;
import flixel.FlxObject;

import haxe.xml.Access;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import Xml;
import Std;

import funkin.backend.utils.CoolUtil;
import funkin.game.StrumLine;
import funkin.game.Character;

class TargetCameraData
{
    /**
     * 
    **/
    public var camOffset:FlxPoint = FlxPoint.get();
    
    /**
     * 
    **/
    public var movement:FlxPoint = FlxPoint.get();
    
    /**
     * 
    **/
    public var camFollowPos:FlxPoint = FlxPoint.get();
    
    /**
     * 
    **/
    public var zoom:Float = -1.0;
    
    /**
     * 
    **/
    public var cameraSpeed:Float = 1.0;
    
    /**
     * 
    **/
    public var isFollowAngle:Bool = true;
    
    /**
     * 
    **/
    public var camFollowAxes:FlxAxes = FlxAxes.NONE;
    
    /**
     * 
    **/
    public var moveAxes:FlxAxes = FlxAxes.NONE;
    
    /**
     * 
    **/
    public var strumLineFollowTarget:Int = 0;
    
    /**
     * 
    **/
    public var strumLineAnimTarget:Int = 0;
    
    /**
     * 
    **/
    public var characterFollowTarget:Int = 0;
    
    /**
     * 
    **/
    public var characterAnimTarget:Int = 0;
    
    /**
     * 
    **/
    public var defaultID:Int = 0;
    
    /**
     *
    **/
    public var game:PlayState;
    
    /**
     * 
    **/
    public var mapAnimMultiplyOffset:Map<String, Dynamic> = [
        'singRIGHT'     => {px: -1.0,  py:  0.0, mx: true, my: true},
        'singDOWN'      => {px:  0.0,  py:  1.0, mx: true, my: true},
        'singUP'        => {px:  0.0,  py: -1.0, mx: true, my: true},
        'singRIGHT'     => {px:  1.0,  py:  0.0, mx: true, my: true},
        'idle'          => {px:  0.0,  py:  0.0, mx: true, my: true},
        'singRIGHT-alt' => {px: -1.0,  py:  0.0, mx: true, my: true},
        'singDOWN-alt'  => {px:  0.0,  py:  1.0, mx: true, my: true},
        'singUP-alt'    => {px:  0.0,  py: -1.0, mx: true, my: true},
        'singRIGHT-alt' => {px:  1.0,  py:  0.0, mx: true, my: true},
        'idle-alt'      => {px:  0.0,  py:  0.0, mx: true, my: true},
        'default'       => {px:  0.0,  py:  0.0, mx: true, my: true}
    ];
    
    /**
     * no touch.
    **/
    private var axes_xy:FlxAxes = FlxAxes.XY;
    private var axes_xn:FlxAxes = FlxAxes.X;
    private var axes_ny:FlxAxes = FlxAxes.Y;
    private var axes_nn:FlxAxes = FlxAxes.NONE;
    
    /**
     * no touch.
    **/
    private var lane:StrumLine;
    private var char:Character;
    private var camp:FlxPoint;
    private var divi:Int;
    private var name:String;
    private var data:{px:Float, py:Float, mx:Bool, my:Bool};
    
    /**
     * 
    **/
    public function new(id:Int, k:Int = -1)
    {
        game = PlayState.instance;
        defaultID = id;
        
        if (k == null || k < -1)
            k = -1;
        
        strumLineFollowTarget = defaultID;
        strumLineAnimTarget   = defaultID;
        
        characterFollowTarget = k;
        characterAnimTarget   = k;
    }
    
    public function destroy():Void
    {
        if (camFollowPos != null)
            camFollowPos.put();
        if (camOffset != null)
            camOffset.put();
        if (movement != null)
            movement.put();
        if (mapAnimMultiplyOffset != null)
            mapAnimMultiplyOffset.clear();
        
        camFollowPos = null;
        camOffset = null;
        movement = null;
        mapAnimMultiplyOffset = null;
        
        lane = null;
        char = null;
        camp = null;
        data = null;
    }
    
    /**
     * 
    **/
    public function getCamPos(point:FlxPoint = null, defPoint:FlxPoint = null, addOffsetAxes:FlxAxes = null):FlxPoint
    {
        if (point == null)
            point = FlxPoint.get();
        
        lane = game.strumLines.members[strumLineFollowTarget];
        divi = 0;
        
        if (camFollowAxes == axes_xy)
        {
            point.x = camFollowPos.x;
            point.y = camFollowPos.y;
        }
        else if (lane is StrumLine)
        {
            if (characterFollowTarget < 0)
            {
                for (k => c in lane.characters)
                {
                    if (c == null || !c.visible || !c.exists)
                        continue;
                    
                    camp = c.getCameraPosition();
                    point.x += camp.x;
                    point.y += camp.y;
                    camp.put();
                    divi++;
                }
                if (divi > 0)
                {
                    point.x = point.x / divi;
                    point.y = point.y / divi;
                }
            }
            else
            {
                char = lane.characters[characterFollowTarget];
                if (char is Character)
                {
                    camp = char.getCameraPosition();
                    point.x = camp.x;
                    point.y = camp.y;
                    camp.put();
                }
            }
        }
        else if (defPoint != null)
        {
            point.x = defPoint.x;
            point.y = defPoint.y;
            defPoint.putWeak();
        }
        
        if (camFollowAxes == axes_xn)
            point.x = camFollowPos.x;
        if (camFollowAxes == axes_ny)
            point.y = camFollowPos.y;
        
        if (addOffsetAxes == null)
            return point;
        
        if (addOffsetAxes == axes_xy || addOffsetAxes == axes_xn)
            point.x += camOffset.x;
        if (addOffsetAxes == axes_xy || addOffsetAxes == axes_ny)
            point.y += camOffset.y;
        
        return point;
    }
    
    /**
     * 
    **/
    public function getCamOff(point:FlxPoint = null, defPoint:FlxPoint = null):FlxPoint
    {
        if (point == null)
            point = FlxPoint.get();
        
        lane = game.strumLines.members[strumLineAnimTarget];
        char = null;
        point.x = point.y = 0.0;
        
        if (defPoint != null)
        {
            point.x = defPoint.x;
            point.y = defPoint.y;
            defPoint.putWeak();
        }
        
        if (lane is StrumLine)
        {
            if (characterAnimTarget > -1)
                char = lane.characters[characterAnimTarget];
            
            if (characterAnimTarget < 0 || char == null)
            {
                for (k => c in lane.characters)
                {
                    if (c == null || !c.visible || !c.exists)
                        continue;
                    
                    char = c;
                    break;
                }
            }
        }
        
        if (char is FlxSprite)
        {
            name = !(char.animation == null || char.animation.curAnim == null) ? char.animation.curAnim.name : 'default';
            data = mapAnimMultiplyOffset[name];
            if (data == null) data = mapAnimMultiplyOffset[name] = {
                px: 0.0,
                py: 0.0, 
                mx: true,
                my: true
            };
            
            if (moveAxes == axes_xy || moveAxes == axes_xn)
                point.x = movement.x;
            if (moveAxes == axes_xy || moveAxes == axes_ny)
                point.y = movement.y;
            
            if (data.px == null) data.px = 0.0;
            if (data.py == null) data.py = 0.0;
            if (data.mx == null) data.mx = true;
            if (data.my == null) data.my = true;
            
            point.x = data.mx ? (point.x * data.px) : data.px;
            point.y = data.my ? (point.y * data.py) : data.py;
        }
        else
        {
            point.x = 0.0;
            point.y = 0.0;
        }
        
        return point;
    }
    
    /**
     * 
    **/
    public function setCamFollowPos(x:Float = 0.0, y:Float = 0.0, a:FlxAxes = null):TargetCameraData
    {
        camFollowPos.x = x ?? 0.0;
        camFollowPos.y = y ?? 0.0;
        camFollowAxes  = a ?? axes_nn;
        return this;
    }
    
    /**
     * 
    **/
    public function setCamOff(x:Float = 0.0, y:Float = 0.0):TargetCameraData
    {
        camOffset.x = x ?? 0.0;
        camOffset.y = y ?? 0.0;
        return this;
    }
    
    /**
     * 
    **/
    public function setMovement(x:Float = 0.0, y:Float = 0.0, a:FlxAxes = null):TargetCameraData
    {
        movement.x   = x ?? 0.0;
        movement.y   = y ?? 0.0;
        moveAxes     = a ?? axes_nn;
        return this;
    }
}



class PlayStateCustomVars
{
    public var extra:Map<String, Dynamic> = [];
    public var cameras:Map<String, FlxCamera> = [];
    
    public var targetInfo:Map<Int, TargetCameraData> = [];
    
    public var isFollowCam:Bool = true;
    public var isLerpZoom:Bool = true;
    public var isFollowAngle:Bool = true;
    
    public var cameraSpeed:Float = 1.0;
    public var snapTime:Float = 0.0;
    public var snapSpeed:Float = 1.0;
    
    public var lerpZoomSpeed:Float = 1.0;
    public var lerpCamZoomSpeed:Float = 1.0;
    public var lerpHudZoomSpeed:Float = 1.0;
    
    public var multCamZoomAmount:Float = 1.0;
    public var multHudZoomAmount:Float = 1.0;
    
    public var camZoomAmount:Float = 0.015;
    public var hudZoomAmount:Float = 0.030;
    
    public var camZoomInterval:Int = 0;
    public var hudZoomInterval:Int = 0;
    public var camZoomModInterval:Int = 0;
    public var hudZoomModInterval:Int = 0;
    
    public var isLerpCamZoom:Bool = true;
    public var isLerpHudZoom:Bool = true;
    
    public var isBeatCamZoom:Bool = true;
    public var isBeatHudZoom:Bool = true;
    
    public var isCameraForcePos:Bool = false;
    public var isCameraForceMoveOffset:Bool = false;
    public var isCameraForceZoomTarget:Bool = false;
    
    public var camFollowPos:FlxPoint = FlxPoint.get();
    public var camScrollOffset:FlxPoint = FlxPoint.get();
    public var movement:FlxPoint = FlxPoint.get();
    
    public var timerCameraFollowPos:FlxTimer = new FlxTimer();
    public var tweenCameraFollowPos:FlxTween;
    
    public function new()
    {
        
    }
    
    public function destroy():Void
    {
        camFollowPos.put();
        movement.put();
        camScrollOffset.put();
        extra.clear();
        cameras.clear();
    }
    
    public function tweenCameraToPosition(?px:Null<Float>, ?py:Null<Float>, ?time:Null<Float>, ?snap:Null<Bool>, ?ease:Null<Float->Float>, ?onComplete:Null<Void->Void>):Void
    {
        isCameraForcePos = !(px == null && py == null);
        if (!(camFollowPos is FlxBasePoint)) return;
        
        var x:Float = CoolUtil.getDefault(px, camFollowPos.x);
        var y:Float = CoolUtil.getDefault(py, camFollowPos.y);
        var t:Float = CoolUtil.getDefault(time, 0.0);
        var onCompleteTween:Void->Void = onComplete;
        
        if (time == null && t <= 0.0)
        {
            camFollowPos.x = x;
            camFollowPos.y = y;
        }
        else if (snap == true)
        {
            camFollowPos.x = x;
            camFollowPos.y = y;
            snapTime = t;
            cancelCameraFollowTimer();
            timerCameraFollowPos.start(snapTime, function(tmr:FlxTimer):Void {
                if (onCompleteTween != null) onCompleteTween();
            }, 1);
        }
        else
        {
            cancelCameraFollowTween();
            tweenCameraFollowPos = FlxTween.tween(camFollowPos, {'x': x, 'y': y}, Math.max(time, FlxG.elapsed), {
                'ease': ease,
                'onComplete': function(twn:FlxTween):Void {
                    if (onCompleteTween != null) onCompleteTween();
                }
            });
        }
    }
    
    public function cancelCameraFollowTween():Void
    {
        if (tweenCameraFollowPos is FlxTween) tweenCameraFollowPos.cancel();
        tweenCameraFollowPos = null;
    }
    
    public function cancelCameraFollowTimer():Void
    {
        if (timerCameraFollowPos is FlxTimer) timerCameraFollowPos.cancel();
    }
}



var customs:PlayStateCustomVars = new PlayStateCustomVars();

/**
 * camGame.
 * camOverlay.
 * camHUD.
 * camOther.
 * camControls.
**/
var camOverlay:FlxCamera;
var camOther:FlxCamera;
var camControls:FlxCamera;


/**
 * utils.
**/
var cam_target_zoom_value:Float = 1.0;
var hud_target_zoom_value:Float = 1.0;
var cam_target_zoom_speed:Float = 1.0;
var hud_target_zoom_speed:Float = 1.0;

/**
 * utils.
**/
var cam_follow_position:FlxPoint = FlxPoint.get();
var cam_follow_previous:FlxPoint = FlxPoint.get();
var cam_follow_movement:FlxPoint = FlxPoint.get();
var cam_follow_stageoff:FlxPoint = FlxPoint.get();
var cam_follow_valueoff:FlxPoint = FlxPoint.get();
var cur_follow_position:FlxPoint = FlxPoint.get();
/**
 * reference 'TargetCameraData'.
**/
var __cur__target__zoom__data:TargetCameraData;
var __cur__target__move__data:TargetCameraData;


function create():Void
{
    //*******
    this.add(this.remove(this.strumLines, true));
    this.add(this.remove(this.splashHandler, true));
    //*******
    
    this.scripts.set("customs", customs);
    
    #if mobile
    //*******
    //*******sorry;
    camControls = FlxG.cameras.list[FlxG.cameras.indexOf(this.camHUD) + 1];
    if (![this.camGame, this.camHUD].contains(camControls))
        camControls.visible = false;
    else camControls = null;
    //*******
    //*******
    customs.cameras["camControls"] = camControls;
    #end
    
    camOverlay = customs.cameras["camOverlay"] = new FlxCamera();
    camOther   = customs.cameras["camOther"]   = new FlxCamera();
    
    //*******
    FlxG.cameras.insert(camOverlay, FlxG.cameras.indexOf(this.camHUD) + 0, false);
    FlxG.cameras.insert(camOther  , FlxG.cameras.indexOf(this.camHUD) + 1, false);
    FlxG.cameras.bgColor = FlxColor.TRANSPARENT;
    //*******
    
    for (i in 0...this.strumLines.members.length)
        customs.targetInfo[i] = new TargetCameraData(i, 0);
    
    customs.movement.set(20.0, 20.0);
    cur_follow_position.set(this.camFollow.x, this.camFollow.y);
}


function update(elapsed:Float):Void
{
    if (customs != null)
    {
        customs.snapSpeed = ((customs.snapTime -= elapsed) <= 0.0) ? 1.0 : 1000.0;
    }
    __camera__move__target(elapsed);
    __camera__zoom__target(elapsed);
    __player__anim__forced(elapsed);
}


function stepHit(step:Int):Void
{
    
}


function beatHit(beat:Int):Void
{
    if (!(Options.camZoomOnBeat && !this.camZooming && customs.isLerpZoom))
        return;
    if (!(FlxG.camera.zoom < this.maxCamZoom))
        return;
    
    var camBeatInt:Int = customs.camZoomInterval;
    var hudBeatInt:Int = customs.hudZoomInterval;
    var camBeatMod:Int = customs.camZoomModInterval;
    var hudBeatMod:Int = customs.hudZoomModInterval;
    
    if (camBeatMod < 0)
        camBeatMod = 0;
    if (hudBeatMod < 0)
        hudBeatMod = 0;
    
    var isBeatCam:Bool = (beat % this.camZoomingInterval == camBeatMod);
    var isBeatHud:Bool = (beat % this.camZoomingInterval == hudBeatMod);
    
    if (camBeatInt > 0)
        isBeatCam = (beat % camBeatInt == camBeatMod);
    if (hudBeatInt > 0)
        isBeatHud = (beat % hudBeatInt == hudBeatMod);
    
    if (customs.isBeatCamZoom && isBeatCam)
        FlxG.camera.zoom += (customs.camZoomAmount * customs.multCamZoomAmount) * this.camZoomingStrength;
    if (customs.isBeatHudZoom && isBeatHud)
        this.camHUD.zoom += (customs.hudZoomAmount * customs.multHudZoomAmount) * this.camZoomingStrength;
}


function destroy():Void
{
    if (customs != null) customs.destroy();
    
    cam_follow_position.put();
    cam_follow_previous.put();
    cam_follow_movement.put();
    cam_follow_stageoff.put();
    cam_follow_valueoff.put();
    cur_follow_position.put();
    
    customs = null;
}


function __camera__move__target(elapsed:Float):Void
{
    if (customs == null || !customs.isFollowCam)
        return;
    
    var k:Int = this.curCameraTarget;
    
    var speed:Float = customs.cameraSpeed;
    
    var camScrollOffset:FlxPoint = customs.camScrollOffset;
    var camFollowPos:FlxPoint = customs.camFollowPos;
    var movement:FlxPoint = customs.movement;
    
    var isFollowAngle:Bool = customs.isFollowAngle;
    var isCameraForcePos:Bool = customs.isCameraForcePos;
    var isCameraForceMoveOffset:Bool = customs.isCameraForceMoveOffset;
    
    var camOffset:FlxPoint;
    
    cam_follow_position.x = cam_follow_previous.x = camFollowPos.x;
    cam_follow_position.y = cam_follow_previous.y = camFollowPos.y;
    
    cam_follow_movement.x = cam_follow_stageoff.x = cam_follow_valueoff.x = 0.0;
    cam_follow_movement.y = cam_follow_stageoff.y = cam_follow_valueoff.y = 0.0;
    
    if (!((__cur__target__move__data = customs.targetInfo[k])== null))
    {
        cam_follow_previous = __cur__target__move__data.getCamPos(cam_follow_previous, null, null);
        cam_follow_movement = __cur__target__move__data.getCamOff(cam_follow_movement, customs.movement);
        
        camOffset = __cur__target__move__data.camOffset;
        cam_follow_valueoff.x = camOffset.x;
        cam_follow_stageoff.y = camOffset.y;
        
        speed = speed * __cur__target__move__data.cameraSpeed;
        isFollowAngle = (isFollowAngle && __cur__target__move__data.isFollowAngle);
    }
    
    FlxG.camera.followEnabled = false;
    speed = speed * customs.snapSpeed;
    
    if (!isCameraForcePos)
    {
        cam_follow_position.x = cam_follow_previous.x;
        cam_follow_position.y = cam_follow_previous.y;
    }
    
    if (!isCameraForcePos || (isCameraForceMoveOffset && isCameraForcePos))
    {
        cam_follow_valueoff.x = cam_follow_stageoff.x + cam_follow_movement.x;
        cam_follow_valueoff.y = cam_follow_stageoff.y + cam_follow_movement.y;
        if (isFollowAngle) FlxG.camera.angle = FlxMath.lerp(
            FlxG.camera.angle,
            0.0 + cam_follow_movement.x / 30.0,
            FlxMath.bound(elapsed * 2.4 / 0.4 * speed, 0.0, 1.0)
        );
    }
    
    var lerpValue:Float = FlxMath.bound(elapsed * 2.4 * speed, 0.0, 1.0);
    
    cur_follow_position.x = FlxMath.lerp(
        cur_follow_position.x,
        cam_follow_position.x + FlxG.camera.targetOffset.x + cam_follow_valueoff.x,
        lerpValue
    );
    cur_follow_position.y = FlxMath.lerp(
        cur_follow_position.y,
        cam_follow_position.y + FlxG.camera.targetOffset.y + cam_follow_valueoff.y,
        lerpValue
    );
    
    camFollowPos.x = cam_follow_position.x;
    camFollowPos.y = cam_follow_position.y;
    
    FlxG.camera.scroll.x = cur_follow_position.x + camScrollOffset.x - FlxG.camera.width / 2.0;
    FlxG.camera.scroll.y = cur_follow_position.y + camScrollOffset.y - FlxG.camera.height / 2.0;
    FlxG.camera.updateScroll();
}


function __camera__zoom__target(elapsed:Float):Void
{
    if (customs == null || !customs.isLerpZoom)
        return;
    
    this.camZooming = false;
    var lerpZoomSpeed:Float = customs.lerpZoomSpeed;
    
    cam_target_zoom_value = this.defaultCamZoom;
    hud_target_zoom_value = this.defaultHudZoom;
    cam_target_zoom_speed = customs.lerpCamZoomSpeed * lerpZoomSpeed;
    hud_target_zoom_speed = customs.lerpHudZoomSpeed * lerpZoomSpeed;
    
    if (customs.isCameraForceZoomTarget && !((__cur__target__zoom__data = customs.targetInfo[this.curCameraTarget]) == null))
    {
        if (__cur__target__zoom__data.zoom > 0.0)
            cam_target_zoom_value = __cur__target__zoom__data.zoom;
    }
    
    if (customs.isLerpCamZoom)
    {
        FlxG.camera.zoom = FlxMath.lerp(
            cam_target_zoom_value,
            FlxG.camera.zoom,
            FlxMath.bound(1.0 - (elapsed * 3.125 * cam_target_zoom_speed), 0.0, 1.0)
        );
    }
    if (customs.isLerpHudZoom)
    {
        this.camHUD.zoom = FlxMath.lerp(
            hud_target_zoom_value,
            this.camHUD.zoom,
            FlxMath.bound(1.0 - (elapsed * 3.125 * hud_target_zoom_speed), 0.0, 1.0)
        );
    }
}


function __player__anim__forced(elapsed:Float):Void
{
    var animFinished:Bool = false;
    
    for (i => lane in this.strumLines.members)
    {
        for (k => char in lane.characters)
        {
            if (!(char is Character))
                continue;
            
            animFinished = (char.isAnimFinished() || char.getAnimName() == null);
            
            if (!animFinished && (char.lastAnimContext == "SING" || char.lastAnimContext == "MISS"))
                char.lastAnimContext = "LOCK";
            if (animFinished && char.lastAnimContext == "LOCK")
                char.lastAnimContext = "SING";
        }
    }
}
