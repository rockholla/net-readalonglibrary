package net.readalonglibrary.controllers
{
	import net.readalonglibrary.models.UserLibraryProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ReadBookCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			var bookName:String = notification.getBody() as String;
			(this.facade.retrieveProxy(UserLibraryProxy.NAME) as UserLibraryProxy).loadBook(bookName);
		}
	}
}