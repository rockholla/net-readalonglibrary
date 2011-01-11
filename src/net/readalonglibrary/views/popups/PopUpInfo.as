package net.readalonglibrary.views.popups
{
	import org.rockholla.controls.Button;
	import org.rockholla.popups.PopUpMessage;
	
	import flash.events.MouseEvent;
	
	/**
	 * A pop up for errors
	 * 
	 * @author Patrick Force
	 * 
	 */
	public class PopUpInfo extends PopUpMessage
	{
		[Embed(source="assets/images/dialog-information.png")]
		protected var _imageSource:Class;
		
		protected var _okButton:Button = new Button();
		
		/**
		 * Constructor
		 * 
		 */
		public function PopUpInfo()
		{
			super();
			this.title = "Info";
		}
		
		//-----------------------------------------------------------
		//
		// OVERRIDEN CLASS METHODS
		//
		//-----------------------------------------------------------
		/**
		 * Creates content specific to an error pop up
		 * 
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			this.image.source = this._imageSource;
			
			this._okButton.label = "OK";
			this._okButton.addEventListener(MouseEvent.CLICK, this._onClose);
			this.popUpButtons.addElement(this._okButton);
		}
		
	}
}