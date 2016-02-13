package {

	public class PhytoplanktonTwo extends Phytoplankton {

		public function PhytoplanktonTwo(world: World, x: int, y: int) {
			newTargetAcquisitionFrequency = 240;
			newTargetAcquisitionFrequencyVariance = 210;
			baseSpeed = 0.2;
			turnRatio = 0.1;
			energyStarting = 120;
			energyForReproduce = 240;
			ageForReproduce = 120;
			ageForDeath = 360;
			entityType = PHYTOPLANKTON_ONE;
			super(world, x, y);
		}

	}

}