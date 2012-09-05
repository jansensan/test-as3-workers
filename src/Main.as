package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;


	public class Main extends Sprite
	{
		[Embed(source="secondary.swf", mimeType="application/octet-stream")]
		private var SecondaryClass	:Class;


		private	var	_worker				:Worker;
		private	var	_channelToMain		:MessageChannel;
		private	var	_channelToSecondary	:MessageChannel;


		public function Main()
		{
			super();
			
			// if there is support for workers
			if(WorkerDomain.isSupported)
			{
				createMainThread();
			}
			
			// otherwise trace the capabilities
			else
			{
				trace("\t", "Capabilities.version: " + (Capabilities.version));
				trace("\t", "Capabilities.isDebugger: " + (Capabilities.isDebugger));
				trace("\t", "WorkerDomain.isSupported: " + (WorkerDomain.isSupported));
			}
		}


		private function createMainThread():void
		{
			// create worker
			_worker = WorkerDomain.current.createWorker(new SecondaryClass());
			
			// create message channels
			_channelToMain = _worker.createMessageChannel(Worker.current);
			_channelToSecondary = Worker.current.createMessageChannel(_worker);
			
			// set shared properties
			_worker.setSharedProperty	(	MessageChannelType.TO_MAIN_THREAD, 
											_channelToMain
										);
			_worker.setSharedProperty	(	MessageChannelType.TO_SECONDARY_THREAD, 
											_channelToSecondary
										);
			
			// add event listener to channel
			_channelToMain.addEventListener	(	Event.CHANNEL_MESSAGE, 
												onMessageReceivedFrom2ndThread
											);
			
			// start worker
			_worker.start();
		}


		private function onMessageReceivedFrom2ndThread(_:Event):void
		{
			if(_channelToMain.messageAvailable)
			{
				var message:* = _channelToMain.receive();
				if(message is String)
				{
					var str:String = String(message);
					trace("\t", "message: " + (str));
					
					if(str == MessageID.START_TRANSFER)
					{
						trace("\t", "number: " + (_channelToMain.receive()));
						trace("\t", "array: " + (_channelToMain.receive()));
						trace("\t", "object: " + (_channelToMain.receive()));
						_channelToSecondary.send(MessageID.CONFIRM_RECEPTION);
					}
					if(str == MessageID.TEN_FOUR)
					{
						trace("all data received, secondary thread confirmed reception");
					}
				}
			}
		}
	}
}
