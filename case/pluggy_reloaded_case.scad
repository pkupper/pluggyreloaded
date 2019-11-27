/**********************************/
/*                                */
/*   Pluggy Reloaded Rev.1 Case   */
/*                                */
/**********************************/

///// BEGIN PARAMETERS //////

$fn = 50;

EPSILON = 0.1;

wall_thickness = 1.6;

// distance between moving parts
clearance = 0.2;

// pcb dimensions
board_width = 48.26;
board_length = 83.82;
board_thickness = 1.6;

// total height from pcb underside to ceiling
inner_height = 15;

// lip on top case half to fit halves together
lip_width = 1.6;
lip_height = 2;

// shelf where the pcb rests on
shelf_width = 1.6;
shelf_height = 2;

// portion of the inner_height used by the bottom half of the case
bottom_half_height = 8;

// reset button
button_x = 8.5;
button_y = 30;
button_hole_radius = 2.5;
button_lower_radius = 3;
button_top_radius = 2.2;
button_top_height = 2;
button_pcb_offset = 4.2;

// analog pin header
expansion_header_x = 42;
expansion_header_y = 10.5;
expansion_header_width = 4;
expansion_header_height = 17;

// game gontroller and gigatron ports
d_sub_x = 4.5;
d_sub_z = 1.6;
d_sub_height = 12.5;
d_sub_width = 31;

// usb and micro sd
usb_sd_y = 20;
usb_sd_z = 4;
usb_sd_width = 50; // deliberately oversized to join with PS/2 cutout
usb_sd_height = 4;

// ps/2
ps2_y = 66;
ps2_z = 1.6;
ps2_width = 15;
ps2_height = 13;


/////  END PARAMETERS  //////

///// BEGIN OBJECTS //////

color([0, 0.5, 0, 0.3]) %pcb();
color([0.5, 0.5, 0.5]) top_case();
color([0.3, 0.3, 0.3]) bottom_case();
color([0, 0, 0]) button();

///// END OBJECTS //////

///// BEGIN CODE //////

total_width = board_width + 2 * wall_thickness;
total_length = board_length + 2 * wall_thickness;
total_height = inner_height + shelf_height + 2 * wall_thickness;

top_half_height = inner_height - bottom_half_height;


module pcb()
{
    cube([board_width, board_length, board_thickness]);
}

module top_case()
{
    difference()
    {
        difference()
        {
            union()
            {
                translate([-wall_thickness, -wall_thickness, bottom_half_height])
                {
                    cube([total_width, total_length, top_half_height + wall_thickness]);
                }
                translate([0, 0, bottom_half_height - lip_height])
                {
                    cube([board_width, board_length, bottom_half_height - lip_height]);
                }
            }
            translate([lip_width, lip_width, bottom_half_height - lip_height - EPSILON])
            {
                cube([
                    board_width - 2 * lip_width,
                    board_length - 2 * lip_width,
                    top_half_height + lip_height + EPSILON
                ]);
            }
        }
        cutouts();
        
    }
}

module bottom_case()
{
    difference()
    {
        difference()
        {
            translate([-wall_thickness, -wall_thickness, -wall_thickness - shelf_height])
            {
                cube([total_width, total_length, bottom_half_height + shelf_height + wall_thickness]);
            }
            translate([-clearance, -clearance, 0])
            {
                cube([board_width + 2 * clearance, board_length + 2 * clearance, bottom_half_height + EPSILON]);
            }     
            translate([shelf_width, shelf_width, -shelf_height])
            {
                cube([
                    board_width - 2 * shelf_width,
                    board_length - 2 * shelf_width,
                    shelf_height + EPSILON
                ]);
            }
        }
        cutouts();
        
    }
}

module cutouts()
{
    union()
    {
        // reset button
        translate([
            button_x,
            button_y,
            inner_height - EPSILON
        ])
        {
            cylinder(h = wall_thickness + 2 * EPSILON, r1 = 2.5, r2 = 2.5);
        }
        // analog header
        translate([
            expansion_header_x - expansion_header_width / 2,
            expansion_header_y - expansion_header_height / 2,
            inner_height - EPSILON
        ])
        {
            cube([expansion_header_width, expansion_header_height, wall_thickness + 2 * EPSILON]);
        }
        // d_sub
        translate([d_sub_x, -EPSILON-wall_thickness, d_sub_z])
        {
            cube([d_sub_width, total_length + 2 * EPSILON, d_sub_height]);
        }
        // SD and USB
        translate([
            board_width - lip_width - EPSILON,
            usb_sd_y,
            usb_sd_z
        ])
        {
            cube([lip_width + wall_thickness + 2 * EPSILON, usb_sd_width, usb_sd_height]);
        }
        // PS/2
        translate([
            board_width - lip_width - EPSILON,
            ps2_y,
            ps2_z
        ])
        {
            cube([lip_width + wall_thickness + 2 * EPSILON, ps2_width, ps2_height]);
        }
    }
}

button_lower_height = inner_height - (button_pcb_offset + board_thickness);

module button()
{
    translate([button_x, button_y, button_pcb_offset + board_thickness]) {
        union() {
            cylinder(h=button_lower_height, r1=button_lower_radius, r2=button_lower_radius);
            cylinder(h=button_lower_height + button_top_height, r1=button_top_radius, r2=button_top_radius);
        }
    }
}

///// END CODE //////





