

body_width = 100;
body_length = 90;
body_height = 20;

motor_d = 12;
motor_height = 10;
motor_length = 19;
motor_back_offset = 20;
motor_holder_width = 32;

module mirror_copy(vec) {
        mirror(vec) {
            children();
        }
        children();
}


module body() {
    width = body_width;
    length = body_length;
    height = body_height;

    module motor_cutouts() {
        rotate([0, 90, 0]) {
            difference() {
                cylinder(d = motor_d, h = motor_length, center = true);
                
                mirror_copy([1,0,0]) {
                    translate([(motor_height + 2) / 2, 0, 0])
                    cube([2, motor_d, motor_length], center = true);
                }
            }
        }
        
        translate([0, 0, -motor_height / 4])
        cube([motor_length, motor_holder_width, motor_height / 2], center = true);
    }

    difference() {
        union() {
            cube([width, length, height], center = true);
        }
            
        mirror_copy([1, 0, 0]) {
            translate([(width - motor_length) / 2, length / 2 - motor_back_offset, - (height - motor_height) / 2])
            motor_cutouts();
        }
        
    }
}

body();