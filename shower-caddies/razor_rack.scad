// -*- mode: SCAD; tab-width: 4; -*-

use <wire_frame.scad>
use <obiscad/bcube.scad>

overlap = .2;

wire_spacing = 45;
wire_width = 215;
wire_num = 2;
wire_diameter = 4; // actual 3.75

razor_handle_diameter = 20; // actual 15

rack_width = razor_handle_diameter + 5;
rack_depth = razor_handle_diameter + 10;
rack_thickness = 3;

part = "rack";

print_part();

module print_part() {
	if (part == "rack") {
		razor_rack();
	}
}

module rack() {
	translate([0/*wire_spacing/4*/,-rack_thickness-rack_depth/2,rack_width/2])
	// scale([1,0.5,1])
	difference() {
		union() {
			rotate([0,90,0])
			bcube([rack_width,rack_depth+5,rack_thickness],cr=10,cres=10);
			translate([0,(rack_depth+5)/4,0])
			cube([rack_thickness,(rack_depth+5)/2,rack_width],center=true);
		}
		translate([0,-5,0])
		rotate([0,90,0])
		cylinder(r=razor_handle_diameter/2,h=rack_thickness+overlap*2,center=true,$fn=50);
	}
}

module rack_body() {
	difference() {
		union() {
			translate([0,-rack_thickness/2,rack_width/2])
			cube([wire_spacing-wire_diameter,rack_thickness,rack_width],center=true);

			translate([wire_spacing/2,-(wire_diameter+rack_thickness)/4,0])
			cylinder(r=(wire_diameter*1.5+rack_thickness)/2,h=rack_width,$fn=50);

			translate([-wire_spacing/2,-(wire_diameter+rack_thickness)/4,0])
			cylinder(r=(wire_diameter*1.5+rack_thickness)/2,h=rack_width,$fn=50);
		}

		translate([wire_spacing/2,-wire_diameter/2,0])
		rotate([0,0,-45])
		translate([-wire_diameter*2,0,rack_width/2])
		cube([wire_diameter*4,wire_diameter,rack_width+overlap*2],center=true);

		translate([-wire_spacing/2,-wire_diameter/2,0])
		rotate([0,0,-135])
		translate([-wire_diameter*2,0,rack_width/2])
		cube([wire_diameter*4,wire_diameter,rack_width+overlap*2],center=true);
	}
}

module razor_rack() {
	difference() {
		rack_body();
		rotate([90,0,0])
		wire_frame(wire_spacing,wire_num,wire_width,wire_diameter,hull=false);
	}
	rack();
}