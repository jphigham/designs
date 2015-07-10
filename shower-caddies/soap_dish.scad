// -*- mode: SCAD; tab-width: 4; -*-

use <wire_frame.scad>
use <honeycomb.scad>

overlap = 0.2;

lower_wire_spacing = 89/5; //17.85;
lower_wire_width = 70;
lower_wire_wires = 6;

soap_dish_length = 100;
soap_dish_width = 70;
soap_dish_round = 15;
soap_dish_height = 10;
soap_dish_carve_factor = 4;

honeycomb_rows = 12;
honeycomb_cols = 15;
honeycomb_cell = 10;
honeycomb_inner = 1.5;

part = "dish"; // [dish]

print_part();

module print_part() {
	if (part == "dish") {
		soap_dish();
    }
}

module dish_blank(scale=1.0) {
	hull() {
		translate([-soap_dish_length/2+soap_dish_round,-soap_dish_width/2+soap_dish_round,0])
		cylinder(r=soap_dish_round*scale,h=soap_dish_height,$fn=80);
		translate([-soap_dish_length/2+soap_dish_round, soap_dish_width/2-soap_dish_round,0])
		cylinder(r=soap_dish_round*scale,h=soap_dish_height,$fn=80);
		translate([ soap_dish_length/2-soap_dish_round, soap_dish_width/2-soap_dish_round,0])
		cylinder(r=soap_dish_round*scale,h=soap_dish_height,$fn=80);
		translate([ soap_dish_length/2-soap_dish_round,-soap_dish_width/2+soap_dish_round,0])
		cylinder(r=soap_dish_round*scale,h=soap_dish_height,$fn=80);
	}
}

module dish_body() {
	difference() {
		dish_blank();
		
		translate([0,0,soap_dish_length*soap_dish_carve_factor+soap_dish_height/2])
		rotate([90,0,0])
		cylinder(r=soap_dish_length*soap_dish_carve_factor,h=soap_dish_width*1.0+overlap*2,center=true,$fn=1000);
		
        tx = (honeycomb_cols - 1) * honeycomb_cell;
        ty = (honeycomb_rows - 1) * honeycomb_cell * sqrt(3) / 2;
        tz = soap_dish_height/2;
		translate([-tx/2,-ty/2,tz])
		full_honeycomb(honeycomb_rows,honeycomb_cols,honeycomb_cell,honeycomb_inner,soap_dish_height+overlap*2);
	}
	difference() {
		dish_blank();
		dish_blank(0.9);
	}
}
	
module soap_dish() {
	difference() {
		union() {
			dish_body();
			intersection() {
				dish_blank();
				wire_shroud(lower_wire_spacing,lower_wire_wires,lower_wire_width);
			}
		}
		wire_frame(lower_wire_spacing,lower_wire_wires,lower_wire_width);
	}
}
