package
{
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.system.WorkerDomain;
	import flash.system.Worker;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;


	public class Main extends Sprite
	{
		[Embed(source="secondary.swf", mimeType="application/octet-stream")]
		private var SecondaryClass	:Class;


		private	var	_worker	:Worker;


		public function Main()
		{
			initStage();
			initMain();
		}


		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}


		private function initMain():void
		{
			// create worker
			var swf:ByteArray = new SecondaryClass();
			trace("\t", "is swf null: " + (swf == null));
			
			trace("\t", "Capabilities.version: " + (Capabilities.version));
			trace("\t", "Capabilities.isDebugger: " + (Capabilities.isDebugger));
			trace("\t", "WorkerDomain.isSupported: " + (WorkerDomain.isSupported));
			
			_worker = WorkerDomain.current.createWorker(swf);
			trace("\t", "_worker: " + (_worker));
		}
	}
}
