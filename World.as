package {

	import flash.events.Event;
	import flash.display.Sprite;

	public class World extends Sprite {

		private var entitiesToAdd: Array = new Array();
		private var entities: Array = new Array();

		public function World() {
			addEventListener(Event.ENTER_FRAME, update);
			addEntities(100);
		}

		private function update(e: Event) {
			for (var i: int = entities.length - 1; i >= 0; i--) {
				if (entities[i].isDead) {
					removeEntity(entities[i]);
					entities.splice(i, 1);
				}
				entities[i].update(e);
			}
			while (entitiesToAdd.length > 0) {
				entities.push(entitiesToAdd.pop());
			}
		}

		private function addEntities(phytoplanktonCount: int) {
			for (var i: int = 0; i < phytoplanktonCount; i++) {
				var x: int = Math.random() * 1000;
				var y: int = Math.random() * 600;
				if (Math.random() > 0.3) {

				} else {}

				spawnEntity(Entity.PHYTOPLANKTON_ONE, x, y);
			}
			for each(var entity: Entity in entitiesToAdd) {
				entity.randomizeAgeAndEnergy();
			}
		}

		public function spawnEntity(entityType: int, x: int, y: int) {
			var entity: Entity = null;
			switch (entityType) {
				case Entity.PHYTOPLANKTON_ONE:
					entity = new PhytoplanktonOne(this, x, y);
					break;
				case Entity.PHYTOPLANKTON_TWO:
					entity = new PhytoplanktonTwo(this, x, y);
					break;
			}

			entitiesToAdd.push(entity);
			stage.addChild(entity);
		}
		
		private function removeEntity(entity: Entity) {
			stage.removeChild(entity);
		}

		private function getWaterCurrentSpeed() {
			return 0;
		}

	}

}