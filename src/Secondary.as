package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;


	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="640", height="360")]
	public class Secondary extends Sprite
	{
		private	var	_memory			:ByteArray;
		private	var	_toMain			:MessageChannel;
		private	var	_toBGThread		:MessageChannel;


		// + ----------------------------------------
		//		[ PUBLIC METHODS ]
		// + ----------------------------------------

		public function Secondary()
		{
			initStage();
			init();
		}


		// + ----------------------------------------
		//		[ PRIVATE METHODS ]
		// + ----------------------------------------

		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}


		private function init():void
		{
			trace("\n", this, "---  init  ---");
			
			// create shared memory
			_memory = new ByteArray();
			_memory.shareable = true;
			
			// get message channels created in main thread
			_toMain = Worker.current.getSharedProperty("toMainThread");
			_toBGThread = Worker.current.getSharedProperty("toBGThread");
			
			// listen to messages sent by main thread
			_toBGThread.addEventListener	(	Event.CHANNEL_MESSAGE, 
												onMainThreadMessageReceived
											);
		}


		// + ----------------------------------------
		//		[ EVENT HANDLERS ]
		// + ----------------------------------------

		private function onMainThreadMessageReceived(_:Event):void
		{
			trace("\n", this, "---  onMainThreadMessageReceived  ---");
			
			if(_toBGThread.messageAvailable)
			{
				var header:String = _toBGThread.receive();
				trace("\t", "header: " + (header));
			}
		}
	}
}
