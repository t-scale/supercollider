QGui_Button : UserView {

	var parent;
	var >name;
	var iconPath;
	var frameAlpha;
	var <value;
	var routine;
	// var originX, originY, sizeX, sizeY;


	*new { | parent, bounds |
		var me = super.new(parent, bounds ?? {this.sizeHint} );
		me.canFocus = true;
		me.init(parent, bounds);
		^me;
	}

	init { |argParent, argBounds|
		// "INIT".postln;
		parent = argParent;
		// rect = argBounds ?? Rect(0,0,50,50);
		frameAlpha = 0;
		name = "QGui_Button";
		value = 0;
		// "Rect %".format(rect).postln;

		this.drawFunc = { this.draw };
	}

	iconName{|name|
		iconPath = super.class.filenameSymbol.asString.dirname +/+ name ++ ".png";
		// iconPath.postln;
	}

	draw {
		(value == 1).if(
			{ this.background = Color.new255(50,60,70) }, // Color.new255(60,90,100)
			{ this.background = Color.clear }
		);
		iconPath.notNil.if({
			var img = Image.new(iconPath);
			this.backgroundImage_(img);
		});
		Pen.width = 1;
		Pen.strokeColor = Color.new255(20,180,240, frameAlpha);
		Pen.addRect(Rect(0,0, this.bounds.width, this.bounds.height));
		Pen.stroke;
	}

	// (5) define typical widget methods  (only those you need or adjust as needed)
	valueAction_{ |val| // most widgets have this
		// (value == 0).if( {value = 1}, {value = 0} );
		this.value_(val);
		this.doAction;
	}
	value_{ |val|       // in many widgets, you can change the
		// value and refresh the view , but not do the action.

		value = val;
		this.refresh;
	}

	mouseDown{ arg x, y, modifiers, buttonNumber, clickCount;
		// var newVal;

		// this allows for user defined mouseDownAction
		mouseDownAction.value(this, x, y, modifiers, buttonNumber, clickCount);
		/*
		// set the value and do the action
		([256, 0].includes(modifiers)).if{ // restrict to no modifier

		newVal= x.linlin(0,this.bounds.width,0,1);
		// translates the relative mouse position in pixels to a value between 0 and 1

		if (newVal != value) {this.valueAction_(newVal)}; // only do something if the value changed
		};
		*/

		(value == 0).if( {this.valueAction_(1);}, {this.valueAction_(0);} );
		// this.valueAction_(nil);

		// this.doAction;
		"MouseClickDown % [value %]".format(name, value).postln;
	}

	mouseEnter{
		// "MouseEnter %".format(name).postln;
		mouseEnterAction.value(this);
		this.frameEnter;
	}

	mouseLeave{
		// "MouseLeave %".format(name).postln;
		mouseLeaveAction.value(this);
		this.frameExit;
	}

	frameEnter {
		var time = 0.45;
		var frames = 30;
		routine.stop;
		routine = Routine({
			frames.do({|i|
				frameAlpha = (i+1)/frames * 255;
				this.refresh;
				(time/frames).wait;
			});
		}).play(AppClock);
	}

	frameExit {
		var time = 0.15;
		var frames = 15;
		routine.stop;
		routine = Routine({
			frames.do({|i|
				frameAlpha = (frames -(i+1))/frames * 255;
				this.refresh;
				(time/frames).wait;
			});
		}).play(AppClock)
	}
}