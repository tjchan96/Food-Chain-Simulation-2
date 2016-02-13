package {

	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Entity extends Sprite {
		public static const NO_TYPE: Number = 0;
		public static const PHYTOPLANKTON_ONE: Number = 1;
		public static const PHYTOPLANKTON_TWO: Number = 2;
		public static const PHYTOPLANKTON_THREE: Number = 3;
		public static const ZOOPLANKTON_ONE: Number = 4;

		private const ANGLE_FUDGE_FACTOR: Number = 0.5;
		private const TARGET_PROXIMITY_FUDGE_FACTOR: Number = 5;
		
		public var isDead: Boolean = false;

		protected var newTargetAcquisitionFrequency: int = 0;
		protected var newTargetAcquisitionFrequencyVariance: int = 0;
		protected var baseSpeed: Number = 0;
		protected var turnRatio: Number = 0;
		protected var energyStarting: Number = 0;
		protected var energyForReproduce: Number = 0;
		protected var ageForReproduce: Number = 0;
		protected var ageForDeath: Number = 0;
		protected var entityType: int = NO_TYPE;

		protected var world: World = null;
		private var targetPoint: Point = null;
		private var newTargetCounter: int = 0;

		private var baseWidth: Number = 0;
		private var baseHeight: Number = 0;
		private var xVelocitySelf: Number = 0;
		private var yVelocitySelf: Number = 0;
		private var xVelocityCurrent: Number = 0;
		private var yVelocityCurrent: Number = 0;
		private var selfPropelledSpeed: Number = 0;
		private var waterCurrentSpeed: Number = 0;
		private var targetDirection: Number = 0;
		private var direction: Number = 0;
		private var waterCurrentDirection: Number = 0;
		private var age: Number = 0;
		protected var energy: Number = 0;

		private var reachedTarget: Boolean = false;

		public function Entity(world: World, x: int, y: int) {
			this.world = world;
			this.x = x;
			this.y = y;
			direction = Math.random() * 360;
			energy = energyStarting;
			baseWidth = width;
			baseHeight = height;
		}
		
		public function randomizeAgeAndEnergy() {
			energy = Math.random() * (energyForReproduce - energyStarting) + energyStarting;
			age = energy;
		}

		public function update(e: Event) {
			calculateAgeAndEnergy();
			if (shouldReproduce()) {
				reproduce();
			}
			calculateMove();
			move();
		}

		protected function calculateAgeAndEnergy() {
			age++;
			energy--;
			if (age > ageForDeath) {
				isDead = true;
			}
			scaleX = age / ageForDeath + 1;
			scaleY = age / ageForDeath + 1;
		}

		private function shouldReproduce() {
			return energy > energyForReproduce && age > ageForReproduce;
		}

		protected function reproduce() {
			world.spawnEntity(entityType, x, y);
			energy = energyStarting;
		}

		private function calculateMove() {
			if (newTargetCounter <= 0) {
				newTargetCounter = newTargetAcquisitionFrequency +
					Math.random() * 2 * newTargetAcquisitionFrequencyVariance - newTargetAcquisitionFrequencyVariance;
				targetPoint = new Point(Math.random() * 1000, Math.random() * 600);
			} else {
				newTargetCounter--;
			}

			selfPropelledSpeed = baseSpeed;
			targetDirection = Math.atan2(targetPoint.y - y, targetPoint.x - x) * 180.0 / Math.PI;

			reachedTarget = Math.abs(targetPoint.y - y) <= TARGET_PROXIMITY_FUDGE_FACTOR || Math.abs(targetPoint.x - x) <= TARGET_PROXIMITY_FUDGE_FACTOR;
		}

		private function move() {
			if (reachedTarget) {
				xVelocitySelf = 0;
				yVelocitySelf = 0;
			} else {
				xVelocitySelf = Math.cos(direction * Math.PI / 180.0) * selfPropelledSpeed;
				yVelocitySelf = Math.sin(direction * Math.PI / 180.0) * selfPropelledSpeed;

				direction = direction % 360;
				direction = getIntermediateAngle(direction, targetDirection, turnRatio);
				rotation = direction;
			}

			x += xVelocitySelf;
			y += yVelocitySelf;

		}

		private function getIntermediateAngle(angle1: Number, angle2: Number, fraction: Number): Number {
			if (Math.abs(angle1 - angle2) <= ANGLE_FUDGE_FACTOR)
				return angle1;
			if (Math.abs(angle1 - angle2) == 180)
				return angle1 + ANGLE_FUDGE_FACTOR;
			var intermediateY: Number = Math.sin(angle1 * Math.PI / 180.0) * (1 - fraction) + Math.sin(angle2 * Math.PI / 180.0) * fraction;
			var intermediateX: Number = Math.cos(angle1 * Math.PI / 180.0) * (1 - fraction) + Math.cos(angle2 * Math.PI / 180.0) * fraction;
			var intermediateAngle: Number = Math.atan2(intermediateY, intermediateX) * 180.0 / Math.PI;
			return intermediateAngle;
		}

	}

}