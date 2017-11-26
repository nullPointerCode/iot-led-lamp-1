/*
  This file contains the strip that holds the ws2812b led lights
  author: Aliasgar Kutiyanawala
  last modified: 11/26/2017
*/

include <constants.scad>;

module strip(){
         
    difference(){
               
        cube([LENGTH - 2 * WALL_THICKNESS, WIDTH - 2 * WALL_THICKNESS - 0.1, STRIP_HEIGHT], center=true);
        
        //holes for supports
        keyX = LENGTH/2 - WALL_THICKNESS - DISTANCE_OF_HOLE_FROM_EDGE;
        
        translate([keyX, WIDTH/2 - DISTANCE_OF_HOLE_FROM_EDGE, STRIP_HEIGHT/2]){
            cube(KEY_SIZE * 2, center = true);
        }
        
        translate([keyX, -WIDTH/2 + DISTANCE_OF_HOLE_FROM_EDGE, STRIP_HEIGHT/2]){
            cube(KEY_SIZE * 2, center = true);
        }
        
        translate([-keyX, WIDTH/2 - DISTANCE_OF_HOLE_FROM_EDGE, STRIP_HEIGHT/2]){
            cube(KEY_SIZE * 2, center = true);
        }
        
        translate([-keyX, -WIDTH/2 + DISTANCE_OF_HOLE_FROM_EDGE, STRIP_HEIGHT/2]){
            cube(KEY_SIZE * 2, center = true);
        }
        
        //hole for wires
        translate([0, -WIDTH/2 + 2 * KEY_SIZE, STRIP_HEIGHT/2]){
            cube(KEY_SIZE * 1.5, center = true);
        }
    }
             
}

strip();