/**
 * Hermit Controller firmware
 * (c)2022 Hermit Retro Products Ltd. <https://hermitretro.com>
 *
 * Wired variant of the Hermit Retro Joystick Controller
 */

#define VRX_PIN A1	/** These must be called Ax otherwise analogRead() doesn't work */
#define VRY_PIN A0

#define UP_PIN PIN_B0
#define DOWN_PIN PIN_B1
#define LEFT_PIN PIN_B2
#define RIGHT_PIN PIN_A7
#define FIRE1_PIN PIN_A3
#define FIRE2_PIN PIN_A2

void setup() {

	/** Use VCC as default AREF */
	analogReference( DEFAULT );

	/** UP, DOWN, LEFT, RIGHT digital OUTPUT */
	/** External pull-ups as default state */
	pinMode( UP_PIN, OUTPUT );
	pinMode( DOWN_PIN, OUTPUT );
	pinMode( LEFT_PIN, OUTPUT );
	pinMode( RIGHT_PIN, OUTPUT );

	/** FIRE1, FIRE2 are INPUTs */

	/** VRX, VRY analogue INPUT */
}

void loop() {
	
	/** Joystick */
	uint16_t vry = analogRead( VRY_PIN );
	digitalWrite( UP_PIN, vry > 768 ? LOW : HIGH );
	digitalWrite( DOWN_PIN, vry < 256 ? LOW : HIGH );
	
	uint16_t vrx = analogRead( VRX_PIN );
	digitalWrite( LEFT_PIN, vrx < 255 ? LOW : HIGH );
	digitalWrite( RIGHT_PIN, vrx > 768 ? LOW : HIGH );	
}