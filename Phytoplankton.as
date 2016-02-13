package  {
	
	public class Phytoplankton extends Entity {

		public function Phytoplankton(world: World, x: int, y: int) {
			super(world, x, y);
		}
		
		protected override function calculateAgeAndEnergy() {
			super.calculateAgeAndEnergy();
			energy += 2;
		}
		
		protected override function reproduce() {
			world.spawnEntity(entityType, x, y);
			world.spawnEntity(entityType, x, y);
			isDead = true;
		}

	}
	
}
