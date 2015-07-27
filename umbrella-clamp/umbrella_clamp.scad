// -*- mode: SCAD; tab-width: 4; -*-


overlap = .2;

function in2mm( in ) = in * 25.4;

chair_mount_diam = 16.25;
chair_mount_height = in2mm( 6 );

chair_back_height = in2mm( 36 );
chair_seat_height = in2mm( 17 );

chair_width = in2mm( 17.5 );

umbrella_handle_diam = 35;
umbrella_handle_height = in2mm( 5.5 );

umbrella_shaft_diam = 16.25; // TEMP
umbrella_shaft_height = in2mm( 40 );
umbrella_tip_height = in2mm( 4 );

umbrella_canopy_height = in2mm( 12 );
// spherical cap: r = (a**2 + h**2)/2h
umbrella_canopy_diam = in2mm( (pow(24,2) + pow(12,2))/12 );

umbrella();
//chair_frame();

module umbrella_handle() {
    cylinder(r=umbrella_handle_diam/2,h=umbrella_handle_height);
}

module umbrella_shaft() {
    cylinder(r=umbrella_shaft_diam/2,h=umbrella_shaft_height);
}

module umbrella_canopy() {
	translate([0,0,-umbrella_canopy_diam/2+umbrella_canopy_height])
    difference() {
	sphere(r=umbrella_canopy_diam/2);
	sphere(r=umbrella_canopy_diam/2*.99);
	translate([0,0,-umbrella_canopy_height/2])
	cube([umbrella_canopy_diam+overlap,
		  umbrella_canopy_diam+overlap,
		  umbrella_canopy_diam-umbrella_canopy_height],center=true);
    }
}

module umbrella() {
	translate([0,0,umbrella_shaft_height-umbrella_canopy_height-umbrella_tip_height])
    umbrella_canopy();
    umbrella_shaft();
    umbrella_handle();
}

module chair_mount() {
    cylinder(r=chair_mount_diam/2,h=chair_mount_height);
}

module chair_frame() {
    for ( x = [-chair_width/2,chair_width/2])
    translate([x,0,0])
    chair_mount();
}

