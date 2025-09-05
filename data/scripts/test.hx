            import flixel.util.FlxTimeEventManager;
            import flixel.util.FlxTimeEvent;
            
            var player:Character;
            var point:FlxPoint;
            var speed:Float;
            
            function postCreate():Void
            {
                player = this.strumLines.members[0].characters[0];
                point = FlxPoint.get(player.x, player.y);
                speed = 1;
                
                if (FlxTimeEvent.globalManager == null)
                    FlxTimeEvent.globalManager = new FlxTimeEventManager();
                
                FlxTimeEvent.globalManager.clear();
                FlxTimeEvent.globalManager.reset();
                
                FlxTimeEvent.tween(10000, 5000, {
                    ease: FlxEase.quadInOut,
                    onUpdate: function(_:FlxTimeEvent):Void {
                        this.stage.stageSprites['bg'].angle = (0 + (360 * _.scale));
                    },
                    onComplete: function(_:FlxTimeEvent):Void {
                        this.stage.stageSprites['bg'].angle = 0;
                    }
                });
                
                FlxTimeEvent.num(20000, 30000, 360, 0, {
                    onUpdate: function(_:FlxTimeEvent):Void {
                        this.stage.stageSprites['bg'].angle = _.value;
                    }
                });
                
                FlxTimeEvent.once(50000, function(_:FlxTimeEvent):Void {
                    FlxG.camera.flash(FlxColor.RED, 2.0, null, true);
                });
                
                if (this.curSongLower != "tutorial")
                {
                    FlxTimeEvent.globalManager.active = false;
                }
                else
                {
                    FlxTimeEvent.globalManager.timeLimit = Conductor.crochet / 4;
                    FlxTimeEvent.globalManager.start(-Conductor.crochet * 10);
                    FlxTimeEvent.multiple([for (i => e in this.events) if (e.name == "BPM Change") e.time + 0.01], function(_:FlxTimeEvent):Void {
                        FlxTimeEvent.globalManager.timeLimit = Conductor.crochet/ 4;
                    });
                }
            }
            
            function update(elapsed:Float):Void
            {
                var sin:Float = Math.sin(Conductor.curBeatFloat) * speed;
                player.x = point.x + sin;
                player.y = point.y - sin;
                FlxTimeEvent.globalManager.timeUpdate(Conductor.songPosition);
            }
            
            function destroy():Void
            {
                point.put();
                FlxTimeEvent.globalManager.clear();
                FlxTimeEvent.globalManager.reset();
                FlxTimeEvent.globalManager.pause();
            }