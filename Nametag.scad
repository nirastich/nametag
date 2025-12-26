/*
    Nametag Generator
    ------------------------
    https://github.com/nirastich/nametag
 
    by Christian Leroch
    www.Leroch.net
    
    License: Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
    https://creativecommons.org/licenses/by-nc/4.0/
 
    You may remix, adapt, and build upon this work non-commercially, as long as you credit the original creator.
    
*/
// preview[view:south, tilt:top]
 
/* [Nametag] */
 
// Name (use double space for new line)
name = "CUSTOM  TEXT";

// Height of the Text (mm)
text_size = 10; //[0.1:0.1:25]

// Rotation of the Name (deg)
text_rotation = 5; //[0:0.1:90]
 
// Height of the Nametag (mm)
tag_height = 50; //[1:1:250]
 
// Width of the Nametag (mm)
tag_width = 80; //[1:1:250]

// Thickness of the Nametag (mm)
tag_depth = 1; //[0.5:0.1:5]
 
/* [Advanced] */

// Font of the text (Makerworld-Fonts, use "Segoe Script" elsewhere)
font = "Permanent Marker"; //["Segoe Script", "Arial:style=Bold", "Permanent Marker", "Kalam:style=Bold", "Protest Riot", "Caveat:style=Bold", "Chewy", "Lacquer", "Julee", "Lobster", "Potta One", "Pacifico"]

// Line spacing multiplier for multi-line names
name_line_spacing = 1.5; //[0:0.1:50]

// Textbox margin x (mm)
margin_x = 2; //[0:0.1:50]
// Textbox margin y (mm)
margin_y = 4; //[0:0.1:50]

// Corner Radius (mm)
corner_radius = 4; //[0:0.1:50]

// Height difference between colors (mm)
color_offset = 0.01; //[0.01:0.01:10]

// Header Text
header_text_1 = "HELLO";
h1_size = 6; //[0:0.1:50]
header_text_2 = "MY NAME IS";
h2_size = 3; //[0:0.1:50]
line_spacing = 2; //[0:0.1:50]
header_margin = 2.5; //[0:0.1:50]
header_font = "Arial:style=Bold";

// Tag Color
tag_color = "red";
// Accent Color
accent_color = "white";
// Text Color
text_color = "black";
 
/* [Hidden] */
 
// Derived
corner_center_offset_x = tag_width/2-corner_radius;
corner_center_offset_y = tag_height/2-corner_radius;
header_height = h1_size + h2_size + 2*header_margin + line_spacing;

function detect_doublespace(s, acc = [], word = "", i = 0) =
    i >= len(s) ? (word == "" ? acc : concat(acc, [word])) :
    (i < len(s)-1 && s[i] == " " && s[i+1] == " ") ?
        (word == "" ?
            detect_doublespace(s, acc, "", i + 2) :
            detect_doublespace(s, concat(acc, [word]), "", i + 2)) :
        detect_doublespace(s, acc, str(word, s[i]), i + 1);

module rotate_around_coord(x, y, z, coord) {
    translate(coord)
        rotate([x, y, z])
            translate(-coord)
                children();   
}

tag();

module tag() {
    union () {
        header();
        rotate_around_coord(0,0,text_rotation,[0,-header_height/2+margin_y/2,0]) name_text();
        text_box();
        tag_background();
    }
}

module name_text() {
    lines = detect_doublespace(name);
    lc = len(lines);
    line_gap = text_size * (name_line_spacing - 1);
    block_h = lc > 0 ? (lc * text_size + max(lc - 1, 0) * line_gap) : 0;

    translate([0, -header_height/2 + margin_y/2, tag_depth/2 + color_offset]) 
        color(text_color) 
        for (i = [0 : lc - 1]) {
            yoff = ((lc - 1) / 2 - i) * (text_size + line_gap);
            translate([0, yoff, 0])
                linear_extrude(color_offset) 
                    text(lines[i], size = text_size, halign = "center", valign = "center", font = font);
        }
}

module header(){
    //HELLO
    translate([0,tag_height/2-header_margin,tag_depth/2]) 
        color(accent_color) 
        linear_extrude(color_offset) 
            text(header_text_1,size=h1_size,halign="center",valign="top",font=header_font);
    
    //MY NAME IS
    translate([0,tag_height/2-header_margin-h1_size-line_spacing,tag_depth/2]) 
        color(accent_color) 
        linear_extrude(color_offset) 
            text(header_text_2,size=h2_size,halign="center",valign="top",font=header_font);
}

module text_box() {
    difference() {
        color(accent_color)
        translate([0,-header_height/2+margin_y/2,tag_depth/2+color_offset/2]) 
            cube([tag_width - 2*margin_x,tag_height-header_height-margin_y,color_offset], center=true);
        difference() {
            translate([-corner_center_offset_x-corner_radius,-corner_center_offset_y-corner_radius,-tag_depth])cube([corner_radius,corner_radius,tag_depth*2+color_offset*2]);
            translate([-corner_center_offset_x,-corner_center_offset_y,-tag_depth]) 
                cylinder(tag_depth*2+color_offset*2,corner_radius,corner_radius,$fn=50);
        }
        difference() {
            translate([corner_center_offset_x,-corner_center_offset_y-corner_radius,-tag_depth])cube([corner_radius,corner_radius,tag_depth*2+color_offset*2]);
            translate([corner_center_offset_x,-corner_center_offset_y,-tag_depth]) 
                cylinder(tag_depth*2+color_offset*2,corner_radius,corner_radius,$fn=50);
        }
    }
}

module tag_background() {
    color(tag_color)
    union() { 
    // top-right corner
        translate([corner_center_offset_x,corner_center_offset_y,0]) 
            cylinder(tag_depth,corner_radius,corner_radius,center=true,$fn=50);
        // top-left corner
        translate([-corner_center_offset_x,corner_center_offset_y,0]) 
            cylinder(tag_depth,corner_radius,corner_radius,center=true,$fn=50);
        // bottom-right corner
        translate([corner_center_offset_x,-corner_center_offset_y,0]) 
            cylinder(tag_depth,corner_radius,corner_radius,center=true,$fn=50);
        // bottom-left corner
        translate([-corner_center_offset_x,-corner_center_offset_y,0]) 
            cylinder(tag_depth,corner_radius,corner_radius,center=true,$fn=50);
        cube([corner_center_offset_x*2, tag_height, tag_depth],center=true);
        cube([tag_width, corner_center_offset_y*2, tag_depth],center=true);
    }
}
