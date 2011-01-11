package net.readalonglibrary.views
{
	import com.rubenswieringa.book.Book;
	import com.rubenswieringa.book.BookEvent;
	import com.rubenswieringa.book.Page;
	
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.controls.Image;
	import mx.events.ResizeEvent;
	
	import net.patrickforce.controls.Button;
	import net.readalonglibrary.ApplicationFacade;
	import net.readalonglibrary.events.ReadAlongLibraryEvent;
	import net.readalonglibrary.models.PageContent;
	import net.readalonglibrary.models.UserBook;
	
	import spark.components.Group;
	import spark.primitives.Rect;
	
	public class ReaderDisplay extends Group
	{
		
		public var thumbnail:Thumbnail;
		public var controls:ReaderDisplayControls = new ReaderDisplayControls();
		
		public function ReaderDisplay()
		{
			super();
			
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.alpha = 0.7;
			dropShadow.strength = 0.8;
			dropShadow.distance = 25;
			dropShadow.blurX = 25;
			dropShadow.blurY = 25;
			dropShadow.angle = 120;
			var filters:Array = new Array();
			filters.push(dropShadow);
			this.filters = filters;
			
			this.addEventListener(ResizeEvent.RESIZE, this._onResize);
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

			this.addElement(this.controls);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.5);
			this.graphics.drawRect(0, 0, this.parent.width, this.parent.height);
			this.graphics.endFill();
			
			this.controls.top = 10;
			this.controls.right = 20;
		}
		
		protected function _onResize(event:ResizeEvent):void
		{
			for(var i:int = 0; i < this.numElements; i++)
			{
				if(this.getElementAt(i) is Book)
				{
					this.getElementAt(i).x = (this.width - (this.thumbnail.userBook.pageWidth * 2))/2;
					this.getElementAt(i).y = (this.height - this.thumbnail.userBook.pageHeight)/2;
				}
			}
		}
		
		public function addBook(userBook:UserBook):void
		{
			var book:Book = new Book();
			book.useHandCursor = true;
			book.buttonMode = true;
			book.openAt = 0;
			book.autoFlipDuration = 300;
			book.easing = 0,7;
			book.regionSize = userBook.pageWidth/2 + 50;
			book.sideFlip = true;
			book.hardCover = true;
			book.snap = false;
			book.flipOnClick = true;
			book.width = userBook.pageWidth * 2;
			book.height = userBook.pageHeight;
			book.x = (ApplicationFacade.getInstance().application.width - book.width)/2;
			book.y = (ApplicationFacade.getInstance().application.height - book.height)/2;
			book.addEventListener(BookEvent.BOOK_OPENED, this._onBookOpened);
			
			for(var i:int = 0; i < userBook.pages.length; i++)
			{
				var image:Image = new Image();
				image.source = (userBook.pages.getItemAt(i) as PageContent).content;
				var page:Page = new Page();
				page.hard = true;
				page.addChild(image);
				book.addChild(page);
			}
			
			if(userBook.audio != null)
			{
				this.audioControlsEnabled = true;
			}
			else
			{
				this.audioControlsEnabled = false;
			}

			this.addElementAt(book, 0);
		}
		
		protected function _onBookOpened(event:BookEvent):void
		{
			this.dispatchEvent(new ReadAlongLibraryEvent(ReadAlongLibraryEvent.PLAY_AUDIO));
		}
		
		public function removeBook():void
		{
			for(var i:int = 0; i < this.numElements; i++)
			{
				if(this.getElementAt(i) is Book)
				{
					(this.getElementAt(i) as Book).removeEventListener(BookEvent.BOOK_OPENED, this._onBookOpened);
					this.removeElementAt(i);
				}
			}
		}
		
		public function set audioControlsEnabled(enable:Boolean):void
		{
			this.controls.audioEnabled = enable;
		}
	}
}