// -*- mode: SCAD; tab-width: 4; -*-

overlap = 0.2;
filament_diameter = 1.75;

frame_width = 177;
frame_length = 202;
frame_height = 28;
frame_thickness = filament_diameter * 3;

corner_length = frame_thickness;
corner_width = frame_thickness;
corner_sections = 5;
corner_height = frame_height/corner_sections;

clip_width = 28;
clip_thickness = 5;
clip_height = 20;

slit_width=7.5;
slit_length=frame_height-slit_width-4;
slit_spacing_multiplier = 2.2;

glass_width = frame_width - frame_thickness;
glass_length = frame_length - frame_thickness;
glass_thickness = 1.5;
glass_height = glass_thickness*2;

part = "assembled"; // [assembled, side:frame_side, end:frame_end, odd:corner_odd, even:corner_even, clip, glass, slit]

print_part();

module print_part() {
    if (part == "assembled") {
		frame_assembly();
    } else if (part == "side") {
		frame_side();
    } else if (part == "end") {
		frame_end();
    } else if (part == "odd") {
		corner_odd();
    } else if (part == "even") {
		corner_even();
    } else if (part == "clip") {
		clip();
    } else if (part == "glass") {
		glass();
    } else if (part == "slit") {
		slit();
    }
}

module frame_assembly() {
    translate([0, (frame_width-2*frame_thickness)/2,frame_height/2])
	rotate([90,0,180])
	frame_side();
    translate([0,-(frame_width-2*frame_thickness)/2,frame_height/2])
    rotate([90,0,0])
	frame_side();


    translate([ (frame_length-2*frame_thickness)/2,0,frame_height/2])
    rotate([90,0,90])
	frame_end();
    translate([-(frame_length-2*frame_thickness)/2,0,frame_height/2])
    rotate([90,0,270])
	frame_end();

	// translate([0,0,glass_height])
	// glass();
}

module frame_side() {
    difference() {
	union() {
	    // side beam
	    frame_stock(frame_length);
	    // clip
	    translate([0,clip_height/2,0])
		clip();
	}
	// glass slot
	translate([0,-(frame_height/2-glass_height),-frame_width/2+frame_thickness])
	rotate([90,0,0])
		glass();
	// slits
	slits(5);
	// corners
	translate([ (frame_length/2-corner_width/2),0,0])
	    corner_odd();
	translate([-(frame_length/2-corner_width/2),0,0])
	    corner_even();
    }

}

module frame_end() {
    difference() {
	// end beam
	frame_stock(frame_width);
	// glass slot
	translate([0,-(frame_height/2-glass_height/2),-frame_length/2+frame_thickness])
	rotate([0,90,90])
	    glass();
	// slits
	slits(4);
	// corners
	translate([ (frame_width/2-corner_width/2),0,0])
	    corner_odd();
	translate([-(frame_width/2-corner_width/2),0,0])
	    corner_even();
    }
}

module frame_stock(len) {
    translate([0,0,frame_thickness/2])
    cube([len,frame_height,frame_thickness],center=true);
}

module corner_odd() {
    translate([0,0,frame_thickness/2])
	rotate([90,0,0])
	cylinder(r=filament_diameter/2+overlap*2,h=frame_height+overlap*2,center=true,$fs=0.1);
    for (s = [1:2:corner_sections]) {
	translate([0,-frame_height/2+corner_height/2+(s-1)*corner_height,frame_thickness/2])
	    cube([corner_length+overlap,corner_height+overlap,corner_width+overlap],center=true);
    }
}
module corner_even() {
    translate([0,0,frame_thickness/2])
	rotate([90,0,0])
	cylinder(r=filament_diameter/2+overlap*2,h=frame_height+overlap*2,center=true,$fs=0.1);
    for (s = [2:2:corner_sections]) {
	translate([0,-frame_height/2+corner_height/2+(s-1)*corner_height,frame_thickness/2])
	    cube([corner_length+overlap,corner_height+overlap,corner_width+overlap],center=true);
    }
}
module clip() {
    translate([0,0,clip_thickness/2])
    difference() {
	cube([clip_width,clip_height,clip_thickness],center=true);
	translate([0,-4,clip_thickness/2])
	    cube([clip_width+overlap*2,clip_height,clip_thickness],center=true);
	translate([0,clip_height/2+1,2])
	rotate([45,0,0])
	    cube([clip_width+overlap*2,clip_thickness,clip_thickness*2],center=true);
    }
}
module glass() {
    translate([0,0,glass_thickness/2])
    cube([glass_length,glass_width,glass_thickness],center=true);
}
module slits(n = 4) {
    slit();
    for ( s = [1:n] ) {
	translate([s*slit_width*slit_spacing_multiplier,0,0])
	slit();
	translate([-s*slit_width*slit_spacing_multiplier,0,0])
	slit();
    }
}
module slit() {
    translate([0,0,frame_thickness/2])
    rotate([0,0,45])
    hull() {
		translate([-slit_length/2,0,0])
	    cylinder(r=slit_width/2,h=frame_thickness+overlap*2,center=true,$fs=0.1);
		translate([ slit_length/2,0,0])
	    cylinder(r=slit_width/2,h=frame_thickness+overlap*2,center=true,$fs=0.1);
    }
}