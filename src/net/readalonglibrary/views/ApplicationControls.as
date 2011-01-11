package net.readalonglibrary.views
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.rockholla.controls.Button;
	import net.readalonglibrary.events.ReadAlongLibraryEvent;
	
	import spark.components.Group;
	import spark.layouts.HorizontalLayout;
	
	public class ApplicationControls extends Group
	{
		
		public var helpButton:Button;
		public var loveButton:Button;
		
		public function ApplicationControls()
		{
			super();
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = -20;
			this.layout = layout;
			
			this.helpButton = new Button();
			this.helpButton.styleName = "helpButton";
			this.helpButton.toolTip = "Need some help?";
			this.helpButton.addEventListener(MouseEvent.CLICK, this._dispatchEvent);
			
			this.loveButton = new Button();
			this.loveButton.styleName = "loveButton";
			this.loveButton.toolTip = "Guess what?";
			this.loveButton.addEventListener(MouseEvent.CLICK, this._dispatchEvent);
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.addElement(this.helpButton);
			this.addElement(this.loveButton);
		}
		
		protected function _dispatchEvent(event:Event):void
		{
			if(event.target == this.helpButton)
			{
				this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.SHOW_HELP, true));
			}
			else if(event.target == this.loveButton)
			{
				this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.SHOW_LOVE, true));
			}
		}
	}
}