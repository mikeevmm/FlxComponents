package components.input;
import collisions.math.Point;
import components.physics.CollisionsComponent;
import flixel.FlxG;
import flixel.FlxState;
import components.meta.IComponent;
import components.Object;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import openfl.errors.Error;

/**
 * Implements a virtual joysticl
 * @author Miguel M.
 */
class InputComponent implements IComponent {

    public var parentObject:Object;
    
    public var virtualJoystick:Point;
    public var virtualPad:Pad;

    function init() {
        virtualJoystick = new Point(0, 0);
        virtualPad = new Pad();
    }

    public function new() {
        init();
    }

    public function componentAdded(object:Object):Void {
        parentObject = object;
        init();
    }

    public function update(elapsed:Float):Void {
        updateJoystick();
        updatePad();
    }

    public function componentRemoved():Void {
        parentObject = null;
    }

    public function parentAdded(state:FlxState):Void {}

    public function parentRemoved(state:FlxState):Void {}

    function updateJoystick() {
        virtualJoystick = new Point();

        if (FlxG.keys.pressed.LEFT)
            virtualJoystick.x = -1;
        if (FlxG.keys.pressed.RIGHT)
            virtualJoystick.x = 1;
        if (FlxG.keys.pressed.UP)
            virtualJoystick.y = -1;
        if (FlxG.keys.pressed.DOWN)
            virtualJoystick.y = 1;
    }
    
    function updatePad() {
        virtualPad.reset();
        virtualPad.A = getKeyStatus(FlxKey.Z);
    }
    
    function getKeyStatus(key:FlxKey):Null<FlxInputState> {
        var anyJustPressed:Bool = false;
        var anyJustReleased:Bool = false;
        var anyPressed:Bool = false;
        
        // Check status can't handle ANY
        if (key == FlxKey.ANY) {
            if (FlxG.keys.justPressed.ANY)
                anyJustPressed = true;
            if (FlxG.keys.justReleased.ANY)
                anyJustReleased = true;
            if (FlxG.keys.pressed.ANY)
                anyPressed = true;
        } else {
            anyJustPressed = FlxG.keys.checkStatus(key, FlxInputState.JUST_PRESSED);
            anyJustReleased = FlxG.keys.checkStatus(key, FlxInputState.JUST_RELEASED);
            anyPressed = FlxG.keys.checkStatus(key, FlxInputState.PRESSED);
        }
        
        if (anyJustPressed)
            return FlxInputState.JUST_PRESSED;
        if (anyJustReleased)
            return FlxInputState.JUST_RELEASED;
        if (anyPressed)
            return FlxInputState.PRESSED;
        return null;
    }
}

@:forward(X, Y, A, B)
abstract Pad(PadTypedef) from PadTypedef to PadTypedef {
    inline public function new() {
        this = {
            A : null,
            B : null,
            X : null,
            Y : null
        };
    }

    public function reset() {
        this.A = null;
        this.B = null;
        this.X = null;
        this.Y = null;
    }
}

typedef PadTypedef = {
    var A : Null<FlxInputState>; // Bottom
    var B : Null<FlxInputState>; // Right
    var X : Null<FlxInputState>; // Left
    var Y : Null<FlxInputState>; // Right
}