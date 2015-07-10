// -*- mode: SCAD; tab-width: 4; -*-

overlap = 0.2;

shave_cream_diameter = 65.5;
shave_cream_height = 122;

caddy_wire_diameter = 2.4;

lower_caddy_spacing = 17.85;
lower_caddy_width = 0; // TEMP
lower_caddy_wires = 6;
lower_caddy_depth = 70;

upper_caddy_spacing = 21;
upper_caddy_width = 215;
upper_caddy_wires = 4;
upper_caddy_thickness = 10;

caddy_wire_slot_depth = 1;
caddy_diameter = 1.1 * shave_cream_diameter+2;

drain_channel_depth = 2;
drain_channel_width = 5;

part = "shave"; // [soap:lower, shave:upper, drain]

print_part();

module print_part() {
    if (part == "soap") {
		lower_caddy();
    } else if (part == "shave") {
		upper_caddy();
    } else if (part == "drain") {
		upper_caddy_drain_channels();
    }
}

module lower_caddy() {

}

module shave_cream() {
	cylinder(r=shave_cream_diameter/2+2,h=shave_cream_height,center=true,$fs=0.1);
}

module wire_frame(spacing,wires,width) {
	translate([-(wires-1)*spacing/2,0,0])
	for (w = [1:wires]) {
		translate([(w-1)*spacing,0,0])
		rotate([90,0,0])
		scale([2,1,1])
		hull() {
			cube([caddy_wire_diameter,caddy_wire_diameter,width],center=true);
			translate([0,caddy_wire_slot_depth,0])
			cube([caddy_wire_diameter,caddy_wire_diameter,width],center=true);
			// cylinder(r=caddy_wire_diameter/2,h=width,center=true,$fs=0.1);
			// translate([0,caddy_wire_slot_depth,0])
			// cylinder(r=caddy_wire_diameter/2,h=width,center=true,$fs=0.1);
		}
	}
}

module upper_caddy_drain_channels() {
	for (a = [0:30:330]) {
		rotate([90,0,a])
		hull() {
			translate([ drain_channel_width/2,0,0])
			cylinder(r=drain_channel_depth/2,h=caddy_diameter+overlap*2,center=true,$fs=0.1);
			translate([-drain_channel_width/2,0,0])
			cylinder(r=drain_channel_depth/2,h=caddy_diameter+overlap*2,center=true,$fs=0.1);
		}
	}
}

module upper_caddy() {
	difference() {
		translate([0,0,upper_caddy_thickness/2])
		cylinder(r=caddy_diameter/2,h=upper_caddy_thickness,center=true,$fs=0.1);
		translate([0,0,shave_cream_height/2+upper_caddy_thickness/2])
		shave_cream();
		wire_frame(upper_caddy_spacing,upper_caddy_wires,upper_caddy_width);
		translate([0,0,upper_caddy_thickness/2])
		upper_caddy_drain_channels();
	}
}
