package components;
import components.meta.IComponent;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import interfaces.IStateCallbacks;
import openfl.errors.Error;

/**
 * Bothersome workaround class to get rid of default flixel physics.
 * @author Miguel M.
 */
class Object extends FlxBasic implements IStateCallbacks
{
    public var x:Float;
    public var y:Float;
    
    public var state:FlxState;
    
    public var components:Array<IComponent>;
    var _componentTypes:Array<String>;
    
    public function new(X:Float = 0, Y:Float = 0) {
        super();
        
        this.x = X;
        this.y = Y;
        
        components = [];
        _componentTypes = [];
    }
    
    public function addComponent<T:IComponent>(component:T):T {
        if (_componentTypes.indexOf(component.name) != -1)
            throw new Error('Duplicate component added: ${component.name}.', 1);
        
        _componentTypes.push(component.name);
        components.push(component);
        
        component.componentAdded(this);
        
        return component;
    } // add component
    
    public function removeComponent<T:IComponent>(component:Class<T>):T {
        var toRemove = getComponent(component);
        if (toRemove == null)
            throw new Error('Does not contain ${component} components.', 1);
        _componentTypes.remove(toRemove.name);
        components.remove(toRemove);
        
        toRemove.componentRemoved();
        
        return toRemove;
    } // remove component
    
    public function getComponent<T:IComponent>(component:Class<T>):T {
        var wantedComponentName:String = Type.getClassName(component);
        for (component in components) {
            if (component.name == wantedComponentName)
                return (cast component);
        }
        return null;
    } // get component
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        for (component in components)
            component.update(elapsed);
    } // Update
    
    public function added(state:FlxState) {
        this.state = state;
        
        for (component in components)
            component.parentAdded(state);
    } // Added
    
    public function removed(state:FlxState) {
        this.state = null;
        
        for (component in components)
            component.parentRemoved(state);
    } // Removed
}