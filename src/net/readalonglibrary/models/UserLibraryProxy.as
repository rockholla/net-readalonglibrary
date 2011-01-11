package net.readalonglibrary.models
{
	import net.readalonglibrary.views.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class UserLibraryProxy extends Proxy implements IProxy
	{
		
		public static const NAME:String = "userLibraryProxy";
		
		public function UserLibraryProxy()
		{
			super(NAME, new UserLibrary(UserLibrary.LIBRARY_PATH, this));
		}
		
		public function get userLibrary():UserLibrary
		{
			return this.data as UserLibrary;
		}
		
		public function loadBook(name:String):void
		{
			for(var i:int = 0; i < this.userLibrary.userBooks.length; i++)
			{
				var book:UserBook = this.userLibrary.userBooks.getItemAt(i) as UserBook;
				if(book.name == name)
				{
					book.loadAll();
				}
			}
		}
	}
}