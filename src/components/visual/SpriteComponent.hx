package components.visual;
import flixel.FlxSprite;
import flixel.FlxState;
import components.meta.IComponent;
import components.Object;

/**
 * ...
 * @author Miguel M.
 */
class SpriteComponent implements IComponent {

    public var sprite:FlxSprite;
    
    public function new() {
        sprite = new FlxSprite();
    }
    
    public var parentObject:Object;
    
    public function componentAdded(object:Object):Void {
        parentObject = object;
        if(sprite == null)
            sprite = new FlxSprite();
        if (parentObject.state != null)
            parentObject.state.add(sprite);
    }
    
    public function update(elapsed:Float):Void {
        sprite.x = parentObject.x;
        sprite.y = parentObject.y;
    }
    
    public function componentRemoved():Void {
        sprite.destroy();
        sprite = null;
    }
    
    public function parentAdded(state:FlxState):Void {
        state.add(sprite);
    }
    
    public function parentRemoved(state:FlxState):Void {
        state.remove(sprite);
    }
    
}