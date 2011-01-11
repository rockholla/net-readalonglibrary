package net.readalonglibrary.views.popups
{
	import net.patrickforce.controls.Button;
	import net.patrickforce.popups.PopUpMessage;
	
	import flash.events.MouseEvent;
	
	/**
	 * A pop up for love
	 * 
	 * @author Patrick Force
	 * 
	 */
	public class PopUpLove extends PopUpMessage
	{
		[Embed(source="assets/images/dialog-love.png")]
		protected var _imageSource:Class;
		
		protected var _okButton:Button = new Button();
		
		/**
		 * Constructor
		 * 
		 */
		public function PopUpLove()
		{
			super();
			this.title = "Well,";
			this.message = "Uncle Patrick Loves Mara.";
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