package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;


	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="640", height="360")]
	public class Main extends Sprite
	{
		[embed(source="secondary.swf", mimeType="application/octet-stream")]
		private	var	SecondarySWF	:Class;
		
		private	var	_worker			:Worker;
		private	var	_toMainThread	:MessageChannel;
		private	var	_toBGThread		:MessageChannel;
		private	var	_memory			:ByteArray;	// instanciated in bg thread


		// + ----------------------------------------
		//		[ PUBLIC METHODS ]
		// + ----------------------------------------

		public function Main()
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
			
			// create worker
			_worker = WorkerDomain.current.createWorker(new SecondarySWF());
			
			// create message channels
			_toMainThread = _worker.createMessageChannel(Worker.current);
			_toBGThread = Worker.current.createMessageChannel(_worker);
			
			// share with bg thread
			_worker.setSharedProperty("toMainThread", _toMainThread);
			_worker.setSharedProperty("toBGThread", _toBGThread);
			
			// listen to messages sent by bg thread
			_toMainThread.addEventListener(Event.CHANNEL_MESSAGE, onBGThreadMessageReceived);
			
			//
			_worker.start();
			
			// get shared memory from bg thread
			_memory = _toMainThread.receive(true);
			
			// send message to bg thread
			_toBGThread.send("from main");
		}


		// + ----------------------------------------
		//		[ EVENT HANDLERS ]
		// + ----------------------------------------

		private function onBGThreadMessageReceived(_:Event):void
		{
			trace("\n", this, "---  onBGThreadMessageReceived  ---");
			
			if(_toMainThread.messageAvailable)
			{
				var header:String = _toMainThread.receive();
				trace("\t", "header: " + (header));
			}
		}
	}
}
