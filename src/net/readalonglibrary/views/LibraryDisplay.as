package net.readalonglibrary.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import org.rockholla.utils.MathUtil;
	import net.readalonglibrary.events.ReadAlongLibraryEvent;
	import net.readalonglibrary.models.UserBook;
	import net.readalonglibrary.models.UserLibrary;
	
	import spark.components.Group;
	
	public class LibraryDisplay extends Group
	{

		public static const PADDING:Number = 80;
		
		protected var _userLibrary:UserLibrary;
		public var selectedThumbnail:Thumbnail;
		
		public function LibraryDisplay()
		{
			super();
			
			this.addEventListener(ResizeEvent.RESIZE, this._onResize);
			FlexGlobals.topLevelApplication.systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, this._onKeyDown);
		}
		
		public function set userLibrary(userLibrary:UserLibrary):void
		{
			this._userLibrary = userLibrary;
			this.removeAllElements();
			for(var i:int = 0; i < this._userLibrary.userBooks.length; i++)
			{
				this._placeBook(this._userLibrary.userBooks[i] as UserBook);	
			}
		}
		
		protected function _placeBook(userBook:UserBook):void
		{
			var thumbnail:Thumbnail = new Thumbnail(userBook);
			thumbnail.x = MathUtil.randomInRange(PADDING, this.parent.width - PADDING - thumbnail.width);
			thumbnail.y = MathUtil.randomInRange(PADDING, this.parent.height - PADDING - thumbnail.width);
			thumbnail.addEventListener(FlexEvent.ADD, _onThumbnailAdded);
			this.addElement(thumbnail);
		}
		
		protected function _onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == 83)
			{
				this.shuffleBooks();
			}
		}
		
		public function shuffleBooks():void
		{
			for(var i:int; i < this.numElements; i++)
			{
				if(this.getElementAt(i) is Thumbnail && !((this.getElementAt(i) as Thumbnail) == this.selectedThumbnail))
				{
					TweenLite.to
					(
						this.getElementAt(i), 
						1, 
						{
							x: MathUtil.randomInRange(PADDING, this.parent.width - PADDING - this.getElementAt(i).width),
							y: MathUtil.randomInRange(PADDING, this.parent.height - PADDING - this.getElementAt(i).width),
							rotation: MathUtil.randomInRange(-10, 10),
							ease: Expo.easeOut
						}
					);
				}
			}
		}
		
		public function _onResize(event:ResizeEvent):void
		{
			for(var i:int = 0; i < this.numElements; i++)
			{
				if(this.getElementAt(i) is Thumbnail)
				{
					var child:* = this.getElementAt(i);
					var newX:Number = -1;
					var newY:Number = -1;
					if((child as Thumbnail).selectable)
					{
						// see if bottom right is out of acceptable area
						if((child.x + child.width) > (this.parent.width - PADDING))
						{
							newX = MathUtil.randomInRange(PADDING, this.parent.width - PADDING);
						}
						if((child.y + child.height) > (this.parent.height - PADDING))
						{
							newY = MathUtil.randomInRange(PADDING, this.parent.height - PADDING);
						}
						
						if(newX > -1 || newY > -1)
						{
							TweenLite.to(child, 0.5, {x: (newX > -1 ? newX : child.x), y: (newY > -1 ? newY : child.y)});
						}
							
					}
					else if((child as Thumbnail) == this.selectedThumbnail)
					{
						child.x = (this.width - ((child as Thumbnail).userBook.pageWidth * 2))/2 + (child as Thumbnail).userBook.pageWidth;
						child.y = (this.height - (child as Thumbnail).userBook.pageHeight)/2;
					}
					
				}
				
			}
		}
		
		protected function _onThumbnailAdded(event:FlexEvent):void
		{
			TweenLite.to(event.target, 1, {rotation: MathUtil.randomInRange(-10, 10)});
		}
		
		protected function _onThumbnailClicked(event:MouseEvent):void
		{
			this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.BOOK_SELECTED, true));
		}
		
		public function get userLibrary():UserLibrary
		{
			return this._userLibrary;
		}
		
		public function set thumbnailsSelectable(selectable:Boolean):void
		{
			for(var i:int = 0; i < this.numElements; i++)
			{
				if(this.getElementAt(i) is Thumbnail)
				{
					(this.getElementAt(i) as Thumbnail).selectable = selectable;
				}
			}
		}
	
	}
}