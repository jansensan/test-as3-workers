package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;


	public class Main extends Sprite
	{
		[Embed(source="secondary.swf", mimeType="application/octet-stream")]
		private var SecondaryClass	:Class;


		private	var	_worker:Worker;
		private var _channelToMain:MessageChannel;
		private var _channelToSecondary:MessageChannel;


		public function Main()
		{
			super();
			initStage();
			if(WorkerDomain.isSupported)
			{
				createMainThread();
			}
			else
			{
				trace("\t", "Capabilities.version: " + (Capabilities.version));
				trace("\t", "Capabilities.isDebugger: " + (Capabilities.isDebugger));
				trace("\t", "WorkerDomain.isSupported: " + (WorkerDomain.isSupported));
			}
		}


		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
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
			trace("\n", this, "---  onMessageReceivedFrom2ndThread  ---");
			
			if(_channelToMain.messageAvailable)
			{
				var message:* = _channelToMain.receive();
				trace("\t", "message: " + (message));
				if(String(message) == "send something back")
				{
					trace("tell 2nd thread all values received");
					_channelToSecondary.send("all values received!");
				}
			}
		}
	}
}
