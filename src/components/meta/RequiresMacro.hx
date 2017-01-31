package components.meta;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;

/**
 * ...
 * @author Miguel M.
 */
class RequiresMacro {

    /**
     * Checks if the object implementing this component implements specified components.
     * Autoadds them if they are not already present.
     * @param tag       tag for use, i.e., @tag('need.this.Component')
     */
    macro static public function checkRequires(tag:String):Array<Field> {
        
        var required:Array<String> = [];
        
        switch(Context.getLocalType()) {
            case TInst(t, _):
                for (meta in t.get().meta.get()) {
                    if (meta.name.toLowerCase() != tag.toLowerCase())
                        continue;
                    for (requiredMeta in meta.params) {
                        switch(requiredMeta.expr) {
                            case EConst(CString(name)):
                                required.push(name);
                            default:
                                throw new Error('Invalid requires tag.', meta.pos);
                        }
                    }
                }
            default: {}
        }
        
        if(required.length == 0)
            return null;
        
        var fields = Context.getBuildFields();
        
        var position = Context.currentPos();
        
        function classNameToIdentity(classPath:String):Expr {
            var splitPath:Array<String> = classPath.split('.');
            
            function makeRecursively(elems:Array<String>):Expr {
                if (elems.length == 1)
                    return {expr : EConst(CIdent(elems.pop())), pos : position};
                var field = elems.pop();
                var of = makeRecursively(elems);
                return {
                    expr : EField(of, field),
                    pos : position
                };
            }
            
            return makeRecursively(splitPath);
        }
        
        function checkForComponent(classPath:String):Expr {
            var classToRequire = classNameToIdentity(classPath);
            var classPackage:Array<String> = classPath.split('.');
            var className:String = classPackage.pop();
            return {
                    expr : EIf( {
                                    expr: EBinop(OpEq, 
                                        {
                                            expr : ECall(   {
                                                                expr:EField(macro object, 'getComponent'),
                                                                pos:position
                                                            },
                                                            [classToRequire]),
                                            pos: position
                                        },
                                    macro null),
                                    pos: position 
                                },
                                {
                                    expr: ECall({
                                                    expr:EField(macro object, 'addComponent'),
                                                    pos:position
                                                },
                                                [{
                                                    expr : ENew({
                                                        pack : classPackage,
                                                        name : className
                                                    }, []),
                                                    pos : position
                                                }]) ,
                                    pos : position
                                },
                                null),
                    pos  : position
                    };
        }
        
        
        for (field in fields) {
            if (field.name != 'componentAdded')
                continue;
            switch(field.kind) {
                case FFun(f):
                    var checks:Array<Expr> = [];
                    for (requiredMeta in required) {
                        checks.push(checkForComponent(requiredMeta));
                    }
                    checks.push(f.expr);
                    f.expr = {
                        expr : EBlock(checks),
                        pos  : f.expr.pos
                    };
                default: {}
            }
        }
        
        return fields;
    }
    
}