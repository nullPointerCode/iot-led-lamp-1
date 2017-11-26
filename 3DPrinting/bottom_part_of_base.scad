/*
  This file contains the bottom part of the base that houses the raspberry pi zero w
  and the led lights
  author: Aliasgar Kutiyanawala
  last modified: 11/26/2017
*/
include <constants.scad>;

$fn=100;

module hollow_box(length, width, height, thickness){
    difference(){
        cube([length, width, height], center=true);
        translate([0, 0, thickness/2]){
            cube([length - 2 * thickness, width - 2 * thickness, height], center=true);
        }
    }
}


//columns for the raspberry pi zero
module raspi(){
    translate([0, 0, 0]){
        cylinder(h=HEIGHT_OF_HALF_WALL/2, r1=HOLE_RADIUS, r2=HOLE_RADIUS);
    }
    translate([0, RASPI_WIDTH, 0]){
        cylinder(h=HEIGHT_OF_HALF_WALL/2, r1=HOLE_RADIUS, r2=HOLE_RADIUS);
    }
    translate([RASPI_LENGTH, 0, 0]){
        cylinder(h=HEIGHT_OF_HALF_WALL/2, r1=HOLE_RADIUS, r2=HOLE_RADIUS);
    }
    translate([RASPI_LENGTH, RASPI_WIDTH, 0]){
        cylinder(h=HEIGHT_OF_HALF_WALL/2, r1=HOLE_RADIUS, r2=HOLE_RADIUS);
    }    
}


module base(){
    union(){
        //columns for the raspberry pi zero w
        translate([-RASPI_LENGTH/2, -RASPI_WIDTH/2, -BASE_HEIGHT/2 + WALL_THICKNESS/2 - 1]){
            raspi();
        }
                
        difference(){
            hollow_box(LENGTH, WIDTH, BASE_HEIGHT, WALL_THICKNESS/2);
            //cutout to access raspi ports
            translate([0, WIDTH/2, -BASE_HEIGHT/2 + BASE_HEIGHT/4]){
                cube([RASPI_LENGTH, 2 * WALL_THICKNESS, BASE_HEIGHT/2], center=true);
            }
        }
        
        //support for the strip that holds the led lights
        translate([LENGTH/2 - 2 * WALL_THICKNESS, 0, -BASE_HEIGHT/2 + HEIGHT_OF_HALF_WALL/2]){
            cube([4 * WALL_THICKNESS, WIDTH, HEIGHT_OF_HALF_WALL], center=true);
        }
        
        //support for the strip that holds the led lights
        translate([-LENGTH/2 + 2 * WALL_THICKNESS, 0, -BASE_HEIGHT/2 + HEIGHT_OF_HALF_WALL/2]){
            cube([4 * WALL_THICKNESS, WIDTH, HEIGHT_OF_HALF_WALL], center=true);
        }
        
        
        //keys that fit in the slot of the top part
        keyX = LENGTH/2 - WALL_THICKNESS - DISTANCE_OF_HOLE_FROM_EDGE;
        
        //top part of key
        translate([keyX, WIDTH/2 - DISTANCE_OF_HOLE_FROM_EDGE, BASE_HEIGHT/2]){
            cube(KEY_SIZE, center = true);
        }
        //bottom part of key
        translate([keyX, WIDTH/2 - DISTANCE_OF_HOLE_FROM_EDGE, 0]){
            cube([KEY_SIZE, KEY_SIZE, BASE_HEIGHT] , center = true);
        }
        
        //top part of key
        translate([keyX, -WIDTH/2 + DISTANCE_OF_HOLE_FROM_EDGE, BASE_HEIGHT/2]){
            cube(KEY_SIZE, center = true);
        }
        //bottom part of key
        translate([keyX, -WIDTH/2 + DISTANCE_OF_HOLE_FROM_EDGE, 0]){
            cube([KEY_SIZE, KEY_SIZE, BASE_HEIGHT] , center = true);
        }
        
        //top part of key
        translate([-keyX, WIDTH/2 - DISTANCE_OF_HOLE_FROM_EDGE, BASE_HEIGHT/2]){
            cube(KEY_SIZE, center = true);
        }
        //bottom part of key
        translate([-keyX, WIDTH/2 - DISTANCE_OF_HOLE_FROM_EDGE, 0]){
            cube([KEY_SIZE, KEY_SIZE, BASE_HEIGHT] , center = true);
        }
        
        //top part of key
        translate([-keyX, -WIDTH/2 + DISTANCE_OF_HOLE_FROM_EDGE, BASE_HEIGHT/2]){
            cube(KEY_SIZE, center = true);
        }
        //bottom part of key
        translate([-keyX, -WIDTH/2 + DISTANCE_OF_HOLE_FROM_EDGE, 0]){
            cube([KEY_SIZE, KEY_SIZE, BASE_HEIGHT] , center = true);
        }
    }
    
}

base();