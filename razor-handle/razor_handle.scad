/*
 * kv2_pencilsPot.scad
 * 
 * Written by aubenc @ Thingiverse
 *
 * This script is licensed under the Creative Commons Atribution-Share Alike license...
 *
 * http://www.thingiverse.com/thing:32173
 *
 * ...and requires the Knurled Surface Finishing Library v2 available at
 *
 * http://www.thingiverse.com/thing:32122
 *
 *	Usage:
 *	
 *		Change the "user parameters" to your desired values.
 *			Tip: Ensure that the pot height is a multiple of the knurl heigth.
 *			Note: The base of the pot has a thickness equal to the height of
 *				one knurl, set infill to a minimum of 20% for stability.
 *		Press F5 to render (it will not work but do it anyway).
 *		Take a look to the console, scroll up if needed until you find
 *			the maximum and minimum diameters echoed by the knurl library.
 *		Update max_diameter and min diameter parameters accordingly.
 *		Compile, it may (will) take some time, and export as STL.
 *		Comment the line for the call to "pencils_pot()" module.
 *		Uncomment the line for "print_test()" module.
 *		Compile the test and export to STL (it should compile much faster).
 *		Try to print first the test and check if you may print the pot or
 *			you better adjust the parameters before.
 *		Enjoy!
 *
 */

/* ********** Required Libraries ************************************************** */

use <knurledFinishLib_v2.scad>


/* ********** User Parameters ***************************************************** */

pot_height		= 120;
pot_diameter	= 80;

knurl_width		= 6;
knurl_height	= 8;
knurl_depth		= 1.5;

ends_smoothing	= knurl_height/2;
surface_smooth	= 50;

wall_thickness = 0.7;
test_height		= 8;


/* ********** From the console echoed by the library ****************************** */

	max_diameter	= 82.25;
	min_diameter	= 79.25;


/* ********** Computed Parameters ************************************************* */

	med_diameter	= (max_diameter+min_diameter)/2;

	s_outer=(med_diameter+wall_thickness)/med_diameter;
	s_inner=(med_diameter-wall_thickness)/med_diameter;


/* ********** Modules ************************************************************* */

//	pencils_pot();
//	print_test();
//	knurl_help();


/* ********** Code **************************************************************** */

module pencils_pot()
{
	difference()
	{
		scale([s_outer,s_outer,1])
		knurl(	k_cyl_hg = pot_height,
					k_cyl_od = pot_diameter,
					knurl_wd = knurl_width,
					knurl_hg = knurl_height,
					knurl_dp = knurl_depth,
					e_smooth = ends_smoothing,
					s_smooth = surface_smooth);

		translate([0,0,knurl_height])
		scale([s_inner,s_inner,1])
		knurled_cyl(	pot_height-knurl_height,
							pot_diameter,
							knurl_width,
							knurl_height,
							knurl_depth,
							ends_smoothing,
							surface_smooth);

		// Uncomment the following two lines to se a section cut of the thing...
		// translate([0,-pot_diameter,pot_height/2])
		// cube(size=[2*pot_diameter,2*pot_diameter,2*pot_height], center=true);
	}
}

module print_test()
{
	rd0=(max_diameter-wall_thickness)/2;
	rd1=rd0-knurl_depth;
	fnn=rd0*PI;

	union()
	{
		difference()
		{
			cylinder(h=0.5, r=rd0, $fn=fnn, center=false);

			translate([0,0,-0.1])
			cylinder(h=0.5+0.2, r=rd1, $fn=fnn, center=false);
		}

		translate([0,0,-2*knurl_height])
		intersection()
		{
			pencils_pot();

			translate([0,0,2*knurl_height+test_height/2])
			cube(size=[2*pot_diameter,2*pot_diameter,test_height], center=true);
		}
	}
}

