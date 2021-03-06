package components.data;
import flixel.FlxState;
import components.visual.SpriteComponent;
import components.meta.IComponent;
import components.Object;

/**
 * ...
 * @author Miguel M.
 */
class WidthHeightComponent implements IComponent {

    public var parentObject:Object;
    
    public var width(get, never):Float;
    public var height(get, never):Float;
    
    private var _shapeComponent:ShapeComponent;
    private var _spriteComponent:SpriteComponent;
    
    public function new() {}
    
    public function componentAdded(object:Object):Void {
        parentObject = object;
        
        _spriteComponent = object.getComponent(SpriteComponent);
        if (_spriteComponent != null)
            return;
    }
    
    public function update(elapsed:Float):Void {}
    
    public function componentRemoved():Void {
        _shapeComponent = null;
        _spriteComponent = null;
    }
    
    public function parentAdded(state:FlxState):Void {}
    
    public function parentRemoved(state:FlxState):Void {}
    
    function get_width():Float {
        if (_spriteComponent != null)
            return _spriteComponent.sprite.width;
        return 0;
    }
    
    function get_height():Float {
        if (_spriteComponent != null)
            return _spriteComponent.sprite.height;
        return 0;
    }
    
}