package components.meta;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author Miguel M.
 */
class InjectComponentName{

    macro static public function build():Array<Field> {
        var fields = Context.getBuildFields();
        var localClass = Context.getLocalClass().get();
        
        var completeClassName:String = localClass.pack.join('.') + '.' + localClass.name;
        
        fields.push({
            name:  "name",
            access:  [Access.APublic],
            kind: FieldType.FProp('default', 'never', macro:String, macro $v{completeClassName}), 
            pos: Context.currentPos(),
        });
        
        return fields;
    }
    
    macro static public function buildInterface():Array<Field> {
        var fields = Context.getBuildFields();
        
        fields.push({
            name:  "name",
            access:  [Access.APublic],
            kind: FieldType.FProp('default', 'never', macro:String), 
            pos: Context.currentPos(),
        });
        
        return fields;
    }
    
}