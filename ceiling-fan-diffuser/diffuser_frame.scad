overlap = 0.2;
filament_diameter = 1.75;

frame_width = 177;
frame_length = 202;
frame_height = 28;
frame_thickness = filament_diameter *3; // 4; //3;

corner_length = frame_thickness+overlap*2; // 10;
corner_width = frame_thickness+overlap*2; // 10;
corner_sections = 3;

clip_width = 28;
clip_thickness = 5;
clip_height = 20;

slit_width=7.5;
slit_length=frame_height-slit_width-4;
slit_spacing_multiplier = 2.2;

glass_thickness = 1.5;
glass_offset = glass_thickness*2;

part = "assembled"; // [assembled, side:frame_side, end:frame_end, mt1:corner_mt1, mt2:corner_mt2, clip, slit]

print_part();

module print_part() {
    if (part == "assembled") {
	frame_assembly();
    } else if (part == "side") {
	frame_side();
    } else if (part == "end") {
	frame_end();
    } else if (part == "mt1") {
	corner_mt1();
    } else if (part == "mt2") {
	corner_mt2();
    } else if (part == "clip") {
	clip();
    } else if (part == "slit") {
	slit();
    }
}

module frame_assembly() {
    translate([0, frame_width/2,0])
	frame_side();
    translate([0,-frame_width/2,0])
    rotate([0,0,180])
	frame_side();


    translate([-frame_length/2,0,0])
    rotate([0,0,90])
	frame_end();
    translate([ frame_length/2,0,0])
    rotate([0,0,270])
	frame_end();
}

module frame_side() {
    difference() {
	union() {
	    // side beam
	    frame_stock(frame_length+frame_thickness);
	    // clip
	    translate([0,(clip_thickness-frame_thickness)/2,clip_height/2 + frame_height/2])
		clip();

	}
	// glass slot
	translate([0,-frame_width/2,glass_offset])
	    cube([frame_length,frame_width,glass_thickness],center=true);
	// slits
	slits(5);
	// corners
	translate([frame_length/2,0,0])
	    corner_mt1();
	translate([-frame_length/2,0,0])
	    corner_mt2();
    }

}

module frame_end() {
    difference() {
	// end beam
	frame_stock(frame_width+frame_thickness);
	// glass slot
	translate([0,-frame_length/2,glass_offset])
	    cube([frame_width,frame_length,glass_thickness],center=true);
	// slits
	slits(4);
	// corners
	translate([ frame_width/2,0,0])
	    corner_mt1();
	translate([-frame_width/2,0,0])
	    corner_mt2();
    }
}

module frame_stock(len) {
    translate([0,0,frame_height/2])
    cube([len,frame_thickness,frame_height],center=true);
}

module corner_mt1() {
    translate([0,0,frame_height/2])
	cylinder(r=filament_diameter/2+overlap*2,h=frame_height+overlap*2,center=true,$fs=0.1);
    for (s = [1:ceil(corner_sections/2)]) {
	translate([0,0,(frame_height/corner_sections/2)+(2*(s-1)*frame_height/corner_sections)])
	    cube([corner_length,corner_width,frame_height/corner_sections],center=true);
    }
}
module corner_mt2() {
    translate([0,0,frame_height/2])
	cylinder(r=filament_diameter/2+overlap*2,h=frame_height+overlap*2,center=true,$fs=0.1);
    for (s = [2:ceil(corner_sections/2)]) {
	translate([0,0,-(frame_height/corner_sections/2)+(2*(s-1)*frame_height/corner_sections)])
	    cube([corner_length,corner_width,frame_height/corner_sections],center=true);
    }
}
module clip() {
    difference() {
	cube([clip_width,clip_thickness,clip_height],center=true);
	translate([0,clip_thickness/2,-4])
	    cube([clip_width+overlap*2,clip_thickness,clip_height],center=true);
	translate([0,2,clip_height/2+1])
	rotate([45,0,0])
	    cube([clip_width+overlap*2,clip_thickness,clip_thickness*2],center=true);
    }
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
    translate([0,0,frame_height/2])
    rotate([90,45,0])
    hull() {
		translate([-slit_length/2,0,0])
	    cylinder(r=slit_width/2,h=frame_thickness+overlap*2,center=true,$fs=0.1);
		translate([ slit_length/2,0,0])
	    cylinder(r=slit_width/2,h=frame_thickness+overlap*2,center=true,$fs=0.1);
    }
}