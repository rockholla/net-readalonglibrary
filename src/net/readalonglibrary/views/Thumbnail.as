package net.readalonglibrary.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import org.rockholla.utils.MathUtil;
	import net.readalonglibrary.events.ReadAlongLibraryEvent;
	import net.readalonglibrary.models.UserBook;
	
	import spark.components.Group;
	
	public class Thumbnail extends Group
	{
		
		public static const WIDTH:Number = 130;
		
		public var image:Image;
		public var userBook:UserBook;
		
		public function Thumbnail(userBook:UserBook)
		{
			super();
			this.userBook = userBook;
			
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.alpha = 0.7;
			dropShadow.strength = 0.6;
			dropShadow.distance = 4;
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.angle = 90;
			var filters:Array = new Array();
			filters.push(dropShadow);
			this.filters = filters;
			
			this.refreshDimensions();
			
			this.selectable = true;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this._setThumbnail();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			this.image.width = unscaledWidth;
			this.image.height = unscaledHeight;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected function _setThumbnail():void
		{	
			this.image = new Image();
			this.image.source = new Bitmap(this.userBook.thumbnailContent.bitmapData, "auto", true);
			this.addElement(this.image);
		}
		
		public function refreshDimensions():void
		{
			this.width = WIDTH;
			this.height = this.userBook.thumbnailContent.height * WIDTH/this.userBook.thumbnailContent.width;
		}
		
		public function set selectable(selectable:Boolean):void
		{
			if(selectable)
			{
				this.buttonMode = true;
				this.useHandCursor = true;
				this.addEventListener(MouseEvent.CLICK, this._onClicked);	
			}
			else
			{
				this.buttonMode = false;
				this.useHandCursor = false;
				this.removeEventListener(MouseEvent.CLICK, this._onClicked);
			}
		}
		
		public function get selectable():Boolean
		{
			return this.buttonMode;
		}

		protected function _onClicked(event:MouseEvent):void
		{
			this.image.source = new Bitmap(this.userBook.firstPageContent.bitmapData, "auto", true);
			(this.parent as LibraryDisplay).thumbnailsSelectable = false;
			(this.parent as LibraryDisplay).setElementIndex(this, (this.parent as LibraryDisplay).numElements - 1);
			(this.parent as LibraryDisplay).selectedThumbnail = this;
			var toX:Number = (this.parent.width - (this.userBook.pageWidth * 2))/2 + this.userBook.pageWidth;
			var toY:Number = (this.parent.height - this.userBook.pageHeight)/2;
			TweenLite.to(this, 0.5, 
				{
					x: toX, 
					y: toY, 
					rotation: 0, 
					width: this.userBook.pageWidth, 
					height: this.userBook.pageHeight, 
					onComplete: this._dispatchSelectionEvent,
					ease: Expo.easeOut
				}
			);
				
		}
		
		public function putBack():void
		{	
	
			(this.parent as LibraryDisplay).thumbnailsSelectable = true;
			(this.parent as LibraryDisplay).selectedThumbnail = null;
			var originalWidth:Number = this.userBook.thumbnailContent.width;
			var originalHeight:Number = this.userBook.thumbnailContent.height;
			var ratio:Number = WIDTH/originalWidth;
			this.image.source = new Bitmap(this.userBook.thumbnailContent.bitmapData, "auto", true);
			TweenLite.to(this, 0.5, 
				{
					width: WIDTH,
					height: Math.ceil(originalHeight * ratio),
					x: MathUtil.randomInRange(LibraryDisplay.PADDING, this.parent.parent.width - LibraryDisplay.PADDING),
					y: MathUtil.randomInRange(LibraryDisplay.PADDING, this.parent.parent.height - LibraryDisplay.PADDING),
					rotation: MathUtil.randomInRange(-10, 10),
					ease: Bounce.easeOut
				}
			);
		}
		
		protected function _dispatchSelectionEvent():void
		{
			this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.BOOK_SELECTED, true));
		}
	}
}