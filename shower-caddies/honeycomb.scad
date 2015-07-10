// copyright misty soul 2012
// distributed under the terms of the
// CreativeCommons Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)


// number of rows and columns, beware that some hexagonal cells are clipped
// at rectangular box boundaries, so the total number of cells will be
// smaller than rows * columns
rows          = 5;
columns       = 5;

// cell step is hole size between opposite hexagon walls plus inner wall thickness
cell_step     = 20;

// inner depth of the hexagonal boxes
height        = 15;

// walls thickness
inner_walls   = 1.5;
outer_walls   = 2;

// this clearance should allow fitting of the lid over the bottom box
lid_clearance = 0.6;

// how far does the lid protrube inside the bottom box
lid_depth     = 5;

module honeycomb_row(cells, cell_step, inner_walls, height) {
    translate([0, 0, -height/2])
    linear_extrude(height=height) {
        for (j = [0 : cells - 1]) {
            translate([j * cell_step, 0, 0]) rotate([0,0,30])
            circle(r=(cell_step - inner_walls)/sqrt(3),$fn=6);
        }
    }
}


module full_honeycomb(rows, columns, cell_step, inner_walls, height) {
    for (i = [0 : rows - 1]) {
        translate([(i % 2) * cell_step / 2, cell_step * i * sqrt(3) / 2, 0])
        honeycomb_row(columns, cell_step, inner_walls, height);
    }
}

module clipped_honeycomb(rows, columns, cell_step, inner_walls, height) {
    intersection() {
        cube([(columns - 1) * cell_step, (rows - 1) * cell_step * sqrt(3) / 2, height]);
        full_honeycomb(rows, columns, cell_step, inner_walls, 3 * height);
    }
}

module bottom_part(rows, columns, cell_step, inner_walls, outer_walls, height) {
    translate([0, 0, outer_walls])
    difference() {
        translate([-outer_walls, -outer_walls, -outer_walls])
        cube([(columns - 1) * cell_step + 2 * outer_walls,
              (rows - 1) * cell_step * sqrt(3) / 2 + 2 * outer_walls,
              height + outer_walls]);
        clipped_honeycomb(rows, columns, cell_step, inner_walls, 2 * height);
    }
}

module top_part(rows, columns, cell_step, inner_walls, outer_walls, height, lid_clearance) {
    translate([-(cell_step + outer_walls), 0, height + 2 * outer_walls])
    rotate([0,180,0])
    difference() {
        translate([-((2 * outer_walls) + lid_clearance),
                   -((2 * outer_walls) + lid_clearance),
                   height + outer_walls - lid_depth])
            cube([(columns - 1) * cell_step + 4 * outer_walls + 2 * lid_clearance,
                  (rows - 1) * cell_step * sqrt(3) / 2 + 4 * outer_walls + 2 * lid_clearance,
                  outer_walls + lid_depth]);
        bottom_part(rows,columns, cell_step, inner_walls + lid_clearance, outer_walls + lid_clearance, height);
    }
}

bottom_part(rows, columns, cell_step, inner_walls, outer_walls, height);

top_part(rows, columns, cell_step, inner_walls, outer_walls, height, lid_clearance);


