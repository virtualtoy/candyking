package candyking.utils {
	
	import candyking.sounds.*;
	import flash.utils.Dictionary;
	import net.flashpunk.Sfx;
	
	public class SoundUtil {
		
		private static const _classToSfxDict:Dictionary = new Dictionary();
		private static const _explosions:Vector.<Class> = Vector.<Class>([
			explosion_0,
			explosion_1,
			explosion_2,
			explosion_3,
			explosion_4,
		]);
		
		private static const _hits:Vector.<Class> = Vector.<Class>([
			hit_0,
			hit_1,
			hit_2,
			hit_3,
		]);
		
		private static function play(classType:Class, single:Boolean = false):void {
			var sfx:Sfx = getSfx(classType);
			if (!single || !sfx.playing) {
				sfx.play();
			}
		}
		
		private static function getSfx(classType:Class):Sfx {
			var sfx:Sfx = _classToSfxDict[classType];
			if (!sfx) {
				sfx = 
				_classToSfxDict[classType] = new Sfx(classType);
			}
			return sfx;
		}
		
		public static function playPowerup():void {
			play(powerup);
		}
		
		public static function playShoot():void {
			play(shoot, true);
		}
		
		public static function playExplosion():void {
			var rndIndex:int = Math.random() * _explosions.length;
			play(_explosions[rndIndex]);
		}
		
		public static function playHit():void {
			var rndIndex:int = Math.random() * _hits.length;
			play(_hits[rndIndex]);
		}
		
		public static function playLargeExplosion():void {
			play(explosion_large);
		}
		
		public static function playMusic():void {
			var sfx:Sfx = getSfx(music_track);
			if (!sfx.playing) {
				sfx.loop();
			}
		}
		
		public static function stopMusic():void {
			var sfx:Sfx = getSfx(music_track);
			if (sfx.playing) {
				sfx.stop();
			}
		}
		
	}

}
