// -*- mode: SCAD; tab-width: 4; -*-

use <wire_frame.scad>

overlap = 0.2;

upper_wire_spacing = 21;
upper_wire_width = 215;
upper_wire_wires = 4;

shave_cream_diameter = 65.5;
shave_cream_height = 122;

dish_height = 10;
dish_diameter = 1.1 * shave_cream_diameter+2;

drain_channel_depth = 2;
drain_channel_width = 5;

part = "dish"; // [dish, drain]

print_part();

module print_part() {
	if (part == "dish") {
		shave_cream_dish();
    } else if (part == "drain") {
		drain_channels();
    }
}

module shave_cream() {
	cylinder(r=shave_cream_diameter/2+2,h=shave_cream_height,center=true,$fs=0.1);
}

module dish_body() {
	cylinder(r=dish_diameter/2,h=dish_height,center=true,$fs=0.1);
}
	
module drain_channels() {
	for (a = [0:30:330]) {
		rotate([90,0,a])
		hull() {
			translate([ drain_channel_width/2,0,0])
			cylinder(r=drain_channel_depth/2,h=dish_diameter+overlap*2,center=true,$fs=0.1);
			translate([-drain_channel_width/2,0,0])
			cylinder(r=drain_channel_depth/2,h=dish_diameter+overlap*2,center=true,$fs=0.1);
		}
	}
}

module shave_cream_dish() {
	difference() {
		translate([0,0,dish_height/2])
		dish_body();

		translate([0,0,shave_cream_height/2+dish_height/2])
		shave_cream();

		wire_frame(upper_wire_spacing,upper_wire_wires,upper_wire_width);

		translate([0,0,dish_height/2])
		drain_channels();
	}
}
