package net.readalonglibrary.models
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import net.readalonglibrary.views.ApplicationMediator;

	public class UserLibrary extends EventDispatcher
	{
		
		public static const LIBRARY_PATH:String = File.documentsDirectory.nativePath + "/Read-Along Library/";
		
		public var userBooks:ArrayCollection = new ArrayCollection();
		
		protected var _userLibraryProxy:UserLibraryProxy;
		protected var _initialized:Boolean = false;
		protected var _thumbnailsLoaded:Number = 0;
		
		public var loadedBook:UserBook;
		
		public function UserLibrary(directoryPath:String, userLibraryProxy:UserLibraryProxy):void
		{
			var libraryDirectory:File = new File(directoryPath);
			
			if(!libraryDirectory.exists)
			{
				libraryDirectory.createDirectory();
			}
			
			trace("Library native path: " + libraryDirectory.nativePath);
			
			this._userLibraryProxy = userLibraryProxy;
			var directoryListing:Array = libraryDirectory.getDirectoryListing();
			for(var i:int = 0; i < directoryListing.length; i++)
			{
				var item:File = directoryListing[i] as File;
				if(item.isDirectory && !item.isHidden)
				{
					this.userBooks.addItem(new UserBook(item.nativePath, this));
				}
			}
			
			this._initialized = true;
			
		}
		
		public function onThumbnailLoaded(event:Event):void
		{
			if(!this._initialized) return;
			this._thumbnailsLoaded++;
			if(this._thumbnailsLoaded == this.userBooks.length)
			{
				this._userLibraryProxy.sendNotification(ApplicationMediator.LIBRARY_LOADED);
			}
		}
		
		public function onBookLoaded(userBook:UserBook):void
		{
			this.loadedBook = userBook;
			this._userLibraryProxy.sendNotification(ApplicationMediator.BOOK_LOADED);
		}
		
	}
}