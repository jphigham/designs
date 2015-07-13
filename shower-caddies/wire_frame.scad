// -*- mode: SCAD; tab-width: 4; -*-

default_wire_diameter = 2.4;
default_wire_slot_depth = 1;
default_wire_shroud_thickness = 1;

module wire_shroud(spacing,wires,width,diameter=default_wire_diameter)
{
	difference() {
		wire_frame(spacing,wires,width,diameter+default_wire_shroud_thickness/2);
		translate([0,0,-diameter/2])
		
		cube([spacing*wires,width,diameter],center=true);
	}
}

module wire_frame(spacing,wires,width,diameter=default_wire_diameter,hull=true) {
	translate([-(wires-1)*spacing/2,0,0])
	for (w = [1:wires]) {
		translate([(w-1)*spacing,0,0])
		rotate([90,0,0])
		translate([0,diameter/2,0])
		if (hull) {
			hull() {
				cylinder(r=diameter/2,h=width,center=true,$fs=0.1);
				translate([0,-diameter/2,0])
				cube([diameter,diameter,width],center=true);
			}
		} else {
			cylinder(r=diameter/2,h=width,center=true,$fs=0.1);
		}
	}
}

