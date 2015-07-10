// -*- mode: SCAD; tab-width: 4; -*-

use <wire_frame.scad>
use <honeycomb.scad>

overlap = 0.2;

upper_wire_spacing = 62/3; //21;
upper_wire_width = 215;
upper_wire_wires = 4;

shave_cream_diameter = 65.5;
shave_cream_height = 122;

dish_height = 10;
dish_diameter = 1.1 * shave_cream_diameter+2;

honeycomb_rows = 15;
honeycomb_cols = 15;
honeycomb_cell = 10;
honeycomb_inner = 1.5;

part = "dish"; // [dish]

print_part();

module print_part() {
	if (part == "dish") {
		shave_cream_dish();
    }
}

module shave_cream() {
	cylinder(r=shave_cream_diameter/2+2,h=shave_cream_height,center=true,$fs=0.1);
}

module dish_blank() {
	cylinder(r=dish_diameter/2,h=dish_height,center=true,$fs=0.1);
}
	
module dish_body() {
	difference() {
		translate([0,0,dish_height/2])
		dish_blank();

        tx = (honeycomb_cols - 1) * honeycomb_cell;
        ty = (honeycomb_rows - 1) * honeycomb_cell * sqrt(3) / 2;
        tz = dish_height/2;
		translate([-tx/2,-ty/2,tz])
		full_honeycomb(honeycomb_rows,honeycomb_cols,honeycomb_cell,honeycomb_inner,dish_height+overlap*2);

		translate([0,0,shave_cream_height/2+dish_height/2])
		shave_cream();
	}
	difference() {
		translate([0,0,dish_height/2])
		dish_blank();
		translate([0,0,0])
		shave_cream();
	}
}

module shave_cream_dish() {
	difference() {
		union() {
			dish_body();
			intersection() {
				dish_blank();
				wire_shroud(upper_wire_spacing,upper_wire_wires,upper_wire_width);
			}
		}
		wire_frame(upper_wire_spacing,upper_wire_wires,upper_wire_width);
	}
}
