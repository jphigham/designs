// -*- mode: SCAD; tab-width: 4; -*-

default_wire_diameter = 2.4;
default_wire_slot_depth = 1;

module wire_frame(spacing,wires,width,diameter=default_wire_diameter,depth=default_wire_slot_depth) {
	translate([-(wires-1)*spacing/2,0,0])
	for (w = [1:wires]) {
		translate([(w-1)*spacing,0,0])
		rotate([90,0,0])
		scale([2,1,1])
		hull() {
			cube([diameter,diameter,width],center=true);
			translate([0,depth,0])
			cube([diameter,diameter,width],center=true);
			// cylinder(r=diameter/2,h=width,center=true,$fs=0.1);
			// translate([0,depth,0])
			// cylinder(r=diameter/2,h=width,center=true,$fs=0.1);
		}
	}
}

