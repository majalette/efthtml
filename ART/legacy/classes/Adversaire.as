package {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.coreyoneil.collision.CollisionList;

	public class Adversaire extends Sprite {

		private static var touches:Object;
		private var _collisionList:CollisionList;
		private var vie:MovieClip;
		private var player1:MovieClip;
		private var player2:MovieClip;
		private var peutDonnerCoup:Boolean=false; 
		private var peutMarcher:Boolean=true; 
		private var tableauAction:Array = new Array("stance","kicking", "punching");
 		private var memoireCoup:String;
		private var hasard:Number;
 		private var hasardCoup:Number;
		private var timerCoups:Timer;
		
		

		public function Adversaire(_player1:MovieClip, _player2:MovieClip, _barreDeVie:MovieClip) {

			player1=_player1;
			player2=_player2;
			vie=_barreDeVie;
			
			
			_collisionList = new CollisionList(player2);
			_collisionList.addItem(player1);
			
			hasardCoup=Math.round(Math.random()*500);
			timerCoups= new Timer(hasardCoup);
			
			this.addEventListener(Event.ADDED_TO_STAGE, adversaireActif);
			this.addEventListener(Event.REMOVED_FROM_STAGE, adversaireInactif);
		}
		
		private function adversaireActif(evt:Event):void{
		player1.addEventListener(Event.ENTER_FRAME, reAction);
		timerCoups.addEventListener(TimerEvent.TIMER,lesAutresCoups);
		}
		
		private function adversaireInactif(evt:Event):void{
		player1.removeEventListener(Event.ENTER_FRAME, reAction);
		timerCoups.removeEventListener(TimerEvent.TIMER,lesAutresCoups);
		}
		
				
		
		function reAction( pEvt:Event ):void {
		
			if (player2.being_hit_high){
				player2.being_hit_high.addEventListener(Event.ENTER_FRAME, finClip);
			}
			
			if (player2.being_hit_low){
				player2.being_hit_low.addEventListener(Event.ENTER_FRAME, finClip);
			}
			
			
			if (pEvt.target.x>player2.x){
				player2.scaleX=0.4;
			
			
				if ((pEvt.target.x-140)>player2.x && (peutMarcher==true)) {
				
					player2.x+=4;
					player2.gotoAndStop("walk");
			
					
				}
				
				if (pEvt.target.x-140<player2.x && (peutMarcher==true)){
				
				
					player2.gotoAndStop("walkBack");		
					player2.x-=4;
				}
				
				
				if ((pEvt.target.x-140)==player2.x && (peutDonnerCoup==false && peutMarcher==true)){
					
					peutMarcher=false;
					peutDonnerCoup=true;
				}
				
				
				if ((pEvt.target.x-120)<player2.x || (pEvt.target.x-180)>player2.x ){
					
					peutMarcher=true;
					peutDonnerCoup=false;
	
				}
				
												
				
				
				if ((pEvt.target.x-180)<player2.x && (peutDonnerCoup==true)){
				hasard=Math.round(Math.random()*2);
				player2.gotoAndStop(tableauAction[hasard]);
				
				peutDonnerCoup=false;
			
				memoireCoup=tableauAction[hasard];
					if (memoireCoup=="punching"){
						
							var collisionPoing:Array = _collisionList.checkCollisions();
							if(collisionPoing.length){
									vie.scaleX-=0.05;
									pEvt.target.gotoAndStop("being_hit_high");
							}
						player2.punching.addEventListener(Event.ENTER_FRAME, finClip);
					}
					if (memoireCoup=="kicking"){
						
						var collisionPied:Array = _collisionList.checkCollisions();
						if(collisionPied.length){
							
									vie.scaleX-=0.1;
									pEvt.target.gotoAndStop("being_hit_low");
									
							
						}
						
						player2.kicking.addEventListener(Event.ENTER_FRAME, finClip);
					}
					if (memoireCoup=="stance"){
					timerCoups.start();
					}
			
				}
				

			}
			
			
			
			if (pEvt.target.x<player2.x){
			player2.scaleX=-0.4;
			
				if ((pEvt.target.x+140)<player2.x && (peutMarcher==true)) {
				
					player2.x-=4;
					
					player2.gotoAndStop("walk");
					
					
					
					
				}
				
				if ((pEvt.target.x+140)>player2.x && (peutMarcher==true)){
					player2.x+=4;
					player2.gotoAndStop("walkBack");	
					
				}
				
				if ((pEvt.target.x+140)==player2.x && peutDonnerCoup==false && peutMarcher==true){
				
					peutMarcher=false;
					peutDonnerCoup=true;
	
				}
				
				
				
				
				if ((pEvt.target.x+120)>player2.x || (pEvt.target.x+180)<player2.x ){
					
					peutMarcher=true;
					peutDonnerCoup=false;
					timerCoups.stop();
	
				}
								
				if ((pEvt.target.x+180)>player2.x && (peutDonnerCoup==true)){
					hasard=Math.round(Math.random()*2);
					trace (hasard);
					player2.gotoAndStop(tableauAction[hasard]);
					
					peutDonnerCoup=false;
				
					memoireCoup=tableauAction[hasard];
						if (memoireCoup=="punching"){
							
							var collisionPoing2:Array = _collisionList.checkCollisions();
							if(collisionPoing2.length){
									vie.scaleX-=0.05;
									pEvt.target.gotoAndStop("being_hit_high");
	
							}
							
							
										
							player2.punching.addEventListener(Event.ENTER_FRAME, finClip);
						}
						if (memoireCoup=="kicking"){
							player2.kicking.addEventListener(Event.ENTER_FRAME, finClip);
						
									var collisionPied2:Array = _collisionList.checkCollisions();
								if(collisionPied2.length){
			
											vie.scaleX-=0.1;
											pEvt.target.gotoAndStop("being_hit_low");
											
								}
						}
						if (memoireCoup=="stance"){
						timerCoups.start();
						}			
				}
				
			}
			
			
			

		}
		
		function finClip(e:Event):void {
			if (e.currentTarget.currentFrame>=e.currentTarget.totalFrames) {
				e.currentTarget.removeEventListener(Event.ENTER_FRAME, finClip);
						timerCoups.start();
	

			}

		}
		
		
		
		
	
		
		
	function lesAutresCoups (e:TimerEvent):void{
		
				timerCoups.stop();
				hasard=Math.round(Math.random()*2);
				player2.gotoAndStop(tableauAction[hasard]);
				hasardCoup=(Math.round(Math.random()*500));
				timerCoups.delay=hasardCoup;
				
				memoireCoup=tableauAction[hasard];
				if (memoireCoup=="punching"){
				player2.punching.addEventListener(Event.ENTER_FRAME, finClip);
				
						var collisionPoing:Array = _collisionList.checkCollisions();
							if(collisionPoing.length){
						
									vie.scaleX-=0.05;
									player1.gotoAndStop("being_hit_high");
									
	
							}
				
				}
				if (memoireCoup=="kicking"){
				player2.kicking.addEventListener(Event.ENTER_FRAME, finClip);
				
						var collisionPied:Array = _collisionList.checkCollisions();
								if(collisionPied.length){
											vie.scaleX-=0.1;
											player1.gotoAndStop("being_hit_low");
											
								}
				}
				if (memoireCoup=="stance"){
				timerCoups.start();
				}
		
	}


	}
}