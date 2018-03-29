package haxe.ui.components;

import haxe.ui.core.Component;
import haxe.ui.core.DataBehaviour;
import haxe.ui.core.InteractiveComponent;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.UIEvent;
import haxe.ui.layouts.HorizontalLayout;
import haxe.ui.styles.Style;

class CheckBox2 extends InteractiveComponent {
    //***********************************************************************************************************
    // Public API
    //***********************************************************************************************************
    @:behaviour(TextBehaviour)              public var text:String;
    @:behaviour(SelectedBehaviour)          public var selected:Bool;

    //***********************************************************************************************************
    // Internals
    //***********************************************************************************************************
    private override function createDefaults() {  // TODO: remove this eventually, @:layout(...) or something
        super.createDefaults();
        _defaultLayout = new HorizontalLayout();
    }

    private override function createChildren() {
        super.createChildren();
        
        if (findComponent(Value) == null) {
            var value = new Value();
            value.id = '${cssName}-value';
            value.addClass('${cssName}-value');
            value.scriptAccess = false;
            addComponent(value);
        }
        
        registerInternalEvents(Events);
    }
    
    //***********************************************************************************************************
    // Overrides
    //***********************************************************************************************************
    private override function applyStyle(style:Style) {  // TODO: remove this eventually, @:styleApplier(...) or something
        super.applyStyle(style);
        var label:Label = findComponent(Label);
        if (label != null &&
            (label.customStyle.color != style.color ||
            label.customStyle.fontName != style.fontName ||
            label.customStyle.fontSize != style.fontSize ||
            label.customStyle.cursor != style.cursor)) {

            label.customStyle.color = style.color;
            label.customStyle.fontName = style.fontName;
            label.customStyle.fontSize = style.fontSize;
            label.customStyle.cursor = style.cursor;
            label.invalidateStyle();
        }
    }
}

//***********************************************************************************************************
// Custom children
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class Value extends InteractiveComponent {
    public function new() {
        super();
        #if (openfl && !flixel)
        mouseChildren = false;
        #end
    }

    private override function onReady() { // use onReady so we have a parentComponent
        var icon:Image = findComponent(Image);
        if (icon == null) {
            icon = new Image();
            icon.id = '${parentComponent.cssName}-icon';
            icon.addClass('${parentComponent.cssName}-icon');
            addComponent(icon);
        }
    }
    
    private override function applyStyle(style:Style) {
        super.applyStyle(style);
        var icon:Image = findComponent(Image);
        if (icon != null) {
            icon.resource = style.icon;
        }
    }
}

//***********************************************************************************************************
// Behaviours
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class TextBehaviour extends DataBehaviour {
    private override function validateData() {
        var label:Label = _component.findComponent(Label, false);
        if (label == null) {
            label = new Label();
            label.id = '${_component.cssName}-label';
            label.addClass('${_component.cssName}-label');
            label.scriptAccess = false;
            _component.addComponent(label);
        }
        
        label.text = _value;
    }
}

@:dox(hide) @:noCompletion
private class SelectedBehaviour extends DataBehaviour {
    private override function validateData() {
        var valueComponent:Value = _component.findComponent(Value);
        if (_value == true) {
            valueComponent.addClass(":selected");
        } else {
            valueComponent.removeClass(":selected");
        }
        
        _component.dispatch(new UIEvent(UIEvent.CHANGE));
    }
}

//***********************************************************************************************************
// Events
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class Events extends haxe.ui.core.Events  {
    private var _checkbox:CheckBox2;
    
    public function new(checkbox:CheckBox2) {
        super(checkbox);
        _checkbox = checkbox;
    }
    public override function register() {
        if (hasEvent(MouseEvent.MOUSE_OVER, onMouseOver) == false) {
            registerEvent(MouseEvent.MOUSE_OVER, onMouseOver);
        }
        if (hasEvent(MouseEvent.MOUSE_OUT, onMouseOut) == false) {
            registerEvent(MouseEvent.MOUSE_OUT, onMouseOut);
        }
        if (hasEvent(MouseEvent.CLICK, onClick) == false) {
            registerEvent(MouseEvent.CLICK, onClick);
        }
    }
    
    public override function unregister() {
        unregisterEvent(MouseEvent.MOUSE_OVER, onMouseOver);
        unregisterEvent(MouseEvent.MOUSE_OUT, onMouseOut);
        unregisterEvent(MouseEvent.CLICK, onClick);
    }
    
    private function onMouseOver(event:MouseEvent) {
        _target.addClass(":hover");
        _target.findComponent(Value).addClass(":hover");
    }
    
    private function onMouseOut(event:MouseEvent) {
        _target.removeClass(":hover");
        _target.findComponent(Value).removeClass(":hover");
    }
    
    private function onClick(event:MouseEvent) {
        _checkbox.selected = !_checkbox.selected;
    }
}