package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class Secondary extends Sprite
	{
		private var _channelToMain:MessageChannel;
		private var _channelToSecondary:MessageChannel;


		public function Secondary()
		{
			super();
			initSecondaryThread();
		}


		private function initSecondaryThread():void
		{
			// get shared properties
			_channelToMain = Worker.current.getSharedProperty(MessageChannelType.TO_MAIN_THREAD);
			_channelToSecondary = Worker.current.getSharedProperty(MessageChannelType.TO_SECONDARY_THREAD);
			
			// add event listener to channel
			_channelToSecondary.addEventListener	(	Event.CHANNEL_MESSAGE, 
														onMessageReceivedFrom1stThread
													);
			
			// send some values to main thread
			_channelToMain.send("initial send");
			_channelToMain.send(1);
			_channelToMain.send([1, 2, 3]);
			_channelToMain.send({});
			_channelToMain.send("send something back");
		}


		private function onMessageReceivedFrom1stThread(_:Event):void
		{
			if(_channelToSecondary.messageAvailable)
			{
				var message:* = _channelToSecondary.receive();
				if(String(message) == "all values received!")
				{
					_channelToMain.send("10-4!");
				}
			}
		}
	}
}
