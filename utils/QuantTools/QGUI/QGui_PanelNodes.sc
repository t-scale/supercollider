QGui_PanelNodes : UserView {
	classvar >thisClassDebugging = false;

	var parent, bounds;
	var objects, <nodes;
	var <>display;

	var yPositionNode, yPositionNodeStart, ySizeNode;

	*new { | parent, bounds |
		var me = super.new(parent, bounds ?? {this.sizeHint} );
		me.canFocus = true;
		me.init(parent, bounds);
		^me;
	}

	init { |argParent, argBounds|
		(QGui.debbuging and: thisClassDebugging).if({
			"\n% [%, %]".format(thisMethod, argParent, argBounds).postln;
		});

		parent = argParent;
		bounds = argBounds;

		objects = Dictionary.new();
		nodes = Dictionary.new();

		this.name = "QGui_PanelNodes";
		this.setDisplay_(false);

		yPositionNodeStart = 25;
		ySizeNode = 200;

		this.initControl;

		this.onResize_{
			(this.name + "resize").warn;
			objects[\ButtonAddNode].bounds_(Rect.offsetEdgeTop(this.bounds, 5,5,5,15));
		};

		this.drawFunc = { this.draw };
	}

	initControl {
		(QGui.debbuging and: thisClassDebugging).if({ thisMethod.postln });

		objects.put(\ButtonAddNode, QGui_Button.new(this)
			.string_("Add")
			.colorFrame_(Color.new255(120,120,120))
			.keepingState_(false)
			.action_{|button|
				"\n>>> QGui_PanelNodes button AddNode".postln;
				QGui.addNode(\node);
				this.recall;
			};
		);
		/*
		QGui.getNodes(QGui.currentStage).do({|nodeName, i|
		this.addNode(nodeName);
		});
		*/
	}

	setDisplay_ {|bool|
		(QGui.debbuging and: thisClassDebugging).if({ "% [%]".format(thisMethod, bool).postln; });

		display = bool;
		this.visible_(bool);
	}

	positionOfNodes {
		(QGui.debbuging and: thisClassDebugging).if({ thisMethod.postln });
		QGui.getNodesGUI(QGui.currentStage).do({|oneNode, i|
			oneNode.display.if({
				yPositionNode = ((ySizeNode + 5)*i ) + yPositionNodeStart;
				oneNode.moveTo(yPositionNode).recall;
			});
		});
	}

	recall{
		(QGui.debbuging and: thisClassDebugging).if({ thisMethod.postln });

		/*
		this.bounds_(Rect.offsetEdgeRight(parent, 10,50,50, parent.bounds.width - 325));
		objects[\ButtonAddNode].bounds_(Rect.offsetEdgeTop(this.bounds, 5,5,5,15));
		*/
		this.positionOfNodes;
	}

	draw {
		// (QGui.debbuging and: thisClassDebugging).if({ thisMethod.postln });
		this.background_(Color.new255(30,30,30));
		Pen.width = 1;
		Pen.strokeColor = Color.new255(20,20,20);
		Pen.addRect(Rect(0,0, this.bounds.width, this.bounds.height));
		Pen.stroke;
	}

}