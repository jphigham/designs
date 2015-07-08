// -*- mode: SCAD; tab-width: 4; -*-

pad = 0.1;

bumper_diameter = 19;

bumper_height = 12.3;

peg_diameter = 6.5;

peg_height = 8;

rnd = 4.7;

$fn = 0;
$fa = 0.01;
$fs = 0.3;

bumper();

module peg() {
	cylinder(h = peg_height, d = peg_diameter);
}

module body_fillet() {
	difference() {
		rotate_extrude(convexity = 10)
		translate([bumper_diameter/2-rnd+pad,-pad,0])
		square(rnd+pad,rnd+pad);

		rotate_extrude(convexity = 10)
		translate([bumper_diameter/2-rnd,rnd,0])
		circle(r = rnd);
	}
}

module body() {
	difference() {
		cylinder(h = bumper_height, d = bumper_diameter);
		body_fillet();
	}
}

module bumper() {
	translate([0,0,bumper_height]) peg();
	body();
}
