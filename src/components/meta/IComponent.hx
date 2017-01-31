package components.meta;
import components.Object;
import flixel.FlxState;
import interfaces.IStateCallbacks;

/**
 * @author Miguel M.
 */
@:autoBuild(components.meta.RequiresMacro.checkRequires('requires'))
@:autoBuild(components.meta.InjectComponentName.build())
@:build(components.meta.InjectComponentName.buildInterface())
interface IComponent {
    public var parentObject:Object;
    public function componentAdded(object:Object):Void;
    public function componentRemoved():Void;
    public function parentAdded(state:FlxState):Void;
    public function parentRemoved(state:FlxState):Void;
    public function update(elapsed:Float):Void;
}