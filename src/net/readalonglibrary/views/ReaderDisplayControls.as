package net.readalonglibrary.views
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	
	import net.patrickforce.controls.Button;
	import net.patrickforce.controls.LinkedBitmapImage;
	import net.readalonglibrary.events.ReadAlongLibraryEvent;
	
	import spark.components.Group;
	import spark.layouts.HorizontalLayout;
	
	public class ReaderDisplayControls extends Group
	{
		
		public var backButton:Button;
		public var playButton:Button;
		public var pauseButton:Button;
		public var stopButton:Button;
		
		public function ReaderDisplayControls()
		{
			super();
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 20;
			this.layout = layout;
			
			this.backButton = new Button();
			this.backButton.styleName = "backButton";
			this.backButton.toolTip = "Put this book back and return to the library";
			this.backButton.addEventListener(MouseEvent.CLICK, this._dispatchEvent);
			
			this.playButton = new Button();
			this.playButton.styleName = "playButton";
			this.playButton.toolTip = "Play the sound!";
			
			this.stopButton = new Button();
			this.stopButton.styleName = "stopButton";
			this.stopButton.toolTip = "Stop the sound";		
			
			this.pauseButton = new Button();
			this.pauseButton.styleName = "pauseButton";
			this.pauseButton.toolTip = "Pause the sound";
			
			this.audioEnabled = true;

		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.addElement(this.backButton);
			this.addElement(this.playButton);
			this.addElement(this.pauseButton);
			this.addElement(this.stopButton);
		}
		
		protected function _dispatchEvent(event:Event):void
		{
			if(event.target == this.backButton)
			{
				this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.PUT_BOOK_BACK, true));
			}
			else if(event.target == this.playButton)
			{
				this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.PLAY_AUDIO, true));
			}
			else if(event.target == this.pauseButton)
			{
				this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.PAUSE_AUDIO, true));
			}
			else if(event.target == this.stopButton)
			{
				this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.STOP_AUDIO, true));
			}
		}
		
		public function set audioEnabled(value:Boolean):void
		{
			this.playButton.enabled = value;
			this.stopButton.enabled = value;
			this.pauseButton.enabled = value;
			
			if(value)
			{
				this.playButton.addEventListener(MouseEvent.CLICK, this._dispatchEvent);
				this.stopButton.addEventListener(MouseEvent.CLICK, this._dispatchEvent);
				this.pauseButton.addEventListener(MouseEvent.CLICK, this._dispatchEvent);
			}
			else
			{
				this.playButton.removeEventListener(MouseEvent.CLICK, this._dispatchEvent);
				this.stopButton.removeEventListener(MouseEvent.CLICK, this._dispatchEvent);
				this.pauseButton.removeEventListener(MouseEvent.CLICK, this._dispatchEvent);
			}
		}
											
	}
}