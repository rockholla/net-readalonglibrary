package net.readalonglibrary.controllers
{
	import flash.filesystem.File;
	
	import net.readalonglibrary.models.UserLibraryProxy;
	import net.readalonglibrary.views.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class StartupCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			this.facade.registerProxy(new UserLibraryProxy());
			this.facade.registerMediator(new ApplicationMediator(notification.getBody() as Main));
		}
	}
}